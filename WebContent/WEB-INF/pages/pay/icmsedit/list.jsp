<%@page import="com.forms.platform.web.WebUtils"%>
<%@page import="com.forms.platform.web.consts.WebConsts"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.formssi.com/taglibs/froms" prefix="forms" %>
<%@ taglib uri="/platform-tags" prefix="p" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>影像编辑查询</title>
<script>
function pageInit()
{   
	App.jqueryAutocomplete();
	$("#cntType").combobox();
	$("#ouCode").combobox();
	$( "#befDate" ).datepicker({
		changeMonth: true,
		changeYear: true,
	    dateFormat:"yy-mm-dd"
	});
	$( "#aftDate" ).datepicker({
		changeMonth: true,
		changeYear: true,
	    dateFormat:"yy-mm-dd"
	});
}
function resetAll(){
	$(":text").val("");
	$("select").val("");
	$("select").each(function(){
		var id = $(this).attr("id");
		if(id!=""){
			var year = $("#"+id+" option:first").text();
			$(this).val(year);
			 $(this).next().val(year) ;
		}
		
	});
}
function selProvider(){
	$.dialog.open(
			'<%=request.getContextPath()%>/sysmanagement/provider/searchProvider.do?<%=WebConsts.FUNC_ID_KEY %>=010710',
			{
				width: "75%",
				height: "90%",
				lock: true,
			    fixed: true,
			    title:"供应商选择",
			    id:"dialogCutPage",
				close: function(){
					var object = art.dialog.data('object'); 
					if(object){
						$("#providerName").val(object.providerName);
					}
					}		
			}
		 );
}
function showDetail(payId,isPrePay,cntNum,monDataFlag,icmsEdit,isCreditNote,invoiceIdBlue){
	var form = $("#queryDetailForm");
 	$("#queryDetailForm #payId1").val(payId);
	$("#queryDetailForm #isPrePay1").val(isPrePay);
	$("#queryDetailForm #cntNum1").val(cntNum);
	$("#queryDetailForm #isCreditNote1").val(isCreditNote);
	$("#queryDetailForm #invoiceIdBlue1").val(invoiceIdBlue);
 	form.attr('action', '<%=request.getContextPath()%>/pay/icmsedit/detail.do?<%=WebConsts.FUNC_ID_KEY%>=0303090302');
	App.submit(form);
}
function doValidate(){
	if(!$.checkDate("befDate","aftDate")){
		return false;
	}
	return true;
}

</script>
</head>
<body>
<p:authFunc funcArray="0303090301"/>
<form action="" method="post" id="queryDetailForm">
	<input type="hidden" id="payId1" name="payId"  class="base-input-text"/>
	<input type="hidden" id="isPrePay1" name="isPrePay"  class="base-input-text"/>
	<input type="hidden" id="cntNum1" name="cntNum"  class="base-input-text"/>
	<input type="hidden" id="isCreditNote1" name="isCreditNote"  class="base-input-text"/>
	<input type="hidden" id="invoiceIdBlue1" name="invoiceIdBlue"  class="base-input-text"/>
</form>
<form  method="post" id="tempForm">
<input type="hidden" id="isPrePay" name="isPrePay">
	<p:token/>
	<table id="condition">
		<tr class="collspan-control">
			<th colspan="4">
				付款查询
			</th>
		</tr>
		<tr>
			<td class="tdLeft">合同号</td>
			<td class="tdRight">
				<input type="text" id="cntNum" name="cntNum" value="${selectInfo.cntNum}" class="base-input-text"  maxlength="80"/>
			</td>
			<td class="tdLeft">合同类型</td>
			<td class="tdRight">
            	<div class="ui-widget">
					<select id="cntType" name="cntType"   class="erp_cascade_select">
						<option value="">-请选择-</option>
						<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME" 
						 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" orderType="DESC"  conditionStr="CATEGORY_ID='CNT_TYPE'" selectedValue="${selectInfo.cntType}"/>
					</select>
				</div>	
			</td>
		</tr>
		<%-- <tr>
			<td class="tdLeft">所属财务中心</td>
			<td class="tdRight">
					<div class="ui-widget">
					<select id="ouCode" name="ouCode"  class="erp_cascade_select">
						<option value="">-请选择-</option>
						<c:forEach items="${ouCodeList}" var="sedList">
							<option value="${sedList.ouCode}" <c:if test="${sedList.ouCode==selectInfo.ouCode}">selected="selected"</c:if>>${sedList.ouName}</option>
						</c:forEach>
					</select>
				</div>	
			</td> 
			<td class="tdLeft">付款单创建责任中心</td>
			<td class="tdRight">
				<%-- <forms:OrgSelPlugin   rootLevel="0" jsVarGetValue="createDept" rootNodeId="${org1Code}" initValue="${selectInfo.createDept}"/> 
				<forms:OrgSelPlugin suffix="c" rootNodeId="${org1Code}" initValue="${selectInfo.createDept}" jsVarGetValue="createDept" parentCheckFlag="false"/>
			</td>
		</tr>--%>
		<tr>
			<td class="tdLeft">付款单号</td>
			<td class="tdRight">
				<input type="text" id="payId" name="payId" value="${selectInfo.payId}" class="base-input-text" maxlength="20"/>&nbsp;&nbsp;	
			</td>
			<td class="tdLeft">付款日期区间</td>
			<td class="tdRight">
				<input id="befDate"  name="befDate" style="width: 35%;" readonly="readonly" value="${selectInfo.befDate}" class="base-input-text"/>至
				<input id="aftDate"  name="aftDate" style="width: 35%;" readonly="readonly" value="${selectInfo.aftDate}" class="base-input-text"/>
			</td>
		</tr>
		<tr>
			<td class="tdLeft">供应商</td>
			<td class="tdRight">
				<input type="text" id="providerName" name="providerName" value="${selectInfo.providerName}" class="base-input-text" maxlength="30"/>	
				<a href="#" onclick="selProvider()">
				<img  height="100%" src="<%=request.getContextPath()%>/common/images/search1.jpg" alt="查看供应商" style="border:0px;cursor:pointer;vertical-align: middle;margin-left:0px;heigth:30px;width:30px;"/>
				</a>	
			</td>
			<td class="tdLeft">付款单创建责任中心</td>
			<td class="tdRight">
				<%-- <forms:OrgSelPlugin   rootLevel="0" jsVarGetValue="createDept" rootNodeId="${org1Code}" initValue="${selectInfo.createDept}"/> --%>
				<forms:OrgSelPlugin suffix="c" rootNodeId="${org1Code}" initValue="${selectInfo.createDept}" jsVarGetValue="createDept" parentCheckFlag="false"/>
			</td>
		</tr>	
		<tr>
			<td colspan="4" class="tdWhite">
				<p:button funcId="0303090301" value="查询"/> 
				<input type="button" value="重置" onclick="resetAll();">
			</td>
		</tr>
	</table>
	<br/>
<div id="tabs" style="border: 0;">
	<div id="tabs-1" style="padding: 0;">
		<table class="tableList">
			<tr>    
			 	<th width="12%">合同号</th>
				<th width="8%">合同事项</th>
				<th width="8%">合同类型</th>
				<th width="8%">付款单号</th>
				<th width="8%">付款日期</th>
				<th width="8%">付款类型</th>
				<th width="8%">发票金额(元)</th>
				<th width="10%">收款单位</th>
				<th width="8%">状态</th>
				<th width="8%">图像编辑状态</th>
				<th width="8%">申请人</th>
				<th width="6%">操作</th>
			</tr>
			 <c:forEach items="${icmsList}" var="sedList">
				<tr onmouseover="setTrBgClass(this, 'trOnOver2');" onmouseout="setTrBgClass(this, 'trOther');">
					<td class="tdc" ><a href="javascript:void(0);" onclick="gotoCntDtl('${sedList.cntNum }');" class="text_decoration">${sedList.cntNum }</a></td>
					<td class="tdc" ><c:out value="${sedList.cntName}"></c:out></td>
					<td class="tdc" >${sedList.cntTypeName }<c:if test="${sedList.isOrder == 1}">/非订单</c:if><c:if test="${sedList.isOrder == 0}">/订单</c:if></td>
					<td class="tdc" ><c:out value="${sedList.payId}"></c:out></td>
					<td class="tdc" ><c:out value="${sedList.payDate}"/></td>
					<td >
						<c:if test="${sedList.isPrePay=='Y'}">
							<c:out value="预付款"/>
						</c:if>
						<c:if test="${sedList.isPrePay=='N'}">
							<c:if test="${sedList.isCreditNote== '0'}">
								贷项通知单
							</c:if>
							<c:if test="${sedList.isCreditNote== '1'}">
								正常付款
							</c:if>
						</c:if>
					</td>
					<td class="tdr" ><fmt:formatNumber type="number" value="${sedList.invoiceAmt}" minFractionDigits="2"/></td>
					<td><c:out value="${sedList.providerName}"/></td>
					<td>
						<c:out value="${sedList.payDataFlag}"/>
					</td>
					<td >
						<c:if test="${sedList.icmsEdit== '0'}">
							无需编辑
						</c:if>
						<c:if test="${sedList.icmsEdit== '1'}">
							编辑申请中
						</c:if>
						<c:if test="${sedList.icmsEdit== '2'}">
							编辑完成
						</c:if>
					</td>
					<td>
						<c:out value="${sedList.instOper}"/>
					</td>
					<td>
						<c:if test="${sedList.isEnable=='Y'}">
							<div class="update">
								<a href="#" onclick="showDetail('${sedList.payId}','${sedList.isPrePay}','${sedList.cntNum}', '${sedList.icmsEdit}','${sedList.isCreditNote}','${sedList.invoiceIdBlue}')" title="确认"></a>
							</div>
						</c:if>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty icmsList}">
					<tr><td style="text-align: center;" colspan="12"><span class="red">没有找到相关信息</span></td></tr>
			</c:if>
		</table>
	</div>
</div>
</form>
<p:page />
</body>
</html>