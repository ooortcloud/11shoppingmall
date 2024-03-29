<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>

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

	<!--  ///////////////////////// CSS ////////////////////////// -->
	<style>
		body {
            padding-top : 50px;
        }
    </style>


<title>상품 상세 조회</title>

<script src="https://code.jquery.com/jquery-2.2.4.js" integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI=" crossorigin="anonymous"></script>
<script  type="text/javascript">

	$( function() {
		
		$('button:contains("구매")').on('click', function() {
			// $(window.parent.frames["rightFrame"].document.location).attr('href', '/purchase/addPurchase?prodNo=${product.prodNo}');  // JSP는 적용 가능. 하지만 JSTL은 적용 불가...
			window.location.href = "/purchase/addPurchase?prodNo=${product.prodNo}";
		}).on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});
		
		$('button:contains("이전")').on('click', function() {
			// $(window.parent.frames["rightFrame"].document.location).attr('href', 'javascript:history.go(-1)');  // 반드시 'javascript:'를 명시해주어야 한다.
			
			if (window.location.href > 1)  
				window.location.href = "javascript:history.go(-1)"; 
			else  //  '최근 본 목록'에서 들어온 경우 새 창을 띄우기 때문에 history가 존재하지 않음...
				window.location.href = "/product/listProduct/search"
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
		<div class="page-header">
			<h2>
				상품상세조회
			</h2>
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
		<button type="button" class="btn btn-default col-sm-offset-10">구매</button>
		<button type="button" class="btn btn-default">이전</button>
	</div>
</div> <!-- container end -->

</body>
</html> 