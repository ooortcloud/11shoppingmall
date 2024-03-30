<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>


<!DOCTYPE html>

<html lang="ko">
	
<head>
	<meta charset="EUC-KR">
	
	<!-- 참조 : http://getbootstrap.com/css/   참조 -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	
	<!--  ///////////////////////// Bootstrap, jQuery CDN ////////////////////////// -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
	
	
	<!-- Bootstrap Dropdown Hover CSS -->
   <link href="/css/animate.min.css" rel="stylesheet">
   <link href="/css/bootstrap-dropdownhover.min.css" rel="stylesheet">
    <!-- Bootstrap Dropdown Hover JS -->
   <script src="/javascript/bootstrap-dropdownhover.min.js"></script>
   
   
   <%--
   <!-- jQuery UI toolTip 사용 CSS-->
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <!-- jQuery UI toolTip 사용 JS-->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
 --%>
	 
	<!--  CSS 추가 : 툴바에 화면 가리는 현상 해결 :  주석처리 전, 후 확인-->
	<style>
        body {
            padding-top : 70px;
        }
   	</style>
   	
     <!--  ///////////////////////// JavaScript ////////////////////////// -->

</head>
	
<body>

	<!-- ToolBar Start /////////////////////////////////////-->
	<%-- not_login_index.jsp와 통합할 수는 있는데, refactoring 비용이 더 커서 안 건드는 중. --%>
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->

	<!-- mainPage Start /////////////////////////////////////-->
	<jsp:include page="/product/recommendContents.jsp" />
	
	<div class="container">
		<div class="page-header">
		  <h1><span class="glyphicon glyphicon-bullhorn" aria-hidden="true"></span>&nbsp;최신 상품<small>&nbsp;&nbsp;현재 새롭게 등록된 아이템들이에요</small></h1>
		</div>
	</div>
			 	
	<!-- main contents load 용 -->
	<jsp:include page="/product/mainContents.jsp"></jsp:include>
   	<!-- mainPage End /////////////////////////////////////-->

</body>

</html>