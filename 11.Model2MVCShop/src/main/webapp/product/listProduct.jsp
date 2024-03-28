<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%--  JSP ���������� JSTL Core ���̺귯���� ����ϱ� ���� �±� ���̺귯�� ���� --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
<title>��ǰ ����</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
 
<script type="text/javascript">
	function fncGetProductList(currentPage) {
		console.log("currentPage = " + currentPage);
		document.getElementById("currentPage").value = currentPage;
 	  	document.detailForm.submit();		
	}
	
	function compare() {
		// input �±װ��� ������ �� �� �������ִ� �Լ��� ����Ͽ� ��������.
		// const min = Number(document.getElementById("priceMin").value);
		// const max = Number(document.getElementById("priceMax").value);
		const min = Number(document.querySelector('input[id="priceMin"]').value);
		const max = Number(document.querySelector('input[id="priceMax"]').value);
		
		console.log("min = " + min);
		console.log("max = " + max);
		
		if( (min < 0) || (max > 2147483647) ) {
			alert("�Է� ������ �ʰ��Ͽ����ϴ�.");
		}
		
		if(min != 0 && max != 0) {
			if(min >= max) {
				alert("�ּҰ��� �ִ밪 �̸��� �ǵ��� �ۼ����ּ���.");
				return ;
			}
		}
		fncGetProductList(document.getElementById("currentPage").value );	
	}

</script>

<!-- jQuery core library �ܿ��� �پ��� library �߰��ؾ� �� -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.12.4.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script> 
<script type="text/javascript">

	$( function() {  
		
		$('a').css('text-decoration', 'none');   
		
		$('.ct_btn01:contains("�˻�")').on('click', function() {
			compare();
		}).on('mouseover', function() {
			$('.ct_btn01:contains("�˻�")').css('cursor', 'pointer');
		}).on('mouseout', function() {
			$('.ct_btn01:contains("�˻�")').css('cursor', 'default');
		});
	});
	
	$( function() { 
		
		const inputKeyword = $('#searchKeyword');
		
		inputKeyword.on('click', function() {  // ù �Է� ���� ���ſ�
			
			console.log('searchKeyword �Է� ���...');
		});
		
		inputKeyword.on('keyup', function(event) {  // ����ڰ� ���ڸ� �Է����� �� :: event�� ���� �پ��� ���� ���Թޱ� ����

			/// �������� ���� �Է��� �ƴ� ��� request �� ����.
			// keyCode :: ASCII code value
			console.log("flag = " + event.keyCode);
			if( event.keyCode <= 31 ) {
				return ;
			}
		
			$.ajax( {
				 
				url : "/rest/product/json/listProduct/autocomplete",
				method : "POST",
				dataType : "JSON",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				/*
					JSON ��ü :: query string���� �÷� ����  << URL�� ������  @ModelAttribute
					JSON string :: body�� �״�� ��ܼ� ����  @RequestBody
				*/
				data : JSON.stringify( {
					searchKeyword : inputKeyword.val(),
					priceMin : $('#priceMin').val(),
					priceMax : $('#priceMax').val(),
					currentPage : "1" 
				}),   
				success : function(responseBody, httpStatus) {
					
					console.log("server data ����")
					const arr = new Array();
					// JSON array object�κ��� �ʿ��� data�� �����ؼ� array ����
					for (const item of responseBody.list) { 
						arr.push(item.prodName); 
					}
					if(responseBody != null) { 
						
						console.log(arr); 

						// ���� page ù load �� ù ���� �Է� �� Ȱ��ȭ�� �� �Ǵ� ���� ����...
						inputKeyword.autocomplete({ 
							
							source: arr,  // �˻� ���
							/*
								callback
								event :: ���� �۵��� event listener (����)
								ui :: ���� ��� ���� jQuery object
							*/
							select: function(event, ui) {  // callback :: ����ڰ� ��õ �˻�� Ŭ������ ��
								
								inputKeyword.autocomplete('close');  // select �� ��õ �˻� ����Ʈ �ڵ� �ݱ�
								console.log("list �籸���� �ʿ��� data load...")
								$.ajax( { 
									
									url : "/rest/product/json/listProduct/search",
									method : "POST",
									dataType : "json",
									headers: { 
										"Accept" : "application/json",
										"Content-Type" : "application/json"
									},
									data: JSON.stringify({
										currentPage : "1",
										// searchKeyword : inputKeyword.val()
										searchKeyword : ui.item.value
									}),
									// ���� UI�� ��������...
									success: function(responseBody, httpStatus) {

										console.log("list �籸��...")
										const searchTable = $('#searchTable');
										searchTable.empty();  // ���� list ���� �����.
										
										//  list ������ŭ �ݺ��ؼ� append�ϸ� ��...
										let num = responseBody.resultPage.totalCount;
										const menu = $('#menu').val();
										// JSTL�� ����ϸ� ������� event�� ���� �������� ȭ�� ��ȯ�� �Ұ���...
										searchTable.append("<tr><td colspan='11' >��ü "+responseBody.resultPage.totalCount+" �Ǽ�, ���� "+responseBody.resultPage.currentPage+" ������</td></tr>");
										
										/// table column name list
										let temp = "";  
										temp = "<tr><td class='ct_list_b' width='100'>No</td>"
													+"<td class='ct_line02'></td>"
													+'<td class="ct_list_b" width="150">��ǰ��</td>'
													+'<td class="ct_line02"></td>'
													+'<td class="ct_list_b" width="150">����</td>'
													+'<td class="ct_line02"></td>'
													+'<td class="ct_list_b">�����</td>'
													+'<td class="ct_line02"></td>'
													+'<td class="ct_list_b">�������</td></tr>'
													+"</tr>";
										searchTable.append(temp);
										searchTable.append('<tr><td colspan="11" bgcolor="808285" height="1"></td></tr>\n\n\n');
										
										/// table row
										temp="";
										for(const item of responseBody.list) { 
											temp += "<tr class='ct_list_pop'>\n"
											temp += "<td align='center'>"+num+"</td>\n";
											num--;
											temp += "<td></td>\n";
											temp += "<td align='left'>\n";
											temp += "<a style='text-decoration:none' href='/product/getProduct?prodNo="+item.prodNo+"&menu="+menu+"'><strong>"+item.prodName+"</strong></a>\n";
											temp += "</td>\n"
											temp +=  "<td></td>\n";
											temp += "<td align='left'>"+item.price+"</td>\n";
											temp += "<td></td>\n";
											temp += "<td align='left'>"+new Date(item.regDate).toLocaleDateString()+"</td>\n";  // Date ���Ŀ� �°� ��ȯ �ʿ�
											temp += "<td></td>\n";
											temp += "<td align='left'>\n";
											
											let presentState = item.proTranCode;
											if(presentState == null || presentState == 0) {
												temp += "�Ǹ� ��";
											} else {
												if(menu == "manage") {
													switch(presentState) {
														case 1:
															temp += "<a id='doDelivery' href='/purchase/updateTranCodeByProd?prodNo="+item.prodNo+"&tranCode=2'><strong> client���� ����ϱ�</strong></a>";
															break;
														case 2:
															temp += "��� ��";
															break;
														case 3:
															temp += "��� �Ϸ�";
															break;
													}
												} else {
													temp += "��� ����";
												}
											}
											
											temp += '</td></tr>'; 
										}  /// for end
										
										temp += '<tr><td colspan="11" bgcolor="D6D7D6" height="1"></td></tr>';
										searchTable.append(temp);
										
										/// page navigator
										temp="";
										const pageNavigator = $('td#pageNavigator');
										pageNavigator.empty();  // navigator �ʱ�ȭ
										if(responseBody.resultPage.currentPage <= responseBody.resultPage.pageUnit) {
											temp += "�� ����";
										} else {
											temp += "<a href='javascript:fncGetProductList("+(responseBody.resultPage.beginUnitPage - 1)+")'>�� ����</a>";
										}
										temp += " ";
										console.log("beginUnitPage :: " + responseBody.resultPage.beginUnitPage);
										console.log("endUnitPage :: " + responseBody.resultPage.endUnitPage);
										for(let i = responseBody.resultPage.beginUnitPage; i < responseBody.resultPage.endUnitPage + 1; i++ ) {
											temp += "<a href='javascript:fncGetProductList("+i+")'>"+i+"</a>";
											temp += " ";
										}
										
										console.log("maxPage :: " + responseBody.resultPage.maxPage);
										if(responseBody.resultPage.endUnitPage >= responseBody.resultPage.maxPage) {
											temp += "���� ��";
										} else {
											temp += "<a href='javascript:fncGetProductList("+(responseBody.resultPage.endUnitPage + 1)+")'>���� ��</a>";
										}
										pageNavigator.append(temp);
									}
								});
							}
						});  /// autocomplete callback end
					} else { // if( responseBody === null )
						$('#searchKeyword').autocomplete( 'destroy');
					}
				}  /// success end
			} );  /// ajax end
		});  /// keyup callback end
	});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;"> 

<form name="detailForm" action="/product/listProduct/${menu }" method="post">

<input type="hidden" id="currentPage" name="currentPage" value="${resultPage.currentPage }" />
<input type="hidden" id="menu" name="menu" value="${menu }" />
<input type="hidden" id='priceDESC' name="priceDESC" value="${search.priceDESC}" />

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
					
						<%-- parameter�� ���� data���� JSTL�� 'param' ���� ��ü���� ������ --%>
						<%-- EL ���ο����� '�� ����ؼ� ���ε� ���ڿ��� ����� --%>
						<c:if test="${menu == 'manage' }">
							��ǰ ����
						</c:if><c:if test="${menu == 'search' }">
							��ǰ �����ȸ
						</c:if>
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>	 
		 <li>��ǰ�� ::  
		 	<input 	 type="text" id="searchKeyword" name="searchKeyword"  value="${search.searchKeyword }" 
							class="ct_input_g" style="width:200px; height:19px" >
		</li>
		 <li>��ǰ���� :: 
		 	<input type="text" id="priceMin" name="priceMin" value="${search.priceMin }" 
		 				class="ct_input_g" style="width:200px; height:19px">
		 	 ~ 
		 	<input type="text" id="priceMax" name="priceMax" value="${search.priceMax }" 
		 				class="ct_input_g" style="width:200px; height:19px">
		 </li>
		 
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						�˻�
						<!-- <a href="javascript:compare();">�˻�</a>  -->
					</td>
					<td width="14" height="23">
				     <img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<hr/>

 <!-- ���� ���� ����� Ŭ���� ��� -->
<c:if test="${ !empty search.priceDESC}">  
	<!-- �Է��� ���� box�� ���� query string ���� ���� -->
	<c:if test="${search.priceDESC == 0 }">
		<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>"><strong>�������ݼ�</strong></a></span>
		<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">�������ݼ�</a></span>
	</c:if><c:if test="${search.priceDESC == 1 }">
		<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">�������ݼ�</a></span>
		<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>"><strong>�������ݼ�</strong></a></span>
	</c:if>
</c:if><c:if test="${empty search.priceDESC}"> <!-- ����Ʈ --> 
	<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">�������ݼ�</a></span>
	<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">�������ݼ�</a></span>
</c:if> 

 
<hr/>
<table id="searchTable" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >��ü ${requestScope.resultPage.totalCount } �Ǽ�, ���� ${resultPage.currentPage } ������</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">��ǰ��</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">����</td> 
		<td class="ct_line02"></td>
		<td class="ct_list_b">�����</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">�������</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
	<%-- JSTL���� ���ú��� ���� ���� --%>
	<c:set var="no" value="${resultPage.totalCount - resultPage.pageSize * (resultPage.currentPage -1 ) }" />
	
	<%-- JSTL���� index ���� Collection�� ������ �ݺ��� ����ϱ� --%>
	<c:forEach var="product" items="${requestScope.list }">
	<tr class="ct_list_pop">
		<td align="center">${no }</td>
		<c:set var="no" value="${ no-1 }" />
		<td></td>
		<td align="left">
			<a href="/product/getProduct?prodNo=${product.prodNo }&menu=${menu}"><strong>${product.prodName }</strong></a>
		</td>
		<td></td>
		<td align="left">${product.price }</td>
		<td></td>
		<td align="left">${product.regDate }</td>
		<td></td>
		<td align="left">
		
			<%-- JSTL���� ���� ������ ���� ��� ���� --%>
			<c:set var="presentState" value="${product.proTranCode }" />
			<c:if test="${ (empty presentState) || presentState == 0 }">
				�Ǹ� ��
			</c:if><c:if test="${ presentState != 0}">
				<c:if test="${menu == 'manage' }">
					<c:choose>
						<c:when test="${presentState == 1 }">
							<!-- <span id="doDelivary">client���� ����ϱ�</span>  --> 
							<a id="doDelivery" href='/purchase/updateTranCodeByProd?prodNo=${product.prodNo }&tranCode=2'><strong> client���� ����ϱ�</strong></a> 
						</c:when><c:when test="${presentState == 2 }">
							��� ��	
						</c:when><c:when test="${presentState == 3 }">
							��� �Ϸ�
						</c:when>
					</c:choose>
				</c:if><c:if test="${menu == 'search' && !( (empty presentState) || presentState == 0 ) }">
					��� ����
				</c:if>
			</c:if>
		</td>
	</c:forEach>
		<td></td>
	</tr> 
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
</table>
 
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td id="pageNavigator" align="center">		

		   <%-- �ϴ� ������ .jsp �����include --%>
		   <jsp:include page="/common/pageNavigator.jsp"></jsp:include>
    	</td>
	</tr>
</table>
<!--  ������ Navigator �� -->

</form>

</div>
</body>
</html>
