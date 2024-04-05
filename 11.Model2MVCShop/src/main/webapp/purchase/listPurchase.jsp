<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>구매 목록조회</title>

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
<!-- <link rel="stylesheet" href="/css/admin.css" type="text/css">  -->

	<!--  CSS 추가 : 툴바에 화면 가리는 현상 해결 :  주석처리 전, 후 확인-->
	<style>
        body {
            padding-top : 70px;
            padding-botton : 30px;
        }
   	</style>

<script type="text/javascript">
	function fncGetPurchaseList() {
		document.detailForm.submit();
	}

</script>

<!-- 
<script src="https://code.jquery.com/jquery-2.2.4.js" integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI=" crossorigin="anonymous"></script>
<script type="text/javascript">
	
	$( function() {

			$('#modifier1').on('click', function() {
				$(window.parent.frame['rightFrame'].document.location).attr('href', '/purchase/getPurchase?tranNo=${purchase.tranNo }');
			}).css('color', 'blue').on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});

			$('#modifier2').on('click', function() {
				$(window.parent.frame['rightFrame'].document.location).attr('href', '/purchase/updateTranCode?tranNo=${purchase.tranNo }&tranCode=3');
			}).css('color', 'blue').on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
	});
</script>
 -->
    
</head>

<body bgcolor="#ffffff" text="#000000">

<jsp:include page="/layout/toolbar.jsp"/>

<div class="container">
	
	<form name="detailForm" action="/purchase/listPurchase" method="post">
	
		<input type="hidden" id="currentPage" name="currentPage" value="${resultPage.currentPage }" />
		
		<div class='form-group'>
			<label for='searchKeyword' class="col-sm-1 control-label"	>검색</label> 
			<div class='col-sm-5'>
				<input class='form-control' type="text" id="searchKeyword" name="searchKeyword" value="${search.searchKeyword }" />
			</div>
		</div>
	</form>
</div> <!-- container end -->	

	<div class="container">
		<div class="page-header">
			<h2>구매 목록조회</h2>
		</div>
	</div>
	

<div class='container' id='searchList'>
	<c:set var="num" value="${resultPage.totalCount - resultPage.pageSize * (resultPage.currentPage -1 ) }" />
	<p>전체 ${requestScope.resultPage.totalCount } 건수, 현재 ${resultPage.currentPage } 페이지</p>
	
	<table class='table table-striped'>
		<thead>
			<th>No</th>
			<th>상품ID</th>
			<th>상품명</th>
			<th>구매일자</th>
			<th>배송현황</th>
			<th>정보수정</th>
		</thead>
		<tbody>
			<c:forEach var="purchase" items="${requestScope.list }">
			<tr>
				<th scope='row'>${num }</th>
				<td><a href="/product/getProduct/search?prodNo=${purchase.purchaseProd.prodNo }">${purchase.purchaseProd.prodNo }</a></td>
				<td>${purchase.purchaseProd.prodName }</td>
				<td>${purchase.orderDate }</td>
				<%-- tran_state_code : "1" = "구매완료", "2" = "배송중", "3" = "배송완료" --%>
				<td>
					<c:if test="${ purchase.tranCode == 1 }">
						현재 구매완료 상태입니다.
					</c:if><c:if test="${ purchase.tranCode == 2 }">
						현재 배송중 입니다. 
					</c:if><c:if test="${ purchase.tranCode == 3 }">
						현재 배송완료 상태 입니다.
					</c:if>
				</td>
				<td>
					<c:if test="${purchase.tranCode == 1 }">
						<!-- <span id="modifier1">구매 정보 확인 및 수정</span>  -->
						<a href="/purchase/getPurchase?tranNo=${purchase.tranNo }">구매 정보 확인 및 수정</a> 
					</c:if><c:if test="${purchase.tranCode == 2 }">
						<!-- <span id="modifier2">물건 도착 알리기</span>  -->
						<a href="/purchase/updateTranCode?tranNo=${purchase.tranNo }&tranCode=3">물건 도착 알리기</a>   
					</c:if>
				</td>
			</tr>
			<c:set var="num" value="${ num-1 }" />
		</c:forEach>
		</tbody>
	</table>
</div> <!-- container end -->
	


<jsp:include page="/common/pageNavigator.jsp"></jsp:include>

</body>
</html>