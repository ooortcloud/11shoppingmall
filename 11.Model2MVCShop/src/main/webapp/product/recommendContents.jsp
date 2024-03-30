<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<!--  ///////////////////////// JSTL  ////////////////////////// -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>

	$( function() {
		
		$('div.carousel-inner').on('mouseover', function() {
			$(this).css('cursor', 'pointer');
		}).on('mouseout', function() {
			$(this).css('cursor', 'default');
		});	
	});
</script>


<div class="container">
		<div class="page-header">
		  <h1><span class="glyphicon glyphicon-heart" aria-hidden="true"></span>&nbsp;추천 상품<small>&nbsp;&nbsp;우리 매장에서 엄선해서 추천하는 제품들이에요</small></h1>
		</div>

	    <!-- Carousel
	    ================================================== -->
	    <div id="myCarousel" class="carousel slide" data-ride="carousel">
	      <!-- Indicators -->
	      <ol class="carousel-indicators">
	        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
	        <li data-target="#myCarousel" data-slide-to="1"></li>
	        <!-- <li data-target="#myCarousel" data-slide-to="2"></li>  -->
	      </ol>
	      <div class="carousel-inner" role="listbox">
	        <div class="item active" onclick=' location.href = "/product/getProduct/search?prodNo=10120" '>
	        <!-- 어차피 마케팅 문구 직접 달아야 하니까 static하게 만드는 것이 최선이다 vs 유지보수를 최우선적으로 알고리즘을 활용하여 자동으로 load되도록 만들어야 한다 -->
	          <img class="first-slide" src="/images/bigThumbnails/shampoo_big_thumbnail.webp" alt="First slide" >
	          <div class="container">
	            <div class="carousel-caption">
	              <h1>폴리페놀 성분으로 만든 볼륨샴푸</h1>
	              <!-- <p>Note: If you're viewing this page via a <code>file://</code> URL, the "next" and "previous" Glyphicon buttons on the left and right might not load/display properly due to web browser security rules.</p> -->
	              <p>탈모, 빈모로 고민하고 얇고 힘없는 모발을 가진 소비자들을 위해 모발에 건강한 힘을 주는 만능 샴푸! 여러가지 시행착오와 수만번의 시험을 거쳐서 기능적인 면을 정조준해 만든 제품. </p>
	              <!-- image click 시 page 이동하도록 변경 -->
	              <!-- <p><a class="btn btn-lg btn-primary" href="#" role="button">Sign up today</a></p>  -->
	            </div>
	          </div>
	        </div>
	        <div class="item" onclick=' location.href = "/product/getProduct/search?prodNo=10121" '>
	          <img class="second-slide" src="/images/bigThumbnails/galaxy_book_4_big_ thumbnail.webp" alt="Second slide" >
	          <div class="container">
	            <div class="carousel-caption">
	              <h1>갤럭시북4 국내 판매 10만 기념 프로모션</h1>
	              <p>머신런닝과 딥러닝 등 AI 퍼포먼스를 지원해주는 신경처리장치(NPU)가 적용된, 새로운 인텔 코어 울트라 프로세서가 탑재된 갤럭시북4와 함께하세요!</p>
  	              <!-- image click 시 page 이동하도록 변경 -->
	              <!-- <p><a class="btn btn-lg btn-primary" href="#" role="button">Sign up today</a></p>  -->
	            </div>
	          </div>
	        </div>
	        <%--
	        <div class="item">
	          <img class="third-slide" src="http://placeholder.com/1140X500" alt="Third slide">
	          <div class="container">
	            <div class="carousel-caption">
	              <h1>One more for good measure.</h1>
	              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
  	              <!-- image click 시 page 이동하도록 변경 -->
	              <!-- <p><a class="btn btn-lg btn-primary" href="#" role="button">Sign up today</a></p>  -->
	            </div>
	          </div>
	        </div>
	      </div>
	       --%>
	      <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
	        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
	        <span class="sr-only">Previous</span>
	      </a>
	      <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
	        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
	        <span class="sr-only">Next</span>
	      </a>
	    </div><!--.carousel inner end -->
	</div> <!-- carousel end -->
</div> <!-- container end -->