package com.model2.mvc.web.product;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.filters.ExpiresFilter.XServletOutputStream;
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.model2.mvc.common.Message;
import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.common.util.CommonUtil;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

@Controller
@RequestMapping("/product/*")
public class ProductController {
	
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService service;
	
	/// root WebApplicationContext에 저장된 properties 값 로드...
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	private static final int unitKB = 1024;
	/*
	 *  file 경로에 대하여
	 *  	절대경로 :: origin에서 절대경로로 접근하는 것은 아무런 문제가 되지 않음.
	 *  	상대경로 :: 외부에서 절대경로로 접근 막혀있음. 대신 context root로부터의 상대경로 접근은 허용됨.
	 */
	// private static final String relativeImagePath = "\\images\\uploadFiles\\";
	// private static final String imagePath = "\\images\\uploadFiles\\";  // context root로부터 path를 잡아줘야 보안 이슈가 발생하지 않는다... (C:\ 기반 절대경로로 설정하면 local 접근에 대한 보안 이슈로 차단 )
	public ProductController() {
		// TODO Auto-generated constructor stub
		System.out.println("각종 Controller Bean load...");
	}
	
	/*
	 *  @ModelAttribute는 HttpServletRequest의 getParameter()를 활용하여 auto binding을 해주는 annotation이다.
	 *  	query parameter?
	 *  	GET :: url 내의 query string
	 *  	POST :: body 내의 query string  
	 */
	/*
	@PostMapping("/addProduct")
	public String addProduct(@ModelAttribute Product  product, Model model) throws Exception {
		String[] temp = product.getManuDate().split("-");
		product.setManuDate(temp[0] + temp[1] + temp[2]);  // manufacture_day 입력 양식(custom) :: yyyymmdd
		service.addProduct(product);
		model.addAttribute("product", product);
		return "forward:/product/addProduct.jsp";
	}
	*/

	/// file upload
	/*
	 *  enctype = 'multipart/form-data'
	 *  consumes(Content-Type)에서 동일하게 설정해줘야 함 
	 *  @RequestParam, @ModelAttribute :: form data는 어떤 것이든 parameter로 취급... 
	 *  MultipartHttpServletRequest :: multipartResolver 사용 시 MultipartHttpServletRequest로 변환되어 사용됨. up casting 해서 사용 가능
	 */
	@PostMapping(value = "/addProduct", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE} )
	public String addProduct(@ModelAttribute Product product, @RequestParam(required = false) MultipartFile thumbnail , Model model, HttpServletRequest request) throws Exception {

		// real path를 가져온다.
		String imagePath = request.getServletContext().getRealPath("/images/uploadFiles");
		System.out.println("path :: " + imagePath);
		
		/// 사용자가 image를 넣지 않는 경우,  예외 file로 대체
		if(thumbnail.isEmpty())  {
			product.setFileName(imagePath+"/../empty.GIF");
		} 
		/// image가 존재하는 경우 server folder 내 저장, DB에는 fileName 저장
		else {			
			/// thumbnail 크기 제한
			if(thumbnail.getSize() > unitKB * unitKB * 10)
				System.out.println("10MB 이하의 이미지만 가능합니다...");
			else {
				System.out.println("getOriginalFilename() :: " + thumbnail.getOriginalFilename());
	
				String extention = "." + thumbnail.getOriginalFilename().split("\\.")[1];  // 확장자 :: '.' 은 정규표현식 특수 문자이므로 일반 문자로 전환해줘야 함 
				String fileName = new StringTokenizer( UUID.randomUUID().toString(), "-" ).nextToken() + extention;  // unique한 random name으로 저장 :: 동일 img name에 대한 중복 회피
				File file = new File(imagePath + "/" + fileName);  // save할 file 경로 명시 (original file name까지 명시해야 함)
				/// unique한 file name을 찾을 때까지 돌리기
				while( file.exists() ) {
					fileName = new StringTokenizer( UUID.randomUUID().toString(), "-" ).nextToken() + extention;
					file = new File(imagePath + "/" + fileName);  // 기존 instance는 GC 대상의 대기를 기대
				}
				product.setFileName( fileName );
				thumbnail.transferTo(file);  // 해당 경로에 img를 transfer(?)
	
				if(file.exists()) {
					StringTokenizer temp = new StringTokenizer( product.getManuDate(), "-" );  // delim 넣어줘야 split해줌
					product.setManuDate( temp.nextToken() + temp.nextToken() + temp.nextToken() );
					System.out.println("flag :: " + product);
					service.addProduct(product);  // id는 sequence에 의해 auto increment
					model.addAttribute("product", product);  // setter...
				}
			}
		}
		
		return "forward:/product/addProduct.jsp";
	}
	
	/// file upload
	// enctype = multipart/form-data :: @RequestBody
	public String addProductOld( Model model, HttpServletRequest request) throws Exception {

		
		/// Content-Type이 'multipart/form-data'인 경우
		if(FileUpload.isMultipartContent(request)) {
			
			// file이 임시로 저장될 경로 (relative path도 가능)
			//ServletContext의 getRealPath() :: 주어진 path가 존재한다는 가정 하에(?) 유효한 경로를 알려준다.
			System.out.println("flag :: "+request.getServletContext().getRealPath("/images/uploadFiles"));
			String tempDirectory = request.getServletContext().getRealPath("/images/uploadFiles");  // Tomcat 내 실제 경로에 save해야 eclipse에서 file 갱신 bug 피할 수 있음.
			
			
			/// ServletFileUpload과 DiskFileItemFactory로 class가 분리되었다(?)...
			DiskFileUpload fileUpload = new DiskFileUpload();  // multipart/form-data 내 boundary data를 추상화 캡슐화한 객체
			/*
			 * setRepositoryPath :: threshold 크기를 넘친 경우 file을 임시로 저장해둘 경로 지정
			 * setSizeMax :: 받아들일 수 있는 file의 최대 크기 지정
			 * setSizeThreshold :: disk에 direct로 저장할 threshold 크기 임계치(?) 지정
			 */
			fileUpload.setRepositoryPath(tempDirectory); 
			fileUpload.setSizeMax(unitKB*unitKB*10);  // 10MB
			fileUpload.setSizeThreshold(unitKB * 100);  // 100KB
			
			// input된 file 크기가 최대 file 크기를 넘지 않은 경우
			if(request.getContentLength() < fileUpload.getSizeMax()  ) {
				
				Product tempProduct = new Product();

				List fileItemList = fileUpload.parseRequest(request);  // request body 내 각 boundary를 잘 parsing해서 index로 관리
				int size = fileItemList.size();
				// 순차적으로 각 boundary마다 parsing한 data를 control하고자 함
				for(int i = 0; i<size; i++) {
					
					FileItem fileItem = (FileItem) fileItemList.get(i);
					
					/* 
					 *  isFormField() :: parameter이면 true, file 형식이면 false
					 */
					/// request data가 parameter 형식인 경우
					if( fileItem.isFormField()) {
						
						if(fileItem.getFieldName().equals("manuDate")) {
							StringTokenizer token = null;
							token = new StringTokenizer(fileItem.getString("euc-kr"), "-");
							String manuDate = token.nextToken() + token.nextToken() + token.nextToken();
							tempProduct.setManuDate(manuDate);
						} else if (fileItem.getFieldName().equals("prodName")) {
							tempProduct.setProdName(fileItem.getString("euc-kr"));
						} else if(fileItem.getFieldName().equals("prodDetail")) {
							tempProduct.setProdDetail(fileItem.getString("euc-kr"));
						} else if (fileItem.getFieldName().equals("price")) {
							tempProduct.setPrice( Integer.parseInt(fileItem.getString("euc-kr")) );
						}
						/// request data가 file 형식인 경우
					} else {
						
						/// binary file이 존재하는 경우
						if(fileItem.getSize() > 0) {
							
							/*
							 *  getName() :: client file system의 원본 filename getter
							 *  근데 실질적으로 우리는 가장 마지막 filename 그 자체만 필요하니까 추가적으로 parsing
							 */
							int index = fileItem.getName().lastIndexOf("\\");
							if(index == -1)
								index = fileItem.getName().lastIndexOf("/");
							
							// String fileName = fileItem.getName().substring(index + 1);  << 동일 image의 경우 random 이름으로 식별성 부여 필요함
							// String extention = "." +  fileItem.getName().substring( index+1 ).split("[.]");  // dot은 정규식에서 임의의 한 문자를 의미하는 특수문자이다... 그래서 특수 정규식으로 따로 표현하여 일반 문자로 취급해야 함.
							String extention = "." +  fileItem.getName().substring( index+1 ).split("\\.")[1];  // 확장자
							String fileName = new StringTokenizer( UUID.randomUUID().toString(), "-" ).nextToken() + extention;
							tempProduct.setFileName(fileName);  // view 단에서 static하게 경로 잡아주고, name만 변경해주면 됨
							
							try {
								File uploadedFile = new File(tempDirectory, fileName);
								fileItem.write(uploadedFile);  // save file to 'disk'
							} catch(IOException e) {
								e.printStackTrace();
							}
						} else {
							tempProduct.setFileName("images/empty.GIF");  // root 경로는 context root인데, 현재 view에서 '/image/uploadFiles'를 static path로 잡은 상태
						}
					}
				}  /// for end
				
				service.addProduct(tempProduct);
				model.addAttribute("product", tempProduct);
				/// input된 file 크기가 최대 file 크기를 넘어선 경우
			} else {
				
				int overSize = (request.getContentLength() / 1000000);  // 왜 백 만으로 나누지?
				System.out.println("<script>alert('file의 크기는 최대 10MB까지 지원합니다. 현재 upload하신 file의 크기는 '"
						+ overSize +"MB' 입니다.')");
				System.out.println("history.back(); </script>");
			}
			/// Content-Type이 'multipart/form-data'가 아닌 경우
		} else {
			System.out.println("Accept할 수 없는 encoding type입니다. 오직 'multipart/form-data'만 허용합니다.");
		}
		
		return "forward:/product/addProduct.jsp";
	}
	

	@GetMapping("/addProduct")
	public String addProduct(Model model) {
		return "forward:/product/addProductView.jsp";
	}
	
	// HandlerAdapter에서 proxy객체 형태로 HttpServletRequest와 HttpServletResponse 객체를 넘겨줌
	@GetMapping("/getProduct")
	public String getProduct(@RequestParam Integer prodNo, @RequestParam String menu, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Product product = service.getProduct(prodNo);

		model.addAttribute("product", product);

		System.out.println("client에게 cookie(history, 상품명.상품번호)를 제공합니다.");
		
		/// history 등록 로직
		Cookie[] cookies = request.getCookies();
		boolean flag = true;  // 중복 체크
		boolean first = true; // 중복 체크 로직에서 첫번째 경우 예외 처리
		String historyCookie = "";  // historyNo 조회 도중 history가 지나가면 안되니까 데이터 따로 빼둠
		String historyNo = "";  // 상품ID만 기록
		String histories = "";  // 상품ID와 상품명 함께 기록  << 상품명이 동일한 상품에 대한 중복 검사를 하기 위함
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals("historyNo")) {
				first=false;
				String[] searchArr = cookie.getValue().split("-");
				// prodNo 중복 검사  -- 같은 이름이어도 prodNo가 다르면 서로 다르니까 번호로 비교
				for (String searchItemNo : searchArr) {
					if(searchItemNo.equals(String.valueOf(prodNo))) {
						flag=false;
						break;
					}
				}
				// 중복 없을 경우 history에 추가
				if(flag) {
					// 일부 특수 문자만 쿠키에 사용할 수 있습니다. 예를 들면 하이픈(-), 언더스코어(_), 마침표(.) 등이 있습니다.
					// 상품명.상품번호-상품명.상품번호 ~~~
					historyNo = cookie.getValue()+"-" + String.valueOf(prodNo);
					Cookie historyNoCookie = new Cookie("historyNo", historyNo);
					historyNoCookie.setPath("/");
					response.addCookie( historyNoCookie );
					System.out.println("저장된 historyNo : "+historyNo);
				} else {
					System.out.println("이미 검색한 상품입니다.");
				}
			} else if (cookie.getName().equals("histories")) {
				historyCookie = cookie.getValue();
				System.out.println("historyCookie = " + historyCookie);
			}
		}
		
		// cookie에 공백을 넣을 수 없으므로, 공백을 필터링해서 작업하기
		String[] temp = product.getProdName().trim().split(" ");
		String prodName = "";
		for (String t : temp)
			prodName += (t + "_");
		if(flag & !first) {  // 반복문 밖에서 중복이 아니면 추가해줌
			String[] searchArr = historyCookie.split("-");
			// 일부 특수 문자만 쿠키에 사용할 수 있습니다. 예를 들면 하이픈(-), 언더스코어(_), 마침표(.) 등이 있습니다.
			histories = historyCookie+"-" + prodName+ "."+ String.valueOf(prodNo);
			Cookie historiesCookie = new Cookie("histories", histories);
			historiesCookie.setPath("/");
			response.addCookie( historiesCookie );
			System.out.println("저장된 histories : "+ histories );
		}
		
		if(first) {  // 최초 조회면 쿠키를 만듦
			// addCookie를 통해 생성한 기본 cookie 수명 = -1  :: client가 browser 종료 시 자동 삭제
			histories = prodName + "."+ String.valueOf(prodNo);
			historyNo = String.valueOf(prodNo);
			Cookie historiesCookie =  new Cookie("histories", histories);
			historiesCookie.setPath("/");
			response.addCookie( historiesCookie );					
			Cookie historyNoCookie = new Cookie("historyNo", historyNo);
			historyNoCookie.setPath("/");
			response.addCookie( historyNoCookie );	
			System.out.println("history 쿠키가 없어서 새로 생성했습니다.");
		}

		
		System.out.println(product.getFileName());
		/// user는 상품 검색으로 navigation 처리
		if(menu.equals("search")) {
		return "forward:/product/getProduct.jsp?menu=search";
		} 
		/// admin은 상품 수정으로 navigation
		else {  
			return "forward:/product/updateProduct";
		}	
	}

	// list에서는 조회 및 검색이 모두 사용됨.
	/*
	 *  @RequestParam :: requestObject에만 로드
	 *  @ModelAttribute :: requestObject 및 QueryString에 모두 로드  >> 단, domain 객체는 Querystring에 로드 안되더라.
	 *  		binding :: domain 객체에 auto binding을 할 것인지 여부. (default = true)
	 *  @PathVariable :: 어디에도 load하지 않는다...
	 */
	@RequestMapping("/listProduct/{menu}")
	public String listProduct(@ModelAttribute(binding=true) Search search, @PathVariable String menu, Model model, HttpServletRequest request) throws Exception {
		
		// 최초 접근 시 Query Parameter인 currentPage값이 null일 때 1페이지에서 시작하도록 설정
		if(search.getCurrentPage() == null ||  search.getCurrentPage() == 0)
			search.setCurrentPage(1);
		// 1페이지 이후에서 검색 시 1페이지에서 재시작하도록 설정
		else if( !CommonUtil.null2str(search.getSearchKeyword()).isEmpty() && search.getCurrentPage() != 1 )
			search.setCurrentPage(1);
		search.setPageSize(pageSize);
		// priceDESC null string 들어올 때 bug 해결 (null check 안하면 isEmpty()에서 null pointer error)
		if( search.getPriceDESC() != null && search.getPriceDESC().isEmpty())
			search.setPriceDESC(null);
		Map<String, Object> map = service.getProductList(search);
		
		Page myPage = new Page(search.getCurrentPage(), (Integer) map.get("totalCount"),pageUnit, pageSize);
		
		//  1페이지 이후에서 검색 시 1페이지에서 재시작하도록 설정
		if( (search.getCurrentPage() > myPage.getPageUnit() ) && !CommonUtil.null2str(search.getSearchKeyword()).isEmpty() )
			myPage.setBeginUnitPage(1);
		
		model.addAttribute("search", search);  // 검색 조건 유지를 위해 requestScope에 같이 넘겨줌...
		model.addAttribute("list", map.get("list") );
		model.addAttribute("resultPage", myPage);
		model.addAttribute("menu", menu);
		model.addAttribute("title", "product");
		
		// 페이지 모드에 따라서 리턴 Query String을 정의
		if(menu.contains("search"))
			return "forward:/product/listProduct.jsp?menu=search";  
		else
			return "forward:/product/listProduct.jsp?menu=manage";
	}
	
	@GetMapping("/updateProduct")
	public String updateProduct(@RequestParam Integer prodNo, Model model) throws Exception {
		Product product =  service.getProduct(prodNo);

		// substring() :: python의 list와 동일한 begin ~ end 방식
		String year = product.getManuDate().substring(0, 4);
		String month = product.getManuDate().substring(4, 6);
		String day = product.getManuDate().substring(6, 8);
		product.setManuDate(year + "-" + month + "-" + day);
		System.out.println("end :: "+product.getManuDate());

		model.addAttribute("product", product);
		
		return "forward:/product/updateProductView.jsp";
	}
	
	/*
	@PostMapping("/updateProduct")
	public String updateProduct(@ModelAttribute Product product) throws Exception {
		service.updateProduct(product);
		return "forward:/product/updateProduct.jsp";
	}
	*/
	
	@PostMapping("/updateProduct")
	public String updateProduct(@ModelAttribute Product product, @RequestParam(required=false) MultipartFile thumbnail, Model model, HttpServletRequest request) throws Exception {
		
		String oldFileName = service.getProduct(product.getProdNo()).getFileName();
		/// user가 새 thumbnail을 추가했다면?
		if( !thumbnail.isEmpty() ) {
			
			File file = new File( request.getServletContext().getRealPath("/images/uploadFiles") + "/" + oldFileName );
			// file.delete();  
			thumbnail.transferTo(file);  // 기존 file이 존재하면, 그것을 제거한 후 write
		} 
		/// thunbnail 변경사항이 없으면 기존 것을 그대로 채용, thumbnail 있어도 기존 이름으로 변경해야 함.
		product.setFileName(oldFileName);

		StringTokenizer temp = new StringTokenizer( product.getManuDate(), "-" );  // delim 넣어줘야 split해줌
		product.setManuDate( temp.nextToken() + temp.nextToken() + temp.nextToken() );
		service.updateProduct(product);
		
		return "forward:/product/updateProduct.jsp";
	}
	
	
	
	public String updateProductOld( Model model, HttpServletRequest request) throws Exception {
		
		if(FileUpload.isMultipartContent(request)) {
			
			String tempPath = request.getServletContext().getRealPath("/images/uploadFiles");
			DiskFileUpload fileUpload = new DiskFileUpload();
			fileUpload.setRepositoryPath(tempPath);
			fileUpload.setSizeMax(unitKB * unitKB * 10);
			fileUpload.setSizeThreshold(unitKB * 100);
			
			if(request.getContentLength() < fileUpload.getSizeMax()) {
				
				Product product = new Product();
				
				List fileItemList = fileUpload.parseRequest(request);
				// System.out.println("fileItemList :: " + fileItemList);
				// System.out.println("real path (/images/uploadFiles) :: " + request.getServletContext().getRealPath("/images/uploadFiles"));
				int size = fileItemList.size();
				for(int i = 0; i < size; i++) {

					FileItem fileItem = (FileItem) fileItemList.get(i);
					if(fileItem.isFormField()) {
						if(fileItem.getFieldName().equals("manuDate")) {
							StringTokenizer token = new StringTokenizer(fileItem.getString("euc-kr"), "-");
							String manuDate = "";
							while(token.hasMoreTokens()) 
								manuDate += token.nextToken();
							
							product.setManuDate(manuDate);
						} else if(fileItem.getFieldName().equals("prodName")) {
							product.setProdName(fileItem.getString("euc-kr"));
						} else if(fileItem.getFieldName().equals("prodDetail")) {
							product.setProdDetail(fileItem.getString("euc-kr"));
						} else if(fileItem.getFieldName().equals("price")) {
							product.setPrice(Integer.parseInt(fileItem.getString("euc-kr")));
						} else if(fileItem.getFieldName().equals("prodNo")) {  // getName()은 fileItem 고유의 이름... getFieldName()이 parameter의 이름..
							System.out.println("flag");
							product.setProdNo(Integer.parseInt(fileItem.getString("euc-kr")) );
						} else if(fileItem.getFieldName().equals("regDate")) {
							product.setRegDate(Date.valueOf((fileItem.getString("euc-kr")) ));
						}
					} /// form field check end
					else {
						
						if(fileItem.getSize() > 0) {
							
							/*
							System.out.println("getFieldName :: " + fileItem.getFieldName() );
							int index = fileItem.getFieldName().lastIndexOf("\\");
							if(index == -1)
								index = fileItem.getFieldName().lastIndexOf("/");
								
							String fileName = fileItem.getName().substring(index + 1);	
							*/
							
							// 이전 image file name을 overwrite
							String fileName = service.getProduct( product.getProdNo() ).getFileName();
							product.setFileName(fileName);
							try {
								File uploadedFile = new File(tempPath, fileName);
								fileItem.write(uploadedFile);
							} catch(IOException e) {
								e.printStackTrace();
							}
						} else {
							// 사용자가 image를 넣지 않았으면 기존 image를 그대로 가져감
							// product.setFileName("images/empty.GIF");
							product.setFileName( service.getProduct(product.getProdNo()).getFileName() );
						}
					}
				}  /// for end

				service.updateProduct(product);
				model.addAttribute(product);
			}   /// file size overflow check end
			else {
				
				int overSize = (request.getContentLength() / 1000000) ;
				System.out.println("<script>alert('file의 크기는 최대 10MB까지 지원합니다. 현재 upload하신 file의 크기는 '"
						+ overSize +"MB' 입니다.')");
				System.out.println("history.back(); </script>");
			}
		} /// multipart/form-data check end
		else {
			System.out.println("enctype이 'multipart/form-data'가 아닙니다...");
		}
		
		return "forward:/product/updateProduct.jsp";
	}
}