<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%--  JSP 페이지에서 JSTL Core 라이브러리를 사용하기 위한 태그 라이브러리 선언 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
<title>상품 관리</title>

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
            padding-bottom : 30px;
        }
    </style>


<!-- <link rel="stylesheet" href="/css/admin.css" type="text/css">  -->
 
<script type="text/javascript">
	function fncGetProductList(currentPage) {
		console.log("currentPage = " + currentPage);
		document.getElementById("currentPage").value = currentPage;
 	  	document.detailForm.submit();		
	}
	
	function compare() {
		// input 태그값을 가져올 때 더 가독성있는 함수를 사용하여 가져오자.
		// const min = Number(document.getElementById("priceMin").value);
		// const max = Number(document.getElementById("priceMax").value);
		const min = Number(document.querySelector('input[id="priceMin"]').value);
		const max = Number(document.querySelector('input[id="priceMax"]').value);
		
		console.log("min = " + min);
		console.log("max = " + max);
		
		if( (min < 0) || (max > 2147483647) ) {
			alert("입력 범위를 초과하였습니다.");
		}
		
		if(min != 0 && max != 0) {
			if(min >= max) {
				alert("최소값이 최대값 미만이 되도록 작성해주세요.");
				return ;
			}
		}
		fncGetProductList(document.getElementById("currentPage").value );	
	}

	
	$(function() {
		
		$('button:contains("검색")').on('click', function() {
			document.getElementById('detailForm').submit();
		});
	});
</script>

<!-- jQuery core library 외에도 다양한 library 추가해야 함 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.12.4.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script> 
<script type="text/javascript">



	$( function() {  
		
		$('a').css('text-decoration', 'none');   
		
		$('.ct_btn01:contains("검색")').on('click', function() {
			compare();
		}).on('mouseover', function() {
			$('.ct_btn01:contains("검색")').css('cursor', 'pointer');
		}).on('mouseout', function() {
			$('.ct_btn01:contains("검색")').css('cursor', 'default');
		});
		
		/* 굳이 필요는 없을듯... 현재 hyperlink 방식이라, ajax 리팩토링 비용이 더 큼
		$('li[role="presentation"]:active').on('click', function() {
			console.log('flag');
			$('li[role="presentation"]:active').attr('active', '');
		});
		*/
	});
	
	
	function setTable(responseBody, httpStatus) {
		
		//  list 개수만큼 반복해서 append하면 됨...
		let num = responseBody.resultPage.totalCount;
		// JSTL을 사용하면 사용자의 event에 따라 동적으로 화면 전환이 불가능...
		searchList.append("<p>전체 "+num+" 건수, 현재 "+1+" 페이지</p>");

		/// table head
		let temp = "";  
		temp = "<table class='table table-striped'><thead>"
						+"<th>No</th>"
						+'<th>상품명</th>'
						+'<th>가격</th>'
						+'<th>등록일</th>'
						+'<th>현재상태</th>'
					+"</thead>";
		
		/// table row
		temp += "<tbody>"
		for(const item of responseBody.list) { 
			temp += "<tr>";
			temp += "<th scope='row'>"+num+"</th>";
			temp += "<td><a href='/product/getProduct?prodNo="+item.prodNo+"&menu="+menu+"'>"+item.prodName+"</a></td>";
			temp += "<td>"+item.price+"</td>";
			temp += "<td>"+new Date(item.regDate).toLocaleDateString()+"</td>";  // Date 형식에 맞게 변환 필요
			temp += "<td>";
			let presentState = item.proTranCode;
			if(presentState == null || presentState == '0') {
				temp += "판매 중";
			} else {
				if(menu == "manage") {
					// switch 문 내에서는 type까지 고려하여 비교함 ('===')
					switch(presentState) {
						case '1':
							temp += "<a id='doDelivery' href='/purchase/updateTranCodeByProd?prodNo="+item.prodNo+"&tranCode=2'>client에게 배송하기</a>";
							break;
						case '2':
							temp += "배송 중";
							break;
						case '3':
							temp += "배송 완료";
							break;
						default:
							console.log("error");
							break;
					}
				} else {
					temp += "재고 없음";
				}
			}
			temp += '</td></tr>'; 
			
			num--;
		}  /// for end
		temp += "</tbody></table>";
		searchList.append(temp);
		
		/// page navigator
		temp="";
		const pageNavigator = $('#pager');
		pageNavigator.empty();  // navigator 초기화
		if(responseBody.resultPage.currentPage <= responseBody.resultPage.pageUnit) {
			temp += "<li class='disabled'>";
		} else {
			temp += "<li><a href='javascript:fncGetProductList("+(responseBody.resultPage.beginUnitPage - 1)+")'><span aria-hidden='true'>&laquo;</span></a></li>";
		}

		for(let i = responseBody.resultPage.beginUnitPage; i < responseBody.resultPage.endUnitPage + 1; i++ ) {
			if(i==1) // 검색하면 무조건 첫 page로 회귀
				temp += "<li class='active'>";
			else
				temp += "<li>";
			temp += "<a href='javascript:fncGetProductList("+i+")'>"+i+"</a>";  
			temp += "</li>";
		}
		
		console.log("maxPage :: " + responseBody.resultPage.maxPage);
		if(responseBody.resultPage.endUnitPage >= responseBody.resultPage.maxPage) {
			temp += "<li class='disabled'>";
		} else {
			temp += "<li><a href='javascript:fncGetProductList("+(responseBody.resultPage.endUnitPage + 1)+")'><span aria-hidden='true'>&raquo;</span></a></li>";
		}
		pageNavigator.append(temp);
	}
	
	$( function() { 
		
		const inputKeyword = $('#searchKeyword');
		
		inputKeyword.on('click', function() {  // 첫 입력 버그 제거용
			
			console.log('searchKeyword 입력 대기...');
		});
		
		inputKeyword.on('keyup', function(event) {  // 사용자가 글자를 입력했을 때 :: event를 통해 다양한 정보 주입받기 가능

			/// 실질적인 문자 입력이 아닌 경우 request 안 보냄.
			// keyCode :: ASCII code value
			console.log("flag = " + event.keyCode);
			if( event.keyCode <= 31 ) {
				return ;
			}
		
			$.ajax( {
				 
				url : "/rest/product/json/listProduct/"+$('input[name="menu"]').val()+"/autocomplete",
				method : "POST",
				dataType : "JSON",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				/*
					JSON 객체 :: query string으로 올려 보냄  << URL에 의존적  @ModelAttribute
					JSON string :: body에 그대로 담겨서 보냄  @RequestBody
				*/
				data : JSON.stringify( {
					searchKeyword : inputKeyword.val(),
					priceMin : $('#priceMin').val(),
					priceMax : $('#priceMax').val(),
					currentPage : "1"
				}),   
				success : function(responseBody, httpStatus) {
					
					console.log("server data 수신")
					const arr = new Array();
					// JSON array object로부터 필요한 data만 추출해서 array 생성
					for (const item of responseBody.list) { 
						arr.push(item.prodName); 
					}
					if(responseBody != null) { 
						
						console.log(arr); 

						// 현재 page 첫 load 시 첫 글자 입력 시 활성화가 안 되는 버그 존재...
						inputKeyword.autocomplete({ 
							
							source: arr,  // 검색 결과
							/*
								callback
								event :: 현재 작동한 event listener (추측)
								ui :: 현재 사용 중인 jQuery object
							*/
							select: function(event, ui) {  // callback :: 사용자가 추천 검색어를 클릭했을 때
								
								inputKeyword.autocomplete('close');  // select 후 추천 검색 리스트 자동 닫기
	
								console.log("list 재구성에 필요한 data load...")
								$.ajax( { 
									
									url : "/rest/product/json/listProduct/search",
									method : "POST",
									dataType : "json",
									headers: { 
										"Accept" : "application/json",
										"Content-Type" : "application/json"
									},
									data: JSON.stringify({
										currentPage : "1",
										// searchKeyword : inputKeyword.val()
										searchKeyword : ui.item.value
									}),
									// 기존 UI를 재사용하자...
									success: function(responseBody, httpStatus) {

										console.log("list 재구성...")
										const searchList = $('#searchList');
										searchList.empty();
										
										const menu = $('#menu').val();
										if(menu  == 'manage' ) {
											setTable(responseBody, httpStstus);	
										}
										/// '상품 검색'에서는 무한 scroll로 재구성
										else if ($('#menu').val() == 'search') {
											
										} else {
											// nothing
										}
									}
								});  // list 재구성 end
							}
						});  /// autocomplete callback end
					} else { // if( responseBody === null )
						$('#searchKeyword').autocomplete( 'destroy');
					}
				}  /// success end
			} );  /// ajax end
		});  /// keyup callback end
	});
</script>
</head>

<body>


	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->

<div class="container">
	<div class="page-header">
		<h2>
			<%-- parameter로 받은 data들은 JSTL의 'param' 내부 객체에서 가져옴 --%>
			<%-- EL 내부에서는 '을 사용해서 감싸도 문자열로 취급함 --%>
			<c:if test="${menu == 'manage' }">
				상품 관리
			</c:if><c:if test="${menu == 'search' }">
				상품 목록조회
			</c:if>
		</h2>
	</div>


<form class="form-horizontal" id="detailForm"  name="detailForm" action="/product/listProduct/${menu }" method="post">

<input type="hidden" id="currentPage" name="currentPage" value="${resultPage.currentPage }" />
<input type="hidden" id="menu" name="menu" value="${menu }" />
<input type="hidden" id='priceDESC' name="priceDESC" value="${search.priceDESC}" />

	<div class="form-group">
		<label for="searchKeyword" class="col-sm-1 control-label" >상품명</label>
		<div class="col-sm-5">
			<input type="text" class="form-control" id="searchKeyword" name="searchKeyword" value="${search.searchKeyword }" placeholder = "상품명" />
		</div>
	</div>

	<div class="form-group">
		<label for="priceMin" class="col-sm-1 control-label">상품가격</label>
		<div class="col-sm-2">
			<input type="number" class="form-control"  id="priceMin" name="priceMin" value="${search.priceMin }" placeholder="최소 가격" />
		</div>
		<div class="col-sm-1 text-center">
			&nbsp;~&nbsp;
		</div>
		<div class="col-sm-2">
			<input type="number" class="form-control"  id="priceMax" name="priceMax" value="${search.priceMax }" placeholder = "최대 가격" />
		</div>
	</div>


		 
</form>

	<div class="row">
		<div class="col-sm-11">
		<ui class="nav nav-pills" role="tablist">
			 <!-- 가격 정렬 기능을 클릭한 경우 -->
			<c:if test="${ !empty search.priceDESC}">  
				<!-- 입력한 조건 box에 따라 query string 동적 구현 -->
				<c:if test="${search.priceDESC == 0 }">
					<li role="presentation" class="active"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">낮은가격순</a></li>
					<li role="presentation"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">높은가격순</a></li>
				</c:if><c:if test="${search.priceDESC == 1 }">
					<li role="presentation"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">낮은가격순</a></li>
					<li role="presentation" class="active"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">높은가격순</a></li>
				</c:if>
			</c:if><c:if test="${empty search.priceDESC}"> <!-- 디폴트 --> 
				<li role="presentation"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">낮은가격순</a></li>
				<li role="presentation"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">높은가격순</a></li>
			</c:if> 
		</ui>
		</div>
		<div class="col-sm-1">
			<button type="button" class="btn btn-default">검색</button>
		</div>
	</div>
</div> <!-- container end -->


	<c:if test="${menu=='search' }">
		<div class="container">
			<div class="page-header">
				<h2>상품 리스트</h2>
			</div>
		</div>
		<jsp:include page="/product/mainContents.jsp"></jsp:include>
	</c:if>
	<c:if test="${menu=='manage' }">
	
	<%-- JSTL에서 로컬변수 선언 가능 --%>
	<c:set var="num" value="${resultPage.totalCount - resultPage.pageSize * (resultPage.currentPage -1 ) }" />
	<div class="container" id="searchList">
		<p>전체 ${requestScope.resultPage.totalCount } 건수, 현재 ${resultPage.currentPage } 페이지</p>

		<table class="table table-striped">
			<thead>
				<th>No</th>
				<th>상품명</th>
				<th>가격</th>
				<th>등록일</th>
				<th>현재상태</th>
			</thead>
			<tbody>
				<%-- JSTL에서 index 관리 Collection을 적용한 반복문 사용하기 --%>
				<c:forEach var="product" items="${requestScope.list}">
					<tr>
						<th scope="row">${num }</th>
						<td><a href="/product/getProduct/${menu}?prodNo=${product.prodNo }">${product.prodName }</a></td>
						<td>${product.price }</td>
						<td>${product.regDate }</td>
						<td>
							<%-- JSTL에서 참조 변수를 만들어서 사용 가능 --%>
							<c:set var="presentState" value="${product.proTranCode }" />
							<c:if test="${ (empty presentState) || presentState == 0 }">
								판매 중
							</c:if><c:if test="${ presentState != 0}">
								<c:if test="${menu == 'manage' }">
									<c:choose>
										<c:when test="${presentState == 1 }">
											<!-- <span id="doDelivary">client에게 배송하기</span>  --> 
											<a id="doDelivery" href='/purchase/updateTranCodeByProd?prodNo=${product.prodNo }&tranCode=2'><strong> client에게 배송하기</strong></a> 
										</c:when><c:when test="${presentState == 2 }">
											배송 중	
										</c:when><c:when test="${presentState == 3 }">
											배송 완료
										</c:when>
									</c:choose>
								</c:if><c:if test="${menu == 'search' && !( (empty presentState) || presentState == 0 ) }">
									재고 없음
								</c:if>
							</c:if>
							</td>
						</tr>
						<c:set var="num" value="${num-1 }" />
				</c:forEach>
			</tbody>
		</table>
	</div> <!-- container end -->
	</c:if>


	<!-- search에서만 무한 scroll -->
	<c:if test="${menu == 'manage' }">
		<%-- 하단 페이지 .jsp 모듈을include --%>
		<jsp:include page="/common/pageNavigator.jsp"></jsp:include>
	</c:if>

</body>
</html>
