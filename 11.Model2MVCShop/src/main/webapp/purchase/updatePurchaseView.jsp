<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
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
   
   
   <!-- jQuery UI toolTip 사용 CSS-->
  <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <!-- jQuery UI toolTip 사용 JS-->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	
	<!--  CSS 추가 : 툴바에 화면 가리는 현상 해결 :  주석처리 전, 후 확인-->
	<style>
        body {
            padding-top : 70px;
            padding-botton : 30px;
        }
   	</style>
 
<title>구매정보 수정</title>

<script src="https://code.jquery.com/jquery-2.2.4.js" integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI=" crossorigin="anonymous"></script>
<script type="text/javascript">

	function checkNull() {
		let divyDate = document.querySelector('input[name="divyDate"]').value;
		if(divyDate === '') {
			alert("배송 희망 일자는 필수 입력 사항입니다.");
			return false;
		}
		return true;
	}

	function fncUpdatePurchase() {
		if (checkNull() === true) {
			document.updatePurchase.submit();
		}
			
	}
	
	$( function() {
		
		$('button:contains("수정")').on('click', function() {
			// $(window.parent.frames['rightFrame'].document.location).attr('href', 'javascript:fncUpdatePurchase()');
			fncUpdatePurchase();
		}).on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});
		
		$('button:contains("취소")').on('click', function() {
			// $(window.parent.frames['rightFrame'].document.location).attr('href', 'javascript:history.go(-1)');
			history.go(-1);
		}).on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});
	});
</script>

<script type="text/javascript" src="../javascript/calendar.js"></script>

</head>

<body bgcolor="#ffffff" text="#000000">

	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->



<div class="container">
		<div class="page-header">
		  <h2>구매 정보 수정</h2>
		</div>
</div>

<div class='container'>
	<form name="updatePurchase" method="post"	action="/purchase/updatePurchase?tranNo=${purchase.tranNo }">
	
	<!-- name을 OGNL에 맞게 하면, spring container가 알아서 auto binding한다. -->
	<input type="hidden" name="purchaseProd.prodNo" value="${purchase.purchaseProd.prodNo}" />
	<input type="hidden" name="buyer.userId" value="${purchase.buyer.userId }" />
	<input type="hidden" name="orderDate" value="${purchase.orderDate }" />
	
	
		<div class='form-group'>
			<label for='buyerId'>구매자아이디</label>
			<input class='form-control' type='text' placeholder='${purchase.buyer.userId}' disabled>
		</div>
		
		<div class='form-group'>
			<label for='paymentOption'>구매방법</label>
			<select 	name="paymentOption"		class="form-control" >
				<option value="1" <c:if test="${purchase.paymentOption == 1 }"> selected="selected" </c:if>>현금구매</option>
				<option value="2" <c:if test="${purchase.paymentOption == 2 }"> selected="selected" </c:if>>신용구매</option>
			</select>
		</div>
		
		<div class='form-group'>
			<label for='receiverName'>구매자이름</label>
			<input class='form-control' type='text' name='receiverName' placeholder='구매자 본인의 이름을 입력해주세요.' value="${purchase.receiverName }">
		</div>
		
		<div class='form-group'>
			<label for='receiverPhone'>구매자연락처</label>
			<input class='form-control' type='text' name='receiverPhone' placeholder='"-"를 포함하여 입력해주세요.' value="${purchase.receiverPhone }">
		</div>
		
		<div class='form-group'>
			<label for='divyAddr'>구매자주소</label>
			<input class='form-control' type='text' name='divyAddr' placeholder='구매자 주소를 입력해주세요.' value="${purchase.divyAddr }" >
		</div>
		
		<div class='form-group'>
			<label for='divyRequest'>구매요청사항</label>
			<input class='form-control' type='text' name='divyRequest' placeholder='구매 요청사항을 입력해주세요.'  value="${purchase.divyRequest }">
		</div>
		
		<div class='form-group'>
			<label for='divyDate'>배송희망일자</label>
			<input 	type="text" readonly="readonly" name="divyDate" class="ct_input_g" 
							style="width: 100px; height: 19px" maxLength="20"/>
			<img 	src="../images/ct_icon_date.gif" width="15" height="15"	
						onclick="show_calendar('document.updatePurchase.divyDate', document.updatePurchase.divyDate.value)"/>
		</div>
	</form>
	
	<div class="row">
		<div class="col-sm-offset-10">
			<button type="button" class="btn btn-default">수정</button>
		  	<button type="button" class="btn btn-default">취소</button>
		</div>
	</div>
</div> <!-- container end -->
</body>
</html>