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

	
	<%--  c:forEach �ȿ��� ������ prodNo �����ͼ� �־��� �� �ִ�...
	// image ������ �� event ó��
	$( function() {
		
		// jQuery array�� ���� ���� ����
		const imgArr = $('div.thumbnail img.my-thumbnail');
		console.log(imgArr.html() )
		
		imgArr.attr('onclick', 'location.href = "/product/getProduct/search?prodNo=${product.prodNo}"');  // ��ü�� ���� event listener attribute �߰� 
	});
--%>
</script>

<div class="container" >

	<%--<c:forEach var="i" begin="1" end='4' step="1">  --%>
	<div class="row">
	<c:forEach var="product" items="${list }" begin="0" end="3" step="1">

			<div class="col-sm-6 col-md-3">
				<div class="thumbnail" style="height = 500px;" >
					<c:if test="${empty product.fileName }" >
						<img class="my-thumbnail" src="http://placeholder.com/243X200" />
								<!-- null ó���� �ݵ�� 'empty' keyword�� ����ؾ� �Ѵ�. -->		
					</c:if><c:if test='${ !empty product.fileName }' >

						<img class="my-thumbnail" src="/images/uploadFiles/${product.fileName }" onclick=' location.href = "/product/getProduct/search?prodNo=${product.prodNo}" '/>

					</c:if>
					<div class="caption">
						<h3>${product.prodName }</h3>
						<p>${product.price } ��</p>
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
								<!-- null ó���� �ݵ�� 'empty' keyword�� ����ؾ� �Ѵ�. -->		
					</c:if><c:if test='${ !empty product.fileName }' >

							<img class="my-thumbnail" src="/images/uploadFiles/${product.fileName }" onclick=' location.href = "/product/getProduct/search?prodNo=${product.prodNo}" ' />

					</c:if>
					<div class="caption">
						<h3>${product.prodName }</h3>
						<p>${product.price } ��</p>
					</div>
				</div> <!-- thumbnail end -->
			</div>

	</c:forEach>
	</div>
	
</div> <!-- container end -->
