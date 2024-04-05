<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%-- JSTL = JavaServerPage(JSP) Tag Library --%>
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

<title>상품 상세 조회</title>

<script type="text/javascript" src="../javascript/calendar.js">
</script>


<script type="text/javascript">

	function check() {
		let divyDate = document.querySelector('input[name="divyDate"]').value;
		if(divyDate === '') {
			alert("배송 희망 일자는 필수 입력 사항입니다.");
			return false;
		}
		
		let phoneNum = document.querySelector('input[name="receiverPhone"]').value;
		if( !phoneNum.includes('-')) {
			alert('반드시 "-"와 함께 입력해주세요.');
			return false;
		}
			
		return true;
	}
	
	
	function fncAddPurchase() {
		if (check() === true)
			document.addPurchase.submit();
	}

	
	$( function() {  
		 
		$('button:contains("구매")').on('click', function() {
			// $(window.parent.frames["rightFrame"].document.location).attr('href', 'javascript:fncAddPurchase()');
			fncAddPurchase();
		}).on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});
		
		$('button:contains("취소")').on('click', function() {
			// $(window.parent.frames["rightFrame"].document.location).attr('href', 'javascript:history.go(-1)');  // 반드시 'javascript:'를 명시해주어야 한다.\
			window.location.href="/product/listProduct/search";
		}).on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});
	});

</script>
</head>

<body>

	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->



<div class="container">
		<div class="page-header">
		  <h2>상품 상세 조회</h2>
		</div>
</div>

<div class='container'>

	<form name="addPurchase" method="post" action="/purchase/addPurchase">
		<%-- hidden 속성을 이용해 form으로 controller에서 작업 수행 시 필요한 값을 전달 --%>
		<input type="hidden" name="prodNo" value="${purchase.purchaseProd.prodNo }" />
	
		<div class='form-group'>
			<label for='prodNo'>상품 번호</label>
			<input class='form-control' type='number' placeholder='${purchase.purchaseProd.prodNo }' disabled>
		</div>
	
		<div class='form-group'>
			<label for='prodName'>상품명</label>
			<input class='form-control'type='text' placeholder='${purchase.purchaseProd.prodName }' disabled>
		</div>
		
		<div class='form-group'>
			<label for='prodDetail'>상품 상세 정보</label>
			<input class='form-control' type='text' placeholder='${purchase.purchaseProd.prodDetail}' disabled>
		</div>
		
		<div class='form-group'>
			<label for='manuDate'>제조 일자</label>
			<input class='form-control'  type='text' placeholder='${purchase.purchaseProd.manuDate}' disabled>
		</div>
	
		<div class='form-group'>
			<label for='manuDate'>가격</label>
			<input class='form-control'  type='number' placeholder='${purchase.purchaseProd.price}' disabled>
		</div>
		
		<div class='form-group'>
			<label for='manuDate'>등록일자</label>
			<input class='form-control' type='text' placeholder='${purchase.purchaseProd.regDate}' disabled>
		</div>
		
		<div class='form-group'>
			<label for='buyerId'>구매자아이디</label>
			<input class='form-control' type='text' placeholder='${purchase.buyer.userId}' disabled>
		</div>
		
		<div class='form-group'>
			<label for='paymentOption'>구매방법</label>
			<select 	name="paymentOption"		class="form-control" >
				<option value="1" selected="selected">현금구매</option>
				<option value="2">신용구매</option>
			</select>
		</div>
		
		<div class='form-group'>
			<label for='receiverName'>구매자이름</label>
			<input class='form-control' type='text' name='receiverName' placeholder='구매자 본인의 이름을 입력해주세요.'>
		</div>
		
		<div class='form-group'>
			<label for='receiverPhone'>구매자연락처</label>
			<input class='form-control' type='text' name='receiverPhone' placeholder='"-"를 포함하여 입력해주세요.'>
		</div>
		
		<div class='form-group'>
			<label for='divyAddr'>구매자주소</label>
			<input class='form-control' type='text' name='divyAddr' placeholder='구매자 주소를 입력해주세요.'>
		</div>
		
		<div class='form-group'>
			<label for='divyRequest'>구매요청사항</label>
			<input class='form-control' type='text' name='divyRequest' placeholder='구매 요청사항을 입력해주세요.'>
		</div>
		
		<div class='form-group'>
			<label for='divyDate'>배송희망일자</label>
			<input 	type="text" readonly="readonly" name="divyDate" class="ct_input_g" 
							style="width: 100px; height: 19px" maxLength="20"/>
			<img 	src="../images/ct_icon_date.gif" width="15" height="15"	
						onclick="show_calendar('document.addPurchase.divyDate', document.addPurchase.divyDate.value)"/>
		</div>
	</form>
</div>  <!-- container end -->

<div class='container'>
	<div class='row'>
		<div class='col-sm-offset-10'>
			<button type='button' class='btn btn-default'>구매</button>
			<button type='button' class='btn btn-default'>취소</button>
		</div>
	</div>
</div> <!-- container end -->

</body>
</html>