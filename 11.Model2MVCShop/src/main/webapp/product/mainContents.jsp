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
	
	
	/// 무한 scroll
	function getResources() {
		console.log('flag');
	}
	/*
		<< 모든 단위는 px >>
		$(window).scrollTop() :: 현재 browser에 의해 보여지는 view(=window) 중 top(?)쪽의 위치를 get
		$(window).height() :: 현재 browser에 의해 보여지는 view(=window)의 길이(?)
		$(document).height() :: 현재 page의 총 height get (요소 추가에 따라 동적으로 변함)
		$('body').height() :: body 구성 요소들이 모여서 이뤄진 총 height get (요소 추가에 따라 동적으로 변함)  << document와 큰 차이는 나지 않는 듯.
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
		console.log("현재 page 최대 높이 = " + $(document).height() );
		console.log("$('body').height()  = " + $('body').height() );
		console.log("\n");
		if ( $(window).scrollTop() + $(window).height() + 10 >= $('body').height() )  // 10px 보정치 줘서, 애매하게 조건 만족 못 하는 bug 잡음
			getResources();
	});

	
</script>

<div class="container" >

	<%--<c:forEach var="i" begin="1" end='4' step="1">  --%>
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