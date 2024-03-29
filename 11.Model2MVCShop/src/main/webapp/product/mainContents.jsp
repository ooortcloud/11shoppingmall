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

	
	// image ������ �� event ó��
	$( function() {
		
		
	});

</script>

	�ȳ��ϼ���

	<%--<c:forEach var="i" begin="1" end='4' step="1">  --%>
	<c:forEach var="product" items="${list }" begin="0" end="7" step="1">

			<div class="col-sm-6 col-md-3">
				<div class="thumbnail" >
					<c:if test="${empty product.fileName }" >
						<img class="my-thumbnail" src="http://placeholder.com/243X200" />
								<!-- null ó���� �ݵ�� 'empty' keyword�� ����ؾ� �Ѵ�. -->		
					</c:if><c:if test='${ !empty product.fileName }' >

							<img class="my-thumbnail" src="/images/uploadFiles/${product.fileName }"  />

					</c:if>
					<div class="caption">
						<h3>${product.prodName }</h3>
						<p>${product.price } ��</p>
					</div>
				</div> <!-- thumbnail end -->
			</div>

	</c:forEach>

