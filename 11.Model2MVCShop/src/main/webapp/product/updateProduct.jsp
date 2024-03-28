<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>

<!-- <link rel="stylesheet" href="/css/admin.css" type="text/css">  -->

<title> 상품 정보 수정 완료 </title>


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
   
	<!--  ///////////////////////// CSS ////////////////////////// -->
	<style>
		body {
            padding-top : 50px;
        }
    </style>

<script type="text/javascript">
	
	$( function() {
		
		$('button:contains("확인")').on('click', function() {
			// $(window.parent.frames['rightFrame'].document.location).attr('href', '/product/listProduct?menu=manage');
			window.location.href = "/product/listProduct/manage";
		}).on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});
	});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->

<div class="container">
<form name="detailForm" method="post">

<div class="page-header">
  <h1>상품 상세 조회</h1>
</div>

<table class="table">
	<tbody>
		<tr>
			<th scope="row">상품번호</th>
			<td>${product.prodNo }</td>
		</tr>
		<tr>
			<th scope="row">상품명</th>
			<!-- object scope 종류 :: pageScope < requestScope < sessionScope < applicationScope -->
			<td>${requestScope.product.prodName }</td>
		</tr>
		<tr>
			<th scope="row">상품이미지</th>
			<td>
				<img src="/images/uploadFiles/${product.fileName }" style="max-width : 400px; max-height : 300px;" align="absmiddle" />
			</td>
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
			<th scope="row">등록일자</th>
			<td> ${product.regDate }</td>
		</tr>
	</tbody>
</table>

	<div class="row">
		<div class="col-sm-offset-11">
			<button type="button" class="btn btn-default">확인</button>
		</div>
	</div>	
	
</form>
</div> <!-- container end -->
</body>
</html>