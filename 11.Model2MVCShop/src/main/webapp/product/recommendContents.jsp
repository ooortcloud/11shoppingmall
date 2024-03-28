<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<!--  ///////////////////////// JSTL  ////////////////////////// -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
	        <li data-target="#myCarousel" data-slide-to="2"></li>
	      </ol>
	      <div class="carousel-inner" role="listbox">
	        <div class="item active">
	          <img class="first-slide" src="http://placeholder.com/1140X500" alt="First slide">
	          <div class="container">
	            <div class="carousel-caption">
	              <h1>Example headline.</h1>
	              <p>Note: If you're viewing this page via a <code>file://</code> URL, the "next" and "previous" Glyphicon buttons on the left and right might not load/display properly due to web browser security rules.</p>
	              <!-- image click 시 page 이동하도록 변경 -->
	              <!-- <p><a class="btn btn-lg btn-primary" href="#" role="button">Sign up today</a></p>  -->
	            </div>
	          </div>
	        </div>
	        <div class="item">
	          <img class="second-slide" src="http://placeholder.com/1140X500" alt="Second slide">
	          <div class="container">
	            <div class="carousel-caption">
	              <h1>Another example headline.</h1>
	              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
  	              <!-- image click 시 page 이동하도록 변경 -->
	              <!-- <p><a class="btn btn-lg btn-primary" href="#" role="button">Sign up today</a></p>  -->
	            </div>
	          </div>
	        </div>
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
	      <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
	        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
	        <span class="sr-only">Previous</span>
	      </a>
	      <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
	        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
	        <span class="sr-only">Next</span>
	      </a>
	    </div><!-- /.carousel -->
	</div> <!-- container end -->