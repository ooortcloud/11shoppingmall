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
		const imgArr = $('div.thumbnail img.my-thumbnail');
		
		// 모든 element 요소들에 대해 event 적용
		imgArr.on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});	
	});

</script>

<div class="container" >

	<%--<c:forEach var="i" begin="1" end='4' step="1">  --%>
	<div class="row">
	<c:forEach var="product" items="${list }" begin="0" end="3" step="1">

			<div class="col-sm-6 col-md-3">
				<div class="thumbnail" style="height = 500px;" >
					<c:if test="${empty product.fileName }" >
						<img class="my-thumbnail" src="http://placeholder.com/243X200" />
								<!-- null 처리는 반드시 'empty' keyword를 사용해야 한다. -->		
					</c:if><c:if test='${ !empty product.fileName }' >

						<img class="my-thumbnail" src="/images/uploadFiles/${product.fileName }" onclick=' location.href = "/product/getProduct/search?prodNo=${product.prodNo}" '/>

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
				<div class="thumbnail" style="height = 500px;" >
					<c:if test="${empty product.fileName }" >
						<img class="my-thumbnail" src="http://placeholder.com/243X200" />
								<!-- null 처리는 반드시 'empty' keyword를 사용해야 한다. -->		
					</c:if><c:if test='${ !empty product.fileName }' >

							<img class="my-thumbnail" src="/images/uploadFiles/${product.fileName }" onclick=' location.href = "/product/getProduct/search?prodNo=${product.prodNo}" ' />

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
