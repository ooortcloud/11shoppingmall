package com.model2.mvc.common.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.model2.mvc.service.domain.User;


/*
 * FileName : LogonCheckInterceptor.java
 *  ㅇ Controller 호출전 interceptor 를 통해 선처리/후처리/완료처리를 수행
 *  	- preHandle() : Controller 호출전 선처리   
 * 			(true return ==> Controller 호출 / false return ==> Controller 미호출 ) 
 *  	- postHandle() : Controller 호출 후 후처리
 *    	- afterCompletion() : view 생성후 처리
 *    
 *    ==> 로그인한 회원이면 Controller 호출 : true return
 *    ==> 비 로그인한 회원이면 Controller 미 호출 : false return
 */
public class LogonCheckInterceptor extends HandlerInterceptorAdapter {

	///Field
	
	///Constructor
	public LogonCheckInterceptor(){
		System.out.println("\nCommon :: "+this.getClass()+"\n");		
	}
	
	///Method
	public boolean preHandle(	HttpServletRequest request,
														HttpServletResponse response, 
														Object handler) throws Exception {
		
		System.out.println("\n[ LogonCheckInterceptor start........]");
		
		//==> 로그인 유무확인
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("user");

		//==> 로그인한 회원이라면...
		if(   user != null   )  {
			//==> 로그인 상태에서 접근 불가 URI
			String uri = request.getRequestURI();  // query string은 제외
			
			if(		uri.indexOf("addUserView") != -1 	|| 	uri.indexOf("addUser") != -1 || 
					uri.indexOf("loginView") != -1 			||	uri.indexOf("login") != -1 		|| 
					uri.indexOf("checkDuplication") != -1 ){
				request.getRequestDispatcher("/not_login_index.jsp").forward(request, response);
				System.out.println("[ 이미 로그인한 상태입니다...]");
				System.out.println("[ LogonCheckInterceptor end........]\n");
				return false;
			}
			
			/////////////////// security 문제 방어 start /////////////////////
			
			if( uri.indexOf("getUser") != -1) {
				
				String userId = user.getUserId();
				if(  !(userId.equals("admin") || request.getParameter("userId").equals(userId)) ) {
					
					System.out.println("해당 유저에게 타 유저 조회 권한은 없습니다...");
					return false;
				}
			}
			
			if( uri.indexOf("listProduct") != -1) {
				
				String userId = user.getUserId();
				if( uri.indexOf("manage") != -1 && !(userId.equals("admin")) ) {
					
					System.out.println("해당 유저에게 상품 관리 권한은 없습니다...");
					return false;
				}
			}
			
			if(uri.indexOf("updateProduct") != -1 ) {
				
				if( !user.getUserId().equals("admin") ) {
					System.out.println("해당 유저에게 상품 수정 권한은 없습니다...");
					return false;
				}
			}
			/////////////////// security 문제 방어 end /////////////////////
			
			System.out.println("[ 현재 로그인 중인 회원입니다. ]");
			System.out.println("[ LogonCheckInterceptor end........]\n");
			return true;
		}else{ //==> 미 로그인한 회원이라면...
			//==> 로그인 시도 중.....
			String uri = request.getRequestURI();
			System.out.println("uri = " + uri);
			if(		uri.indexOf("addUserView") != -1 	|| 	uri.indexOf("addUser") != -1 || 
					uri.indexOf("loginView") != -1 			||	uri.indexOf("login") != -1 		|| 
					uri.indexOf("checkDuplication") != -1 || uri.indexOf("loginChecker") != -1 ){
 				System.out.println("[ 로그인 시도 중 .... ]"); 
				System.out.println("[ LogonCheckInterceptor end........]\n");
				return true;
			}
			    
			// if ( ( uri.indexOf("listProduct") != -1 || uri.indexOf("getProduct") != -1 ) && request.getParameter("menu").equals("search") ) {
			if ( ( uri.indexOf("listProduct") != -1 || uri.indexOf("getProduct") != -1 ) && uri.indexOf("search") != -1 ) {    
				System.out.println("[비로그인 회원도 상품 조회가 가능합니다.]");
				// System.out.println("currentPage = "+request.getParameter("currentPage"));
				return true;
			}
			
			request.getRequestDispatcher("/user/loginView.jsp").forward(request, response);
			System.out.println("[ 아직 로그인하지 않았습니다 ... ]");
			System.out.println("[ LogonCheckInterceptor end........]\n");
			return false;
		}
	}
}//end of class