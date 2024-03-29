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
	
	/// root WebApplicationContext�� ����� properties �� �ε�...
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	private static final int unitKB = 1024;
	/*
	 *  file ��ο� ���Ͽ�
	 *  	������ :: origin���� �����η� �����ϴ� ���� �ƹ��� ������ ���� ����.
	 *  	����� :: �ܺο��� �����η� ���� ��������. ��� context root�κ����� ����� ������ ����.
	 */
	// private static final String relativeImagePath = "\\images\\uploadFiles\\";
	// private static final String imagePath = "\\images\\uploadFiles\\";  // context root�κ��� path�� ������ ���� �̽��� �߻����� �ʴ´�... (C:\ ��� �����η� �����ϸ� local ���ٿ� ���� ���� �̽��� ���� )
	public ProductController() {
		// TODO Auto-generated constructor stub
		System.out.println("���� Controller Bean load...");
	}
	
	/*
	 *  @ModelAttribute�� HttpServletRequest�� getParameter()�� Ȱ���Ͽ� auto binding�� ���ִ� annotation�̴�.
	 *  	query parameter?
	 *  	GET :: url ���� query string
	 *  	POST :: body ���� query string  
	 */
	/*
	@PostMapping("/addProduct")
	public String addProduct(@ModelAttribute Product  product, Model model) throws Exception {
		String[] temp = product.getManuDate().split("-");
		product.setManuDate(temp[0] + temp[1] + temp[2]);  // manufacture_day �Է� ���(custom) :: yyyymmdd
		service.addProduct(product);
		model.addAttribute("product", product);
		return "forward:/product/addProduct.jsp";
	}
	*/

	/// file upload
	/*
	 *  enctype = 'multipart/form-data'
	 *  consumes(Content-Type)���� �����ϰ� ��������� �� 
	 *  @RequestParam, @ModelAttribute :: form data�� � ���̵� parameter�� ���... 
	 *  MultipartHttpServletRequest :: multipartResolver ��� �� MultipartHttpServletRequest�� ��ȯ�Ǿ� ����. up casting �ؼ� ��� ����
	 */
	@PostMapping(value = "/addProduct", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE} )
	public String addProduct(@ModelAttribute Product product, @RequestParam(required = false) MultipartFile thumbnail , Model model, HttpServletRequest request) throws Exception {

		// real path�� �����´�.
		String imagePath = request.getServletContext().getRealPath("/images/uploadFiles");
		System.out.println("path :: " + imagePath);
		
		/// ����ڰ� image�� ���� �ʴ� ���,  ���� file�� ��ü
		if(thumbnail.isEmpty())  {
			product.setFileName(imagePath+"/../empty.GIF");
		} 
		/// image�� �����ϴ� ��� server folder �� ����, DB���� fileName ����
		else {			
			/// thumbnail ũ�� ����
			if(thumbnail.getSize() > unitKB * unitKB * 10)
				System.out.println("10MB ������ �̹����� �����մϴ�...");
			else {
				System.out.println("getOriginalFilename() :: " + thumbnail.getOriginalFilename());
	
				String extention = "." + thumbnail.getOriginalFilename().split("\\.")[1];  // Ȯ���� :: '.' �� ����ǥ���� Ư�� �����̹Ƿ� �Ϲ� ���ڷ� ��ȯ����� �� 
				String fileName = new StringTokenizer( UUID.randomUUID().toString(), "-" ).nextToken() + extention;  // unique�� random name���� ���� :: ���� img name�� ���� �ߺ� ȸ��
				File file = new File(imagePath + "/" + fileName);  // save�� file ��� ��� (original file name���� ����ؾ� ��)
				/// unique�� file name�� ã�� ������ ������
				while( file.exists() ) {
					fileName = new StringTokenizer( UUID.randomUUID().toString(), "-" ).nextToken() + extention;
					file = new File(imagePath + "/" + fileName);  // ���� instance�� GC ����� ��⸦ ���
				}
				product.setFileName( fileName );
				thumbnail.transferTo(file);  // �ش� ��ο� img�� transfer(?)
	
				if(file.exists()) {
					StringTokenizer temp = new StringTokenizer( product.getManuDate(), "-" );  // delim �־���� split����
					product.setManuDate( temp.nextToken() + temp.nextToken() + temp.nextToken() );
					System.out.println("flag :: " + product);
					service.addProduct(product);  // id�� sequence�� ���� auto increment
					model.addAttribute("product", product);  // setter...
				}
			}
		}
		
		return "forward:/product/addProduct.jsp";
	}
	
	/// file upload
	// enctype = multipart/form-data :: @RequestBody
	public String addProductOld( Model model, HttpServletRequest request) throws Exception {

		
		/// Content-Type�� 'multipart/form-data'�� ���
		if(FileUpload.isMultipartContent(request)) {
			
			// file�� �ӽ÷� ����� ��� (relative path�� ����)
			//ServletContext�� getRealPath() :: �־��� path�� �����Ѵٴ� ���� �Ͽ�(?) ��ȿ�� ��θ� �˷��ش�.
			System.out.println("flag :: "+request.getServletContext().getRealPath("/images/uploadFiles"));
			String tempDirectory = request.getServletContext().getRealPath("/images/uploadFiles");  // Tomcat �� ���� ��ο� save�ؾ� eclipse���� file ���� bug ���� �� ����.
			
			
			/// ServletFileUpload�� DiskFileItemFactory�� class�� �и��Ǿ���(?)...
			DiskFileUpload fileUpload = new DiskFileUpload();  // multipart/form-data �� boundary data�� �߻�ȭ ĸ��ȭ�� ��ü
			/*
			 * setRepositoryPath :: threshold ũ�⸦ ��ģ ��� file�� �ӽ÷� �����ص� ��� ����
			 * setSizeMax :: �޾Ƶ��� �� �ִ� file�� �ִ� ũ�� ����
			 * setSizeThreshold :: disk�� direct�� ������ threshold ũ�� �Ӱ�ġ(?) ����
			 */
			fileUpload.setRepositoryPath(tempDirectory); 
			fileUpload.setSizeMax(unitKB*unitKB*10);  // 10MB
			fileUpload.setSizeThreshold(unitKB * 100);  // 100KB
			
			// input�� file ũ�Ⱑ �ִ� file ũ�⸦ ���� ���� ���
			if(request.getContentLength() < fileUpload.getSizeMax()  ) {
				
				Product tempProduct = new Product();

				List fileItemList = fileUpload.parseRequest(request);  // request body �� �� boundary�� �� parsing�ؼ� index�� ����
				int size = fileItemList.size();
				// ���������� �� boundary���� parsing�� data�� control�ϰ��� ��
				for(int i = 0; i<size; i++) {
					
					FileItem fileItem = (FileItem) fileItemList.get(i);
					
					/* 
					 *  isFormField() :: parameter�̸� true, file �����̸� false
					 */
					/// request data�� parameter ������ ���
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
						/// request data�� file ������ ���
					} else {
						
						/// binary file�� �����ϴ� ���
						if(fileItem.getSize() > 0) {
							
							/*
							 *  getName() :: client file system�� ���� filename getter
							 *  �ٵ� ���������� �츮�� ���� ������ filename �� ��ü�� �ʿ��ϴϱ� �߰������� parsing
							 */
							int index = fileItem.getName().lastIndexOf("\\");
							if(index == -1)
								index = fileItem.getName().lastIndexOf("/");
							
							// String fileName = fileItem.getName().substring(index + 1);  << ���� image�� ��� random �̸����� �ĺ��� �ο� �ʿ���
							// String extention = "." +  fileItem.getName().substring( index+1 ).split("[.]");  // dot�� ���ԽĿ��� ������ �� ���ڸ� �ǹ��ϴ� Ư�������̴�... �׷��� Ư�� ���Խ����� ���� ǥ���Ͽ� �Ϲ� ���ڷ� ����ؾ� ��.
							String extention = "." +  fileItem.getName().substring( index+1 ).split("\\.")[1];  // Ȯ����
							String fileName = new StringTokenizer( UUID.randomUUID().toString(), "-" ).nextToken() + extention;
							tempProduct.setFileName(fileName);  // view �ܿ��� static�ϰ� ��� ����ְ�, name�� �������ָ� ��
							
							try {
								File uploadedFile = new File(tempDirectory, fileName);
								fileItem.write(uploadedFile);  // save file to 'disk'
							} catch(IOException e) {
								e.printStackTrace();
							}
						} else {
							tempProduct.setFileName("images/empty.GIF");  // root ��δ� context root�ε�, ���� view���� '/image/uploadFiles'�� static path�� ���� ����
						}
					}
				}  /// for end
				
				service.addProduct(tempProduct);
				model.addAttribute("product", tempProduct);
				/// input�� file ũ�Ⱑ �ִ� file ũ�⸦ �Ѿ ���
			} else {
				
				int overSize = (request.getContentLength() / 1000000);  // �� �� ������ ������?
				System.out.println("<script>alert('file�� ũ��� �ִ� 10MB���� �����մϴ�. ���� upload�Ͻ� file�� ũ��� '"
						+ overSize +"MB' �Դϴ�.')");
				System.out.println("history.back(); </script>");
			}
			/// Content-Type�� 'multipart/form-data'�� �ƴ� ���
		} else {
			System.out.println("Accept�� �� ���� encoding type�Դϴ�. ���� 'multipart/form-data'�� ����մϴ�.");
		}
		
		return "forward:/product/addProduct.jsp";
	}
	

	@GetMapping("/addProduct")
	public String addProduct(Model model) {
		return "forward:/product/addProductView.jsp";
	}
	
	// HandlerAdapter���� proxy��ü ���·� HttpServletRequest�� HttpServletResponse ��ü�� �Ѱ���
	@GetMapping("/getProduct")
	public String getProduct(@RequestParam Integer prodNo, @RequestParam String menu, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Product product = service.getProduct(prodNo);

		model.addAttribute("product", product);

		System.out.println("client���� cookie(history, ��ǰ��.��ǰ��ȣ)�� �����մϴ�.");
		
		/// history ��� ����
		Cookie[] cookies = request.getCookies();
		boolean flag = true;  // �ߺ� üũ
		boolean first = true; // �ߺ� üũ �������� ù��° ��� ���� ó��
		String historyCookie = "";  // historyNo ��ȸ ���� history�� �������� �ȵǴϱ� ������ ���� ����
		String historyNo = "";  // ��ǰID�� ���
		String histories = "";  // ��ǰID�� ��ǰ�� �Բ� ���  << ��ǰ���� ������ ��ǰ�� ���� �ߺ� �˻縦 �ϱ� ����
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals("historyNo")) {
				first=false;
				String[] searchArr = cookie.getValue().split("-");
				// prodNo �ߺ� �˻�  -- ���� �̸��̾ prodNo�� �ٸ��� ���� �ٸ��ϱ� ��ȣ�� ��
				for (String searchItemNo : searchArr) {
					if(searchItemNo.equals(String.valueOf(prodNo))) {
						flag=false;
						break;
					}
				}
				// �ߺ� ���� ��� history�� �߰�
				if(flag) {
					// �Ϻ� Ư�� ���ڸ� ��Ű�� ����� �� �ֽ��ϴ�. ���� ��� ������(-), ������ھ�(_), ��ħǥ(.) ���� �ֽ��ϴ�.
					// ��ǰ��.��ǰ��ȣ-��ǰ��.��ǰ��ȣ ~~~
					historyNo = cookie.getValue()+"-" + String.valueOf(prodNo);
					Cookie historyNoCookie = new Cookie("historyNo", historyNo);
					historyNoCookie.setPath("/");
					response.addCookie( historyNoCookie );
					System.out.println("����� historyNo : "+historyNo);
				} else {
					System.out.println("�̹� �˻��� ��ǰ�Դϴ�.");
				}
			} else if (cookie.getName().equals("histories")) {
				historyCookie = cookie.getValue();
				System.out.println("historyCookie = " + historyCookie);
			}
		}
		
		// cookie�� ������ ���� �� �����Ƿ�, ������ ���͸��ؼ� �۾��ϱ�
		String[] temp = product.getProdName().trim().split(" ");
		String prodName = "";
		for (String t : temp)
			prodName += (t + "_");
		if(flag & !first) {  // �ݺ��� �ۿ��� �ߺ��� �ƴϸ� �߰�����
			String[] searchArr = historyCookie.split("-");
			// �Ϻ� Ư�� ���ڸ� ��Ű�� ����� �� �ֽ��ϴ�. ���� ��� ������(-), ������ھ�(_), ��ħǥ(.) ���� �ֽ��ϴ�.
			histories = historyCookie+"-" + prodName+ "."+ String.valueOf(prodNo);
			Cookie historiesCookie = new Cookie("histories", histories);
			historiesCookie.setPath("/");
			response.addCookie( historiesCookie );
			System.out.println("����� histories : "+ histories );
		}
		
		if(first) {  // ���� ��ȸ�� ��Ű�� ����
			// addCookie�� ���� ������ �⺻ cookie ���� = -1  :: client�� browser ���� �� �ڵ� ����
			histories = prodName + "."+ String.valueOf(prodNo);
			historyNo = String.valueOf(prodNo);
			Cookie historiesCookie =  new Cookie("histories", histories);
			historiesCookie.setPath("/");
			response.addCookie( historiesCookie );					
			Cookie historyNoCookie = new Cookie("historyNo", historyNo);
			historyNoCookie.setPath("/");
			response.addCookie( historyNoCookie );	
			System.out.println("history ��Ű�� ��� ���� �����߽��ϴ�.");
		}

		
		System.out.println(product.getFileName());
		/// user�� ��ǰ �˻����� navigation ó��
		if(menu.equals("search")) {
		return "forward:/product/getProduct.jsp?menu=search";
		} 
		/// admin�� ��ǰ �������� navigation
		else {  
			return "forward:/product/updateProduct";
		}	
	}

	// list������ ��ȸ �� �˻��� ��� ����.
	/*
	 *  @RequestParam :: requestObject���� �ε�
	 *  @ModelAttribute :: requestObject �� QueryString�� ��� �ε�  >> ��, domain ��ü�� Querystring�� �ε� �ȵǴ���.
	 *  		binding :: domain ��ü�� auto binding�� �� ������ ����. (default = true)
	 *  @PathVariable :: ��𿡵� load���� �ʴ´�...
	 */
	@RequestMapping("/listProduct/{menu}")
	public String listProduct(@ModelAttribute(binding=true) Search search, @PathVariable String menu, Model model, HttpServletRequest request) throws Exception {
		
		// ���� ���� �� Query Parameter�� currentPage���� null�� �� 1���������� �����ϵ��� ����
		if(search.getCurrentPage() == null ||  search.getCurrentPage() == 0)
			search.setCurrentPage(1);
		// 1������ ���Ŀ��� �˻� �� 1���������� ������ϵ��� ����
		else if( !CommonUtil.null2str(search.getSearchKeyword()).isEmpty() && search.getCurrentPage() != 1 )
			search.setCurrentPage(1);
		search.setPageSize(pageSize);
		// priceDESC null string ���� �� bug �ذ� (null check ���ϸ� isEmpty()���� null pointer error)
		if( search.getPriceDESC() != null && search.getPriceDESC().isEmpty())
			search.setPriceDESC(null);
		Map<String, Object> map = service.getProductList(search);
		
		Page myPage = new Page(search.getCurrentPage(), (Integer) map.get("totalCount"),pageUnit, pageSize);
		
		//  1������ ���Ŀ��� �˻� �� 1���������� ������ϵ��� ����
		if( (search.getCurrentPage() > myPage.getPageUnit() ) && !CommonUtil.null2str(search.getSearchKeyword()).isEmpty() )
			myPage.setBeginUnitPage(1);
		
		model.addAttribute("search", search);  // �˻� ���� ������ ���� requestScope�� ���� �Ѱ���...
		model.addAttribute("list", map.get("list") );
		model.addAttribute("resultPage", myPage);
		model.addAttribute("menu", menu);
		model.addAttribute("title", "product");
		
		// ������ ��忡 ���� ���� Query String�� ����
		if(menu.contains("search"))
			return "forward:/product/listProduct.jsp?menu=search";  
		else
			return "forward:/product/listProduct.jsp?menu=manage";
	}
	
	@GetMapping("/updateProduct")
	public String updateProduct(@RequestParam Integer prodNo, Model model) throws Exception {
		Product product =  service.getProduct(prodNo);

		// substring() :: python�� list�� ������ begin ~ end ���
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
		/// user�� �� thumbnail�� �߰��ߴٸ�?
		if( !thumbnail.isEmpty() ) {
			
			File file = new File( request.getServletContext().getRealPath("/images/uploadFiles") + "/" + oldFileName );
			// file.delete();  
			thumbnail.transferTo(file);  // ���� file�� �����ϸ�, �װ��� ������ �� write
		} 
		/// thunbnail ��������� ������ ���� ���� �״�� ä��, thumbnail �־ ���� �̸����� �����ؾ� ��.
		product.setFileName(oldFileName);

		StringTokenizer temp = new StringTokenizer( product.getManuDate(), "-" );  // delim �־���� split����
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
						} else if(fileItem.getFieldName().equals("prodNo")) {  // getName()�� fileItem ������ �̸�... getFieldName()�� parameter�� �̸�..
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
							
							// ���� image file name�� overwrite
							String fileName = service.getProduct( product.getProdNo() ).getFileName();
							product.setFileName(fileName);
							try {
								File uploadedFile = new File(tempPath, fileName);
								fileItem.write(uploadedFile);
							} catch(IOException e) {
								e.printStackTrace();
							}
						} else {
							// ����ڰ� image�� ���� �ʾ����� ���� image�� �״�� ������
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
				System.out.println("<script>alert('file�� ũ��� �ִ� 10MB���� �����մϴ�. ���� upload�Ͻ� file�� ũ��� '"
						+ overSize +"MB' �Դϴ�.')");
				System.out.println("history.back(); </script>");
			}
		} /// multipart/form-data check end
		else {
			System.out.println("enctype�� 'multipart/form-data'�� �ƴմϴ�...");
		}
		
		return "forward:/product/updateProduct.jsp";
	}
}