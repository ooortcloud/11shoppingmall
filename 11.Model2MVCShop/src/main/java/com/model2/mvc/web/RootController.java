package com.model2.mvc.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.product.ProductService;

@Controller
public class RootController {

	public RootController() {
		System.out.println("RootController instance generated...");
	}
	
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService service;
	
	/// root WebApplicationContext에 저장된 properties 값 로드...
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	/// 오직 welcome-page를 제어하기 위한 수단...
	// welcome-page의 이름을 'index'로 하면 Spring 내부에서 controller를 무시하고 해당 view로 꽃아버림...
	@GetMapping("/")
	public String listProduct(Model model, HttpServletRequest request) throws Exception {
		
		// 최신 list를 기준으로 가져오기 위한 최소한의 정보를 제공
		Search search = new Search();
		search.setPageSize(pageSize);
		search.setCurrentPage(1);
		Map<String, Object> map = service.getProductList(search);

		model.addAttribute("list", map.get("list") );

		// welcome-page로 forward
		HttpSession session = request.getSession();
		if(session == null || session.getAttribute("user") == null )  // login하지 않은 사용자는 예외처리
			// 'index.jsp'로 view 이름을 지으면 Controller 무시하고 바로 실행돼버림...
			return "forward:/not_login_index.jsp";
		else
			return "forward:/main.jsp";
	}
	
}
