<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>


<!--  ///////////////////////// JSTL  ////////////////////////// -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
	.my-thumbnail:hover {
		transform : scale(1.02);
		transition : .5s;
	}

</style>

<script>

	// image 위에 mouse 올리면 표시
	$( function() {
		
		// jQuery array가 잡혀 있을 거임
		const thumbnailArr = $('div.thumbnail');
		
		// 모든 element 요소들에 대해 event 적용
		thumbnailArr.on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});	
	});
	
	
	/// 무한 scroll thumbnail set
	function setThumbnails(responseBody, httpStatus) {
		console.log('flag - end');
	}
	
	/// 무한 scroll request
	function getResources() {
		console.log('flag - start');
		// root에서는 검색 관련 element들이 존재하지 않으므로 예외 처리
		if( location.href.substring(location.href.lastIndexOf("/")) == "/" ) {  // test
			$.ajax(	{
				
				url : "/rest/product/json/listProduct/search",
				method : "POST",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				dataType : "JSON",
				// network 통신 시에는 객체가 아닌 string 형태로 변환
				data : JSON.stringify({
					currentPage : $('#tempCurrentPage').val()
				}),
				success : function(responseBody, httpStatus) {
					setThumbnails(responseBody, httpStatus);
				}
			});
		} else {
				$.ajax(	{
				
				url : "/rest/product/json/listProduct/search",
				method : "POST",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				dataType : "JSON",
				// network 통신 시에는 객체가 아닌 string 형태로 변환
				data : JSON.stringify({
					currentPage : $('#tempCurrentPage').val(),
					searchKeyword : $('#searchKeyword').val(),
					priceMin : $('#priceMin').val(),
					priceMax : $('#priceMax').val()
				}),
				success : function(responseBody, httpStatus) {
					setThumbnails(responseBody, httpStatus);
				}
			});
		}
	}

	/*
		<< 모든 단위는 px >>
		$(window).scrollTop() :: 현재 browser에 의해 보여지는 view(=window) 중 top(?)쪽의 위치를 get
		$(window).height() :: 현재 browser에 의해 보여지는 view(=window)의 길이(?)
		$(document).height() :: 현재 page의 총 height get (요소 추가에 따라 동적으로 변함)
		$('body').height() :: body 구성 요소들이 모여서 이뤄진 총 height get (요소 추가에 따라 동적으로 변함)  << style에서 padding을 제외한 값
	*/
	// page 첫 load 시 이미 window height가 body height를 넘어섰으면, body height가 window height를 넘어설 때까지 resource get
	console.log("현재 요소들이 구성한 총 높이 = " + $('body').height() );
	console.log("window 길이 = " + $(window).height() );
	if ( $('body').height() < $(window).height() )
		getResources();
	console.log("\n");
	
	$(window).on('scroll', function() {
		
		console.log("scroll head 위치 = " + $(window).scrollTop() );
		console.log("window 길이 = " + $(window).height() );
		console.log("total = " + ($(window).scrollTop() + $(window).height() ));
		console.log("body 요소들이 만들어낸 최대 높이  = " + $('body').height() );
		
		// debounce pattern 적용 >> 드르륵(?) 하는 동안 여려번 호출 안 하게 됨
		if ( $(window).scrollTop() + $(window).height() + 10 >= $('body').height() ) { // 10px 보정치 줘서, 애매하게 조건 만족 못 하는 bug 잡음
			
			$(window).off('scroll');  // scroll event listener 제거
			getResources();
			
			// scroll event listener 0.5초 후 재등록
			setTimeout(function() {

			}, 500);
		}  
			
		console.log("\n");
	});

	
</script>

<%-- 보이지는 않지만 공간을 차지하는 문제
 <p id="tempCurrentPage"  style="visibility : hidden;">1</p> 
 --%>
<p id="tempCurrentPage"  style="display : none;">1</p>

<div class="container"  id="searchList">

	<div class="row">
	<c:forEach var="product" items="${list }" begin="0" end="3" step="1">

			<div class="col-sm-6 col-md-3">
				<div class="thumbnail" style="height = 500px;" onclick=' location.href = "/product/getProduct/search?prodNo=${product.prodNo}" '>
					<c:if test="${empty product.fileName }" >
						<img class="my-thumbnail" src="http://placeholder.com/243X200" />
								<!-- null 처리는 반드시 'empty' keyword를 사용해야 한다. -->		
					</c:if><c:if test='${ !empty product.fileName }' >

						<img class="my-thumbnail" src="/images/uploadFiles/${product.fileName }" />

					</c:if>
					<div class="caption">
						<h3>${product.prodName }</h3>
						<p>${product.price } 원</p>
					</div>
				</div> <!-- thumbnail end -->
			</div>

	</c:forEach>
	</div>
	
	<div class="row">
	<c:forEach var="product" items="${list }" begin="4" end="7" step="1">

			<div class="col-sm-6 col-md-3">
				<div class="thumbnail" style="height = 500px;" onclick=' location.href = "/product/getProduct/search?prodNo=${product.prodNo}" '>
					<c:if test="${empty product.fileName }" >
						<img class="my-thumbnail" src="http://placeholder.com/243X200" />
								<!-- null 처리는 반드시 'empty' keyword를 사용해야 한다. -->		
					</c:if><c:if test='${ !empty product.fileName }' >

							<img class="my-thumbnail" src="/images/uploadFiles/${product.fileName }"  />

					</c:if>
					<div class="caption">
						<h3>${product.prodName }</h3>
						<p>${product.price } 원</p>
					</div>
				</div> <!-- thumbnail end -->
			</div>

	</c:forEach>
	</div>
	
</div> <!-- container end -->