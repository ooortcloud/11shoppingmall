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

	

	// image ���� mouse �ø��� ǥ��
	$( function() {
		
		// jQuery array�� ���� ���� ����
		const thumbnailArr = $('div.thumbnail');
		
		// ��� element ��ҵ鿡 ���� event ����
		thumbnailArr.on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});	
	});
	
	
	/// ���� scroll
	function getResources() {
		console.log('flag');
	}
	/*
		<< ��� ������ px >>
		$(window).scrollTop() :: ���� browser�� ���� �������� view(=window) �� top(?)���� ��ġ�� get
		$(window).height() :: ���� browser�� ���� �������� view(=window)�� ����(?)
		$(document).height() :: ���� page�� �� height get (��� �߰��� ���� �������� ����)
		$('body').height() :: body ���� ��ҵ��� �𿩼� �̷��� �� height get (��� �߰��� ���� �������� ����)  << document�� ū ���̴� ���� �ʴ� ��.
	*/
	// page ù load �� �̹� window height�� body height�� �Ѿ����, body height�� window height�� �Ѿ ������ resource get
	console.log("���� ��ҵ��� ������ �� ���� = " + $('body').height() );
	console.log("window ���� = " + $(window).height() );
	if ( $('body').height() < $(window).height() )
		getResources();
	console.log("\n");
	
	$(window).on('scroll', function() {
		
		console.log("scroll head ��ġ = " + $(window).scrollTop() );
		console.log("window ���� = " + $(window).height() );
		console.log("���� page �ִ� ���� = " + $(document).height() );
		console.log("$('body').height()  = " + $('body').height() );
		console.log("\n");
		if ( $(window).scrollTop() + $(window).height() + 10 >= $('body').height() )  // 10px ����ġ �༭, �ָ��ϰ� ���� ���� �� �ϴ� bug ����
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
								<!-- null ó���� �ݵ�� 'empty' keyword�� ����ؾ� �Ѵ�. -->		
					</c:if><c:if test='${ !empty product.fileName }' >

						<img class="my-thumbnail" src="/images/uploadFiles/${product.fileName }" />

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
				<div class="thumbnail" style="height = 500px;" onclick=' location.href = "/product/getProduct/search?prodNo=${product.prodNo}" '>
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
	</div>
	
</div> <!-- container end -->