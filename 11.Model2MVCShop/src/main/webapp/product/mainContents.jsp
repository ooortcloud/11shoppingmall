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
	
	
	/// ���� scroll thumbnail set
	function setThumbnails(responseBody, httpStatus) {
		console.log('flag - end');
	}
	
	/// ���� scroll request
	function getResources() {
		console.log('flag - start');
		// root������ �˻� ���� element���� �������� �����Ƿ� ���� ó��
		if( location.href.substring(location.href.lastIndexOf("/")) == "/" ) {  // test
			$.ajax(	{
				
				url : "/rest/product/json/listProduct/search",
				method : "POST",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				dataType : "JSON",
				// network ��� �ÿ��� ��ü�� �ƴ� string ���·� ��ȯ
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
				// network ��� �ÿ��� ��ü�� �ƴ� string ���·� ��ȯ
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
		<< ��� ������ px >>
		$(window).scrollTop() :: ���� browser�� ���� �������� view(=window) �� top(?)���� ��ġ�� get
		$(window).height() :: ���� browser�� ���� �������� view(=window)�� ����(?)
		$(document).height() :: ���� page�� �� height get (��� �߰��� ���� �������� ����)
		$('body').height() :: body ���� ��ҵ��� �𿩼� �̷��� �� height get (��� �߰��� ���� �������� ����)  << style���� padding�� ������ ��
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
		console.log("total = " + ($(window).scrollTop() + $(window).height() ));
		console.log("body ��ҵ��� ���� �ִ� ����  = " + $('body').height() );
		
		// debounce pattern ���� >> �帣��(?) �ϴ� ���� ������ ȣ�� �� �ϰ� ��
		if ( $(window).scrollTop() + $(window).height() + 10 >= $('body').height() ) { // 10px ����ġ �༭, �ָ��ϰ� ���� ���� �� �ϴ� bug ����
			
			$(window).off('scroll');  // scroll event listener ����
			getResources();
			
			// scroll event listener 0.5�� �� ����
			setTimeout(function() {

			}, 500);
		}  
			
		console.log("\n");
	});

	
</script>

<%-- �������� ������ ������ �����ϴ� ����
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