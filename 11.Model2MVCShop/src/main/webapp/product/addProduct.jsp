<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>상품등록</title>

<!-- <link rel="stylesheet" href="/css/admin.css" type="text/css">  -->
	
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
   
   
   <!-- jQuery UI toolTip 사용 CSS-->
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <!-- jQuery UI toolTip 사용 JS-->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	
	<!--  CSS 추가 : 툴바에 화면 가리는 현상 해결 :  주석처리 전, 후 확인-->
	<style>
        body {
            padding-top : 70px;
            padding-bottom : 30px;
        }
   	</style>
   	
	<script type="text/javascript">
	
		$( function() {
			
			$('button:contains("확인")').on('click', function() {
				window.location.href = "/product/listProduct/manage";
			});
			
			$('button:contains("추가등록")').on('click', function() {
				window.location.href = "/product/addProductView.jsp";
			})
		});
	</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->


<div class="container">
	<div class="page-header">
	  <h1>등록된 상품</h1>
	</div>

<table class="table">
	<tbody>
		<tr>
			<th scope="row">상품명</th>
			<!-- object scope 종류 :: pageScope < requestScope < sessionScope < applicationScope -->
			<td>${requestScope.product.prodName }</td>
		</tr>
		<tr>
			<th scope="row">상품상세정보</th>
			<td>${product.prodDetail }</td>
		</tr>
		<tr>
			<th scope="row">제조일자</th>
			<td>${product.manuDate }</td>
		</tr>
		<tr>
			<th scope="row">가격</th>
			<td>${product.price }</td>
		</tr>
		<tr>
		<tr>
			<th scope="row">상품이미지</th>
			<td>
				<img src="/images/uploadFiles/${product.fileName }" style="max-width : 400px; max-height : 300px;" align="absmiddle" />
			</td>
		</tr>
	</tbody>
</table>

	<div class="row">
		<div class="col-sm-offset-10">
		  	<button type="button" class="btn btn-default">확인</button>
	
			<button type="button" class="btn btn-default">추가등록</button>
		</div>
	</div>
</div> <!-- container end -->
</body>
</html>
