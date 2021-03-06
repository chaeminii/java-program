<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
 <script src="<c:url value='/resources/js/storage.js' />" charset="utf-8"></script>

<header class="clearboth">
    <div class="logo" onclick="location.href='${pageContext.request.contextPath}/front/main/main.do'">
        <img src="${pageContext.request.contextPath}/resources/images/logo.jpg" alt="nff 로고" />
    </div>
    <div class="search">
    <form id="sto_search" action="${pageContext.request.contextPath}/front/store/storelist.do" method="post">
    	<input type="hidden" name="flag" value="1" />
    	<!-- 검색어 입력 부분 -->
		<input type="text" name="keyword"/>
		 <!-- 검색 버튼 부분 -->
        <div class="icon_w" id="search_btn"><button type="submit"><i class="fa fa-search" aria-hidden="true"></i></button></div>
        <div class="optionBox hidden">
        	<ul class="optionTab clearboth">
            	<li class="on">분류</li>
            	<li>위치</li>
            	<li>가격대</li>
        	</ul>
        	
        	<div class="select clearboth tab_1">
          		<!-- 카테고리 별 검색-->
         		<c:forEach items="${cateList}" var="t" >
	        		<div>
	            		<label for="foodtype_${t.categoryNo}" class="types">${t.categoryName}</label>
	            		<input id="foodtype_${t.categoryNo}" name="categoryCode" value="${t.categoryNo}" type="checkbox" class="hidden" />
	            	</div>
         		</c:forEach>
            </div>
          	<!-- tab_1 -->
          
          	<div class="select clearboth tab_2 hidden">
          		<!-- 지역구 별 검색 -->
          		<c:forEach items="${cityList}" var="ct" varStatus="status">
	            	<div>
	              		<label for="city_${status.count}" class="types">${ct}</label>
	              		<input id="city_${status.count}" name="cities" value="${ct}" type="checkbox" class="hidden" />
	            	</div>
          		</c:forEach>
          	</div>
          	<!-- tab_2 -->
          
          
          	<div class="select clearboth tab_3 hidden">
          		<!-- 가격별 검색 -->
          		<c:forEach items="${priceList}" var="price" varStatus="status">
	            	<div>
	              		<label for="price_${status.count}" class="types">${price.priceType}</label>
	              		<input id="price_${status.count}" type="checkbox" name="priceTypeNo" value="${price.priceTypeNo}" class="hidden" />
	            	</div>
          		</c:forEach>
          	</div>
          <!-- tab_3 -->

          	<div class="closedstore"> 
	      		<label for="closed" class="types">영업 종료한 가게도 포함하기</label>
	      		<input id="closed" type="checkbox" name="includeClosed" value="1" class="price hidden"  />
          	</div> 
          <!-- userselect-->
		</div>
	</form>
    </div>
    <div class="float_r">
      <ul>
        <li id="mysurrounding">내주변맛집</li>
        <li><a href="${pageContext.request.contextPath}/front/award/awardlist.do">NFF Awards</a></li>
         <c:if test="${loginUser != null or loginStore != null}">
	        <li id="notice_btn" data-user="${loginUser}" data-store="${loginStore}">
	        	<i class="fa fa-bell-o" aria-hidden="true" ></i>
				<!--새 알림 갯수 뿌려줄 span  -->
	        	<span class="newnotice"></span>
	        	<!-- 알림 리스트 나올 div -->
	        	<div class="notice_list_box hidden">
		        	<div class="topshape"></div>
				    <!-- 알림 리스트 나올 div -->
		        	<div class="notice_content" id="notice" style="overflow: auto">
						<ul></ul>
		        	</div>
	        	</div>
	        </li>
         </c:if> 
        
        <li id="person_btn"><i class="fa fa-user-o" aria-hidden="true"></i>
		<!-- 팝업 (로그인 X) -->
		<div class="pop_person nMember hidden">
	        <div class="topshape"></div>
	        <c:choose>
	        <c:when test="${loginUser != null}">
	        <div>
	        	<div id="sidebox">
					<div class="recent_box">최근 본 맛집</div>
					<div id="viewlist"></div>
					<div id="viewnone">최근 본 페이지가 없습니다</div>
	        	</div>
	        </div>
	        </c:when>
	        <c:when test="${loginStore != null}">
	        <div>
				<a href="${pageContext.request.contextPath}/front/store/storedetail.do?no=${loginStore.storeNo}">MY PAGE</a>
	        </div>
	        </c:when>
	        <c:otherwise>
	        <div>
	        	로그인 후<br />
				이용 가능합니다
	        </div>
	        </c:otherwise>
	        </c:choose>
	        
	        <div>
	           <c:choose>
				<c:when test="${loginUser != null}">
				<ul>
					<li><a href="${pageContext.request.contextPath}/front/login/userdetail.do?no=${loginUser.userNo}">MY PAGE / </a><a href="${pageContext.request.contextPath}/front/login/logout.do">로그아웃</a></li>
				</ul>
				</c:when>
				<c:when test="${loginStore != null}">
				<ul>
					<li><a href="${pageContext.request.contextPath}/front/login/logout.do">로그아웃</a></li>
				</ul>
				</c:when>
				<c:otherwise>
	            <ul>
	                <li><a href="${pageContext.request.contextPath}/front/login/userLoginForm.do">로그인 / 회원가입</a></li>
	            </ul>
				</c:otherwise>
	           </c:choose>
	        </div>
	    </div>
		</li>
      </ul>
    </div>
  </header>
  <script>
	/* var currentPosition = parseInt($("#sidebox").css("top")); 
	$(window).scroll(function() { 
		var position = $(window).scrollTop(); 
 		$("#sidebox").stop().animate({"top":position+currentPosition+"px"},1000); 
		}); */
	
	var list = sessionStorage.getItem('list');
	if(list) {
		console.log(list);
		$("#viewnone").hide();
			var viewList = [];
			var array = list.substring(1, list.length-1).split(",");
			for (i in array){
				var strArray = array[i].substring(1, array[i].length-1).split('|');
				var tag = '<div class="viewDetail">'
								+'<a class="vsName" href="${pageContext.request.contextPath}/front/store/storedetail.do?no='+strArray[0]+'">' 
								+ strArray[1] +'</a></div>';
				viewList += tag;
			}
			$('#viewlist').html(viewList);

	} else if(!list){
		$('#viewlist').hide();
	} 
</script>

  <script type="text/javascript">
	let context = '${pageContext.request.contextPath}';
</script>
<script src='${pageContext.request.contextPath}/resources/js/header.js' ></script>
  