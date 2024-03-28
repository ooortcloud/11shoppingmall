<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>상품 정보 수정</title>

<!-- <link rel="stylesheet" href="/css/admin.css" type="text/css">  -->

<script type="text/javascript" src="../javascript/calendar.js">
</script>

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
  
function fncUpdateProduct(){
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
			
		document.detailForm.action='/product/updateProduct';
		document.detailForm.submit();
	}

	
	$( function() {
		  
		$('button:contains("수정")').on('click', function() {
			 fncUpdateProduct(); 
		}).on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});  
		
		
		$('button:contains("삭제")').on('click', function() {
			
			let result = confirm("정말로 해당 상품을 제거하시겠습니까?");
			
			if (result === true) {  
				
				$.ajax({
					// key : value 형식
					url : "/rest/product/json/deleteProduct",
					method : "POST",
					dataType : "JSON",
					headers : {
						"Accept" : "application/json",
						"Content-Type" : "application/json"
					},
					data : JSON.stringify({ 
						prodNo : $('input:hidden[name="prodNo"]').val(),
						fileName : $('input:hidden[name="oldFileName"]').val()
					}),
					success : function(responseBody, httpStatus){
						
						console.log("flag");
						console.log(responseBody);
						if(responseBody.msg != "ok") {
							alert('상품 제거에 실패...');  
						} else {
							alert('상품 제거에 성공하였습니다!');
							window.location.href = "/product/listProduct/manage";
						}
					}
				});
			}
		}).on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});  
		
		$('button:contains("취소")').on('click', function() {
			// $(window.parent.frames["rightFrame"].document.location).attr('href', 'javascript:history.go(-1)');
			window.location.href = '/product/listProduct/manage';
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
	  <h1>상품 수정</h1>
	</div>
	
	<form name="detailForm" method="post" enctype="multipart/form-data">
	
	<input type="hidden" name="prodNo" value="${requestScope.product.prodNo }"/>
	<input type="hidden" name="regDate" value="${product.regDate }"/>
	<input type="hidden" name="oldFileName" value="${product.fileName }" />
	
			  <div class="form-group">
			    <label for="prodName">상품명</label>
			    <input type="text" class="form-control" id="prodName" name="prodName" placeholder="상품명" value="${product.prodName }">
			  </div>
			  <div class="form-group">
			    <label for="prodDetail">상품상세정보</label>
			    <input type="text" class="form-control" id="prodDetail" name="prodDetail" placeholder="상품상세정보" value="${product.prodDetail }">
			  </div>
		  	  <div class="form-group">
			    <label for="manuDate">제조일자</label>
			    <input type="text" name="manuDate" id="manuDate" readonly="readonly" class="ct_input_g"  
								style="width: 100px; height: 19px"	maxLength="10" minLength="6" value="${product.manuDate }"/>
						&nbsp;<img src="../images/ct_icon_date.gif" width="15" height="15" 
												onclick="show_calendar('document.detailForm.manuDate', document.detailForm.manuDate.value)"/>
			  </div>
			  <div class="form-group">
			    <label for="price">가격</label>
			    <label class="sr-only" for="price">가격</label>
			    <div class="input-group">
			      <input type="number" class="form-control" id="price" name="price" placeholder="가격" value="${product.price }">
			      <div class="input-group-addon">원</div>
		    	</div>
			  </div>
			  <div class="form-group">
			    <label for="fileName">상품 이미지</label>
			    <input type="file" id="fileName" name="fileName">
			    <p class="help-block">최대 10MB 이하만 가능합니다...</p>
			  </div>
	
		<div class="row">
			<div class="col-sm-offset-10">
				<button type="button" class="btn btn-default">수정</button>
				
				<button type="button" class="btn btn-default">삭제</button>
				
				<button type="button" class="btn btn-default">취소</button>
			</div>
		</div>
	
	</form>
</div>
</body>
</html>