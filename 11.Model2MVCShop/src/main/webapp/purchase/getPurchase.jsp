<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
	<title>구매상세조회</title>

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
  <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <!-- jQuery UI toolTip 사용 JS-->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

	<script src="https://code.jquery.com/jquery-2.2.4.js" integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI=" crossorigin="anonymous"></script>
	<script type="text/javascript">
		
		$( function() {
			
			$('button:contains("수정")').on('click', function() {
				// $(window.parent.frames["rightFrame"].document.location).attr('href', '/purchase/updatePurchase?tranNo=${purchase.tranNo}');
				window.location.href = '/purchase/updatePurchase?tranNo=${purchase.tranNo}';
			}).on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
			
			$('button:contains("확인")').on('click', function() {
				// $(window.parent.frames["rightFrame"].document.location).attr('href', 'javascript:history.go(-1)');
				history.go(-1);
			}).on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
		});
	</script>
	
		<!--  CSS 추가 : 툴바에 화면 가리는 현상 해결 :  주석처리 전, 후 확인-->
	<style>
        body {
            padding-top : 70px;
            padding-botton : 30px;
        }
   	</style>
	

</head>

<body bgcolor="#ffffff" text="#000000">


	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->
   	
<div class="container">
	<div class="page-header">
	  <h1>구매 상세 조회</h1>
	</div>
 </div>
 
 
<div class='container'>
	<table class='table'>
		<tbody>
			<tr>
				<th scope="row">물품번호</th>
				<!-- object scope 종류 :: pageScope < requestScope < sessionScope < applicationScope -->
				<td>${requestScope.purchase.purchaseProd.prodNo }</td>
			</tr>
			<tr>
				<th scope='row'>구매자아이디</th>
				<td>${purchase.buyer.userId }</td>
			</tr>
			<tr>
				<th scope='row'>구매방법</th>
				<td>
					<c:if test="${purchase.paymentOption == '1' }">
					현금구매 
					</c:if><c:if test="${purchase.paymentOption == '2' }">
					신용구매
					</c:if>
				</td>
			</tr>
			<tr>
				<th scope='row'>구매자이름</th>
				<td>${purchase.receiverName }</td>
			</tr>
			<tr>
				<th scope='row'>구매자연락처</th>
				<td>${purchase.receiverPhone }</td>
			</tr>
			<tr>
				<th scope='row'>구매자주소</th>
				<td>${purchase.divyAddr }</td>
			</tr>
			<tr>
				<th scope='row'>구매요청사항</th>
				<td>${purchase.divyRequest }</td>
			</tr>
			<tr>
				<th scope='row'>배송희망일자</th>
				<td>${purchase.divyDate }</td>
			</tr>
			<tr>
				<th scope='row'>주문일</th>
				<td>${purchase.orderDate }</td>
			</tr>
		</tbody>
	</table>
	
	<div class="row">
		<div class="col-sm-offset-10">
			<button type="button" class="btn btn-default">수정</button>
		  	<button type="button" class="btn btn-default">확인</button>
		</div>
	</div>
	
</div>  <!-- container end -->
</body>
</html>