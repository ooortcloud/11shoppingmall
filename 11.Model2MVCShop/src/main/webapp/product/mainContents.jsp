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

	/// 무한 scroll thumbnail set
	function setThumbnails(responseBody, httpStatus) {

		temp = "<div class='row'>";
		let i = 0;
		for(const product of responseBody.list ) {
			 
			if(i == 4) {
				temp += '</div>';
				temp += '<div class="row">';
			}
			temp += '<div class="col-sm-6 col-md-3">';
			temp += '<div class="thumbnail" style="height = 500px;" onclick=\' location.href = "/product/getProduct/search?prodNo='+product.prodNo+'" \'>';
			
			if(product.fileName == null || product.fileName =='null') {
				temp += '<img class="my-thumbnail" src="http://placeholder.com/243X200" />';
			} else {
				temp += '<img class="my-thumbnail" src="/images/uploadFiles/'+product.fileName+'" />';	
			}
			
			temp += '<div class="caption">';
			temp += '<h3>'+product.prodName+'</h3>';
			temp += '<p>'+product.price+'</p>';
			temp += '</div>';
			temp += '</div>';  <%-- thumbnail end --%>
			temp += '</div>';
			i++;
		}
		temp += '</div>';
		$('#searchList').append(temp);
		
		/// image 위에 mouse 올리면 표시
		// jQuery array가 잡혀 있을 거임
		const thumbnailArr = $('div.thumbnail');
		
		// 모든 element 요소들에 대해 event 적용
		thumbnailArr.on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});	
	}
	
	/// 무한 scroll request
	let currentPage = 1;
	function getResources() {
		console.log("currentPage :: "+ currentPage );
		
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
					// currentPage : $('#tempCurrentPage').val()
					currentPage : currentPage
				}),
				success : function(responseBody, httpStatus) {
					currentPage = responseBody.resultPage.currentPage;
					setThumbnails(responseBody, httpStatus);
				}
			});
		} 
		// 상품 관련 page에서는 검색 조건을 신경써야 함
		else {
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
					currentPage : currentPage,
					searchKeyword : $('#searchKeyword').val(),
					priceMin : $('#priceMin').val(),
					priceMax : $('#priceMax').val()
				}),
				success : function(responseBody, httpStatus) {
					currentPage = responseBody.resultPage.currentPage;
					setThumbnails(responseBody, httpStatus);
				}
			});
		}
	}

	/*
		<< 모든 단위는 px >>
		$(window).scrollTop() :: 현재 browser에 의해 보여지는 view(=window) 중 top(?)쪽의 위치를 get  == window.scrollY
		window.innerHeight :: 현재 browser에 보여지는 view의 길이(?)
		$(document).height() :: 현재 page의 총 height get (요소 추가에 따라 동적으로 변함)  == $(window).height() == document.body.scrollHeight
		$('body').height() :: body 구성 요소들이 모여서 이뤄진 총 height get (요소 추가에 따라 동적으로 변함)  << style에서 padding을 제외한 값
	*/
	// page 첫 load 시 이미 window height가 body height를 넘어섰으면, body height가 window height를 넘어설 때까지 resource get
	console.log("현재 요소들이 구성한 총 높이 = " + $('body').height() );
	console.log("window 길이 = " + $(window).height() );
	if ( $('body').height() < $(window).height() )
		getResources();
	console.log("\n");
	
		
	/// scroll event :: throttle pattern
	var throttleTimer = null;
	$(window).on('scroll', function() {

		if( !throttleTimer) {
			// 일정 시간동안 event를 lock건다.
			throttleTimer = setTimeout(function() {
				if (window.scrollY + window.innerHeight >= document.body.scrollHeight - 300) {
					getResources();
				}
				throttleTimer = null;
			}, 150);
		}
		
		console.log("\n");
	});

	
</script>

<div class="container"  id="searchList">

	<%--
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
	 --%>
</div> <!-- container end -->