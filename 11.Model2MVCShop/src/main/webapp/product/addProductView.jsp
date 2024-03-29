<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<html>
<head>
<title>상품등록</title>

<!-- <link rel="stylesheet" href="/css/admin.css" type="text/css"> -->

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
        }
   	</style>

<script type="text/javascript" src="../javascript/calendar.js">
</script>

<script type="text/javascript">

function fncAddProduct(){
	//Form 유효성 검증
 	var name = document.detailForm.prodName.value;
	var detail = document.detailForm.prodDetail.value;
	var manuDate = document.detailForm.manuDate.value;
	var price = document.detailForm.price.value;

	if(name == null || name.length<1){
		alert("상품명은 반드시 입력하여야 합니다.");
		return;
	}
	if(detail == null || detail.length<1){
		alert("상품상세정보는 반드시 입력하여야 합니다.");
		return;
	}
	if(manuDate == null || manuDate.length<1){
		alert("제조일자는 반드시 입력하셔야 합니다.");
		return;
	}
	if(price == null || price.length<1){
		alert("가격은 반드시 입력하셔야 합니다.");
		return;
	}

	document.detailForm.action='/product/addProduct';    

	document.detailForm.submit();
}


$( function() {
	
	$('button:contains("등록")').on('click', function() {
		fncAddProduct();
	});
	
	$('button:contains("초기화")').on('click', function() {
		document.detailForm.reset();
	});
	
	$('button:contains("취소")').on('click', function() {
		window.location.href="/product/listProduct/manage";
	});
	
})


</script>

</head>

<body bgcolor="#ffffff" text="#000000">

	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->



<div class="container">
		<div class="page-header">
		  <h2>상품등록</h2>
		</div>

<!-- file upload를 위해 encode type 변경 -->
<form name="detailForm" method="post" enctype="multipart/form-data">
	
		  <div class="form-group">
		    <label for="prodName">상품명</label>
		    <!-- form data는 반드시 name에 담아야 @ModelAttribute에서 인식함... -->
		    <input type="text" class="form-control" id="prodName" name="prodName" placeholder="상품명">
		  </div>
		  <div class="form-group">
		    <label for="prodDetail">상품상세정보</label>
		    <input type="text" class="form-control" id="prodDetail" name="prodDetail" placeholder="상품상세정보">
		  </div>
	  	  <div class="form-group">
		    <label for="manuDate">제조일자</label>
		    <input type="text" name="manuDate" readonly="readonly" class="ct_input_g"  
							style="width: 100px; height: 19px"	maxLength="10" minLength="6"/>
					&nbsp;<img src="../images/ct_icon_date.gif" width="15" height="15" 
											onclick="show_calendar('document.detailForm.manuDate', document.detailForm.manuDate.value)"/>
		  </div>
		  <div class="form-group">
		    <label for="price">가격</label>
		    <label class="sr-only" for="price">가격</label>
		    <div class="input-group">
		      <input type="number" class="form-control" id="price" name="price" placeholder="가격">
		      <div class="input-group-addon">원</div>
	    	</div>
		  </div>
		  <div class="form-group">
		    <label for="thumbnail">상품 이미지</label>
		    <input type="file" id="thumbnail" name="thumbnail">
		    <p class="help-block">최대 10MB 이하만 가능합니다...</p>
		  </div>
		  
		  <div class="row">
		  	<div class="col-sm-offset-10">
			  <button type="button" class="btn btn-default">등록</button>
	
				<button type="button" class="btn btn-default">초기화</button>
		
				<button type="button" class="btn btn-default">취소</button>
			</div>
		</div>
</form>
</div>
</body>
</html>