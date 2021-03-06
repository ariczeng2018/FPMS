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
<title>合同新增</title>
<style type="text/css">
	a:HOVER {
		cursor: pointer;
	}
	/* .ui-datepicker-calendar {
		display: none;
	} */
}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/common/js/check.js"></script>
<script type="text/javascript">
var isCntSuccScan = false;

function hsm(subId,amt,strBuf){ 
    this.subId=subId; 
    this.amt=amt; 
    this.strBuf=strBuf;
}
function param(startDate,endDate,paramList){ 
    this.startDate = startDate;
    this.endDate = endDate;
    this.paramList = paramList; 
}
//获取费用类型的弹出页
function feeTypePage(){
	var url="<%=request.getContextPath()%>/contract/initiate/feeTypePage.do?<%=WebConsts.FUNC_ID_KEY %>=0302010102";
	var data = {};
	if(!checkFeeAmt()){
		App.notyError("采购项目总金额与合同金额不一致！");
		return false;
	}
	if($.isBlank($("#tableDiv").html())){
		var feeStartDate = $("#feeStartDate").val();
	    var feeEndDate = $("#feeEndDate").val();
	    if($.isBlank(feeStartDate)){
	    	App.notyError("请先输入受益起始日期！");
	    	return false;
	    }else if($.isBlank(feeEndDate)){
	    	App.notyError("请先输入受益结束日期！");
	    	return false;
	    }
	    var paramList = new Array();
	    var totalNumTrList = $("#totalNumTable tr");
	    if(totalNumTrList.length < 2){
	    	App.notyError("请先选择采购项目！");
	    	return false;
	    }
	    for(var i=1;i<totalNumTrList.length;i++){
	    	var cglCode = $(totalNumTrList[i]).find("input[name='trCglCode']").val();
	    	var matrCode = $(totalNumTrList[i]).find("input[name='matrCode']").val();
	    	var matrName = $(totalNumTrList[i]).find("input[name='matrName']").val();
	    	var hsmAmt = $(totalNumTrList[i]).find("input[name='execAmt']").val();
	    	var feeDept = $(totalNumTrList[i]).find("input[name='feeDept']").val();
	    	var feeDeptName = $(totalNumTrList[i]).find("input[name='feeDeptName']").val();
	    	var specialName = $(totalNumTrList[i]).find("select[name='special']").next().val();
	    	var special = $(totalNumTrList[i]).find("select[name='special']").val();
	    	var referenceName = $(totalNumTrList[i]).find("select[name='reference']").next().val();
	    	var reference = $(totalNumTrList[i]).find("select[name='reference']").val();
	    	if($.isBlank(cglCode)){
	    		App.notyError("请先选择物料类型！");
	    		$(totalNumTrList[i]).find("input[name='matrName']").focus();
	        	return false;
	    	}
	    	if($.isBlank(feeDept)){
	    		App.notyError("请先选择费用承担部门信息！");
	    		$(totalNumTrList[i]).find("input[name='feeDept']").focus();
	        	return false;
	    	}
	    	if($.isBlank(hsmAmt)){
	    		App.notyError("请先输入物料采购的单价和数量！");
	    		$(totalNumTrList[i]).find("input[name='execPrice']").focus();
	        	return false;
	    	}
	    	if($.isBlank(special)){
	    		App.notyError("请先输入专项信息！");
	    		$(totalNumTrList[i]).find("select[name='special']").focus();
	        	return false;
	    	}
	    	if($.isBlank(reference)){
	    		App.notyError("请先输入参考信息！");
	    		$(totalNumTrList[i]).find("select[name='reference']").focus();
	        	return false;
	    	}
	    	//var strBuf = feeDeptName+ 物料编码+物料名称+核算码+specialName + referenceName; 下划线分隔
	    	var strBuf = feeDeptName + "_" + matrCode + "_" + matrName + "_" +cglCode + "_" + specialName + "_" + referenceName;
	    	var getHsm = new hsm(i,hsmAmt,strBuf);
	    	paramList[i-1] = getHsm;
	    }
	    var paramData = new param(feeStartDate,feeEndDate,paramList);
	    data['paramData'] = paramData;
	}else{
		data['targetT'] = $("#tableDiv").html();
	}
	App.submitShowProgress();
	window.dialogArguments=data;
	var returnValue = window.showModalDialog(url, data, "dialogHeight=600px;dialogWidth=1200px;center=yes;status=no;help:no;scroll:yes;resizable:no");
	if(returnValue == null)
	{
		App.submitFinish();
		return null;
	}
	else
	{
		App.submitFinish();
		$("#tableDiv").empty();
		$("#tableDiv").append(returnValue);
	}
}
//当费用类型的查询条件发生改变时，清空tableDiv
function removeFeeInfoTable(){
	$("#tableDiv").empty();
}
//校验采购项目与合同金额是否匹配
function checkFeeAmt(){
    var totalNumTrList = $("#totalNumTable tr");
	var totalAmt = 0;
	if(totalNumTrList.length < 2){
		App.notyError("采购项目数量不能为0！");
		return false;
	}
	for(var i=1;i<totalNumTrList.length;i++){
		var execAmt = $(totalNumTrList[i]).find("input[name='execAmt']").val();
		totalAmt = $.numberFormatAdd($.numberFormat(totalAmt,3),$.numberFormat(execAmt,3),2);
	} 
	if(totalAmt*1!=$("#cntAmt").val().replace(/\,/g,'')*1){
		return false;
	}
	return true;
}
//获取项目，校验时间是否在项目的有效时间内
function checkProjDate(){
	var strs;
	var signDate=$("#signDate").val();
	var url = "projmanagement/projectMgr/ajaxCheckDate.do?<%=WebConsts.FUNC_ID_KEY%>=021005&signDate="+signDate;
	App.ajaxSubmitForm(url, $("#addForm"),  
    		function(data){
				var setList = data.set;
				strs = setList;
	});
	return strs;
}
//获取项目预算，并校验是否超出
function getProjAmt(){
	var overProjName = "";
	var url = "contract/modify/checkProAmt.do?<%=WebConsts.FUNC_ID_KEY%>=0302010203";
	App.ajaxSubmitForm(url, $("#addForm"),  
    		function(data){
				var projName = data.projName;
				overProjName = projName;
			});
	return overProjName;
}


// 添加项目预算金额校验
function checkProjAmt(){
	var totalNumTrList = $("#totalNumTable tr");
	if(totalNumTrList.length < 2){
		App.notyError("采购项目数量不能为0！");
		return false;
	}
	var pass = true;
	var projName = getProjAmt();
	if(null != projName && "" != projName){
		
		if(!confirm("项目["+projName+"]的采购金额超出剩余项目预算，是否继续新增合同？")){
			pass = false;
		}
	}
	return pass;
}

</script>
<script type="text/javascript">
var reg=/^[1-9]{1}[0-9]*$/;
function pageInit() {
	App.jqueryAutocomplete();
	$(".selectS").combobox();
	$(".selectC").combobox();
	$(".selectD").combobox();
	$("#TenancyDzTable .ui-autocomplete-input").css("width","40px");
	$("#totalNumTable .ui-autocomplete-input").css("width","80px");
	$("#signDate,#beginDate,#endDate,.jdDate,#feeStartDate,#feeEndDate,#actualFeeEndDate").datepicker({
		changeMonth: true,
		changeYear: true,
	    dateFormat:"yy-mm-dd"
	});
	var _parseDate = $.datepicker.parseDate;
	$.datepicker.parseDate = function (format,value,settings){
		if (format == 'yy-mm')
			return _parseDate.apply(this,['yy-mm-dd',value+'-01',settings]);
		else 
			return _parseDate.apply(this,arguments);
	};
	$(".toDate").datepicker({
		changeMonth: true,
		changeYear: true,
	    dateFormat:"yy-mm"/* ,
	    onClose:function(dateText,inst) {
	    	var month = $("#ui-datepicker-div .ui-datepicker-month option:selected").val();
	    	var year = $("#ui-datepicker-div .ui-datepicker-year option:selected").val();
	    	var newMonth = (parseInt(month)+1).toString();
	    	if (newMonth.length == 1) {
	    		newMonth = '0'+newMonth;
	    	}
	    	$(this).val(year+'-'+newMonth);
	    } */
	});
	
	/* if(getMonthOverFlag()){
		App.notyError("月结状态中，暂不能进行合同新增操作！");
	} */
}

function getMonthOverFlag(){
	var url = "contract/initiate/getMonthOverFlag.do?<%=WebConsts.FUNC_ID_KEY%>=0302010105";
	var returnValue ;
	App.ajaxSubmit(url, {data:{},async : false},  
   		function(data){
			var monthOverFlag = data.monthOverFlag;
			returnValue =  monthOverFlag;
		});
	return returnValue;
}

//校验合同金额是否等于采购金额
function checkCntAmt(){
	var cntAmt = $("#cntAmt").val();
	var cntTaxAmt = $("#cntTaxAmt").val();
	var totalCntAmt = $("#execAmt1").html();
	var totalCntTaxAmt = $("#cntTaxAmt1").html();
// 	var trList = $("#totalNumTable tr:gt(0)");
// 	for(var i=0; i<trList.length; i++){
// 		totalCntAmt += Number($(trList[i]).find("input[name='execAmt']").val());
// 		totalCntTaxAmt +=  Number($(trList[i]).find("input[name='cntTrAmt']").val());
// 	}
	if(Number(cntAmt) != Number(totalCntAmt)){
		App.notyError("合同不含税金额不等于物料行的不含税金额之和！");
		return false;
	}
	if(Number(cntTaxAmt) != Number(totalCntTaxAmt)){
		App.notyError("合同税额不等于物料行的税额之和！");
		return false;
	}
	return true;
}

//金额校验函数，参数为所需校验的对象
function checkMoney(obj){
	if(!$.checkMoney($(obj).val()))
	{
		App.notyError("数据有误！最多含两位小数的18位正浮点数。");
		$(obj).focus();
		return false;
	} 
	return true;
}

//数量校验函数
function checkNum(obj){
	if(!$.checkRegExp($(obj).val(),reg)){
		App.notyError("数据有误，请输入正整数！");
		$(obj).focus();
		return false;
	}
	return true;
}

//校验电子审批审批数量
function checkDZSP(){
	var DZSPTrList = $("#DZSPTable tr");
	if(DZSPTrList.length < 2){
		App.notyError("请至少选择一条电子审批记录！");
		return false;
	}
	for(var i=1;i<DZSPTrList.length;i++){
		var abcdeNum = $(DZSPTrList[i]).find("input[name='abcdeNum']");
// 		var abcdeAmt = $(DZSPTrList[i]).find("input[name='abcdeAmt']");
// 		if(!$.checkMoney($(abcdeAmt).val())){
// 			App.notyError("第【"+i+"】条电子审批记录的金额输入值不合法，请重新输入！");
// 			return false;
// 		}else 
		if(!$.checkRegExp($(abcdeNum).val(),reg)){
			App.notyError("第【"+i+"】条电子审批记录的数量输入值不合法，请重新输入！");
			return false;
		}
	}
	getAbcdeAmt();
	getAbcdeNum();
	return true;
}

//汇总电子审批金额
function getAbcdeAmt(){
	var DZSPTrList = $("#DZSPTable tr");
	var totalAmt=0;
	for(var i=1;i<DZSPTrList.length;i++)
	{
		var abcdeAmt = $(DZSPTrList[i]).find("input[name='projCrAmt']").val();
		totalAmt=$.numberFormatAdd($.numberFormat(totalAmt,3),$.numberFormat(abcdeAmt,3),2);
	}
	$("#lxje").val(totalAmt); 
	$("#lxjeSpan").text(totalAmt);
}

//汇总电子审批数量
function getAbcdeNum(){
	var DZSPTrList = $("#DZSPTable tr");
	var totalNum=0;
	for(var i=1;i<DZSPTrList.length;i++)
	{
		var abcdeNum = $(DZSPTrList[i]).find("input[name='abcdeNum']").val();
		totalNum=(parseInt(totalNum)+parseInt(abcdeNum));
	}
	if($.isNumeric(totalNum)){
		$("#lxsl").val(totalNum);
		$("#lxslSpan").text(totalNum);
	}
}

//重置表单
function resetAll(){
	$("select").val("");
	$(":text").val("");
	$(":selected").prop("selected",false);
	$("select").each(function(){
		var id = $(this).attr("id");
		if(id!=""){
			var year = $("#"+id+" option:first").text();
			$(this).val(year);
			 $(this).next().val(year) ;
		}
		
	});
}

//审批类别下拉框改变触发(除签报立项外，其他两种类型签报文号不能输入)
function changLxlx(){
	var changeVal = $("#lxlx").val();
	$("#addlxslImg,#DZSPTr,#lxjeRedSpan,#lxslRedSpan,#qbhTdLeft,#qbhTdRight").hide();
	$("#qbh").removeAttr("valid");
	$("#lxsl,#lxje").show();
	$("#lxslSpan,#lxjeSpan").text("");
	$("#DZSPTr").removeClass("collspan");
	$("#lxlx").parent().parent().attr("colspan","3");
	if(changeVal == 1){
		//电子审批
		$("#addlxslImg,#DZSPTr").show();
		$("#lxsl,#lxje").hide();
		$("#lxslSpan,#lxjeSpan").text(0);
		$("#DZSPTr").addClass("collspan");
		getAbcdeNum();
		getAbcdeAmt();
		$("#qbh").val("");
	}else if(changeVal == 2){
		//签报立项
		$("#qbhTdLeft,#qbhTdRight,#lxjeRedSpan,#lxslRedSpan").show(); 
		$("#qbh").attr("valid","");
		$("#lxlx").parent().parent().attr("colspan","1");
	}else if(changeVal == 3){
		//部内审批
		$("#lxjeRedSpan,#lxslRedSpan").show();
		$("#qbh").val("");
	}
}

//合同类型下拉框改变触发
var curCntType = 0;
function changeCntType(){
	var changeVal = $("#cntType").val();
	if(changeVal != curCntType){
		$("#totalNumTable tr:gt(0)").remove();
		$("#execAmt1").html(0);
		$("#cntTaxAmt1").html(0);
		addTotalNum();
		$("#totalNum").val(0);
		$("#totalNumSpan").text(0);
		$("#tableDiv").empty();
		$("#isProvinceBuy").combobox("destroy").val("").combobox();
		$("#isProvinceBuyTr").hide();
		$("#isSpec").combobox("destroy").val("").combobox();
		$(".feeClass").hide();
		$(".feeClass input").removeAttr("valid");
		$(".feeClass select").removeAttr("valid");
		$("#execNumTdInit").empty();//移除初始行内容
		if(changeVal == 0){
			//资产类
			$("#execNumTdInit").append('<input type="text" valid name="execNum" class="base-input-text" style="width:60px;" onblur="computTotalNum(this)" onchange="removeFeeInfoTable()">');
			$(".feeClass").hide().addClass("colspan");
			$("#isSpecTr").show();
			$("#isSpecTd").show();
		}else if(changeVal == 1){
			//费用类
			$("#execNumTdInit").append('<input type="text" valid name="execNum" class="base-input-text" style="width:60px;" onblur="computTotalNum(this)" onchange="removeFeeInfoTable()">');
			$(".feeClass").show().addClass("collspan");
			changeFeeType();
			changeFeeSubType();
		}
		curCntType = changeVal;
	}
}

//费用类型下拉框改变触发
var curFeeType = '0';
function changeFeeType(){
	var changeFeeType = $("#feeType").val();
	var feeTypePre = $("#feeTypePre").val();
	if(feeTypePre == 2 && changeFeeType != 2){
		$("#totalNumTable tr:gt(0)").remove();
		addTotalNum();
		$("#execAmt1").html(0);
		$("#cntTaxAmt1").html(0);
	}
	$("#feeTypePre").val(changeFeeType);
	var changeVal = $("#feeType").val();
	$("#feeSubTypeTdLeft,#feeSubTypeTdRight,#feeDateTr,#feeCntTr,#feeAmtTr,#houseTr").hide().removeClass("collspan");
	if(changeVal == 0){
		//金额固定、受益期固定
		$("#feeSubTypeTdLeft,#feeSubTypeTdRight,#feeDateTr,#feeCntTr").show();
		$("#feeDateTr,#feeCntTr").addClass("collspan");
		changeFeeSubType();
		$("#isSpecTr").show();
		$("#isSpecTd").show();
	}else if(changeVal == 1){
		//受益期固定、合同金额不固定
		$("#feeDateTr,#feeAmtTr,#feeCntTr").show().addClass("collspan");
		$("#isSpecTr").show();
		$("#isSpecTd").show();
	}else if(changeVal == 2){
		//其他
		$("#isSpecTr").hide();
		$("#isSpec").val("");
		$("#isSpec").combobox("destroy").val("").combobox();
		$("#isSpecTd").hide();
	}
	curFeeType = changeVal;
}

//费用子类型下拉框改变触发
function changeFeeSubType(){
	var changeVal = $("#feeSubType").val();
	$("#houseTr").hide().removeClass("collspan");
	
	if(changeVal == 0){
		//普通费用类
	}else if(changeVal == 1){
		//房屋租赁类
		$("#houseTr").show().addClass("collspan");
	}
}

//付款条件下拉框改变触发
function changePayTerm(){
	var changeVal = $("#payTerm").val();
	$("#onScheduleTr,#onDateTr,#onTermTr").hide().removeClass("collspan");
	$("#stageTypeDiv").hide();
	if(changeVal == 3){
		//分期付款
		$("#stageTypeDiv").css("display","inline");
		$("#stageType").combobox("destroy").val("0").combobox();
		$("#onScheduleTr").show().addClass("collspan");
	}else{
		//其他付款方式
		$("#stageTypeDiv").hide();
	}
}

//付款条件子下拉框改变触发
function changeStageType(){
	var changeVal = $("#stageType").val();
	$("#onScheduleTr,#onDateTr,#onTermTr").hide().removeClass("collspan");
	if(changeVal == 0){
		//按进度
		$("#onScheduleTr").show().addClass("collspan");
	}else if(changeVal == 1){
		//按日期
		$("#onDateTr").show().addClass("collspan");
	}else if(changeVal == 2){
		//按条件
		$("#onTermTr").show().addClass("collspan");
	}
}

//新增审批数量记录
function addLxsl(){
	$.dialog.open(
			'<%=request.getContextPath()%>/sysmanagement/projectcrinfo/list.do?<%=WebConsts.FUNC_ID_KEY %>=011003',
			{
				width: "80%",
				height: "90%",
				lock: true,
			    fixed: true,
			    title:"审批类别选择",
			    id:"dialogCutPage",
				close: function(){
					var projectcr = art.dialog.data('projectcr'); 
					if(projectcr){
						if(projectcr.abCde!=""&&projectcr.abCde!=null){
							var newProAbcde = projectcr.abCde;
							var DZSPTrList = $("#DZSPTable tr");
							for(var i=0;i<DZSPTrList.length;i++){
								var DZSPTrAbcde = $(DZSPTrList[i]).find("input[name='abcde']").val();
								if(newProAbcde == DZSPTrAbcde){
									for (var i in projectcr) {
										if (projectcr.hasOwnProperty(i) && i !== 'DOM') delete projectcr[i];
									};
									App.notyError("所选择的电子审批已存在！");
									return;
								}
							}
							var appendTr = "<tr>"+
												"<td>"+projectcr.abCde+"<input type='hidden' name='abcde' value='"+projectcr.abCde+"'></td>"+//缩位码
												"<td>"+projectcr.projCrId+"</td>"+//审批编号
												"<td>"+projectcr.createDate+"</td>"+//日期
												"<td>"+projectcr.projCrNum+"</td>"+//审批数量
												//"<td>"+projectcr.exeNum+"</td>"+//已执行数量
												"<td style='padding-right:20px'><input type='text' name='abcdeNum' class='base-input-text' style='width:100%' onblur='getAbcdeNum()'></td>"+//数量
												"<td ><input type='hidden' name='projCrAmt' value='"+projectcr.projCrAmt+"'/>"+projectcr.projCrAmt+"</td>"+//审批金额
												//"<td>"+projectcr.exeAmt+"</td>"+//已执行金额
												//"<td style='padding-right:20px'><input type='text' class='base-input-text'onkeyup='$.clearNoNum(this);' name='abcdeAmt' style='width:100%' onblur='getAbcdeAmt();$.onBlurReplace(this);'></td>"+//金额
												"<td><a><img border='0' alt='删除' width='25px' height='25px' src='<%=request.getContextPath()%>/common/images/delete1.gif' onclick='deleteDZSPTr(this)'/></a></td>"+//操作
										"</tr>";
							$("#DZSPTable").append(appendTr);
							getAbcdeAmt();
					}
				}	
					for (var i in projectcr) {
						if (projectcr.hasOwnProperty(i) && i !== 'DOM') delete projectcr[i];
					};
				}
			}
		 );
}

//供应商弹出页
function queryProvider(obj,flag){
	$.dialog.open(
			'<%=request.getContextPath()%>/sysmanagement/provider/searchProviderAct.do?<%=WebConsts.FUNC_ID_KEY %>=010711&compare='+"common",
			{
				width: "75%",
				height: "90%",
				lock: true,
			    fixed: true,
			    title:"供应商账号选择",
			    id:"dialogCutPage",
				close: function(){
					var proObj = art.dialog.data('proObj'); 
					if(proObj){
						$("#providerType").val(proObj.providerType);
						$("#provActCurr").val(proObj.actCurr);
						$("#provActNo").val(proObj.actNo);
						$("#providerCode").val(proObj.providerCode);
						$("#providerName").val(proObj.providerName);
						$("#providerAddr").val(proObj.providerAddr);
						$("#providerAddrCode").val(proObj.providerAddrCode);
						$("#actName").val(proObj.actName);
						$("#bankInfo").val(proObj.bankInfo);
						$("#bankCode").val(proObj.bankCode);
						$("#bankArea").val(proObj.bankArea);
						$("#bankName").val(proObj.bankName);
						$("#actType").val(proObj.actType);
						$("#payMode").val(proObj.payMode);
						
						$("#bankNameSpan").text(proObj.bankName);
						$("#provActNoSpan").text(proObj.actNo);
						$("#providerAddrSpan").text(proObj.providerAddr);
						$("#actNameSpan").text(proObj.actName);
						$("#bankCodeSpan").text(proObj.bankCode);
						$("#bankInfoSpan").text(proObj.bankInfo);
						
						if('provider'==flag){
							$(obj).parent().attr("colspan","3");
							if(proObj.providerType == 'EMPLOYEE'){
								//员工供应商
								$("#srcPoviderTdLeft").show();
								$("#srcPoviderTdRight").show();
								$("#srcPovider").attr("valid","");
								$(obj).parent().attr("colspan","1");
							}else{
								$("#srcPoviderTdLeft").hide();
								$("#srcPoviderTdRight").hide();
								$("#srcPovider").removeAttr("valid");
								$("#srcPovider").val("");
							}
						}
					}
				}		
			}
		 );
}
//内部供应商弹出页
function querySrcProvider(obj,name){
	$.dialog.open(
			'<%=request.getContextPath()%>/sysmanagement/provider/searchProviderAct.do?<%=WebConsts.FUNC_ID_KEY %>=010711&flag=2&compare=employee',
			{
				width: "75%",
				height: "90%",
				lock: true,
			    fixed: true,
			    title:"供应商账号选择",
			    id:"dialogCutPage",
				close: function(){
					var proObj = art.dialog.data('empProObj'); 
					if(proObj){
						$("#srcPovider").val(proObj.providerName);  //内部供应商名称
					}
				}
			}
		 );
}
//项目弹出页
function projOptionPage(obj){
	var checkId = $(obj).prev().val();
	var signDate = $("#signDate").val();
	if(signDate =="" || signDate ==null){
		App.notyWarning("合同签订日期为空！");
		return false;
	}
	var url="<%=request.getContextPath()%>/projmanagement/projectMgr/projOptionPage.do?<%=WebConsts.FUNC_ID_KEY %>=021004&projId="+checkId+"&signDate="+signDate;
	$.dialog.open(
			url,
			{
				width: "90%",
				height: "90%",
				lock: true,
			    fixed: true,
			    title:"项目选择",
			    id:"dialogCutPage",
				close: function(){
					var proObj = art.dialog.data('projectObj'); 
					if(proObj){
						$(obj).val(proObj.projName);
						$(obj).attr('title',proObj.projName);
						$(obj).prev().val(proObj.projId);
					}
				}
			}
		 );
}

//专项弹出页
function specialPop(obj){
	var url="<%=request.getContextPath()%>/sysmanagement/referencespecial/specialPage.do?<%=WebConsts.FUNC_ID_KEY %>=01120106";
	$.dialog.open(
			url,
			{
				width: "60%",
				height: "80%",
				lock: true,
			    fixed: true,
			    title:"专项选择",
			    id:"dialogCutPage",
				close: function(){
					var proObj = art.dialog.data('specialObj'); 
					if(proObj){
						$(obj).val(proObj.specialName);
						$(obj).attr('title',proObj.specialName);
						$(obj).prev().val(proObj.specialId);
					}
				}
			}
		 );
}

//参考弹出页
function referencePop(obj){
	var url="<%=request.getContextPath()%>/sysmanagement/referencespecial/referencePage.do?<%=WebConsts.FUNC_ID_KEY %>=01120107";
	$.dialog.open(
			url,
			{
				width: "60%",
				height: "80%",
				lock: true,
			    fixed: true,
			    title:"参考选择",
			    id:"dialogCutPage",
				close: function(){
					var proObj = art.dialog.data('referenceObj'); 
					if(proObj){
						$(obj).val(proObj.referenceName);
						$(obj).attr('title',proObj.referenceName);
						$(obj).prev().val(proObj.referenceId);
					}
				}
			}
		 );
}
function taxCodeSum(obj){
	var url="<%=request.getContextPath()%>/contract/initiate/taxCodeList.do?<%=WebConsts.FUNC_ID_KEY %>=0302010109&taxCode="+$(obj).val();
	$.dialog.open(
			url,
			{
				width: "60%",
				height: "80%",
				lock: true,
			    fixed: true,
			    title:"税码选择",
			    id:"dialogCutPage",
				close: function(){
					var proObj = art.dialog.data('taxCodeObj'); 
					if(proObj){
						var taxCode = proObj.taxCode;
						var taxRate = proObj.taxRate;
						var deductFlag = proObj.deductFlag;
						
						if(taxRate > 0 ){
							var st = '<input type="text" onChange="cntTrAmtChg()" name="cntTrAmt" class="base-input-text" style="width:60px"/><input type="hidden" name="deductFlag" class="base-input-text" style="width:60px"/>' ;
							$(obj).parent().parent().find("input[name='cntTrAmt']").parent().html(st);
						}else{
							var st = 0+'<input type="hidden" onChange="cntTrAmtChg()" name="cntTrAmt" class="base-input-text" style="width:60px"/><input type="hidden" name="deductFlag" class="base-input-text" style="width:60px"/>' ;
							$(obj).parent().parent().find("input[name='cntTrAmt']").parent().html(st);
							
						}
						
						$(obj).parent().parent().find("input[name='taxCode']").val(taxCode);
						$(obj).parent().parent().find("input[name='taxRate']").val(taxRate);
						$(obj).parent().parent().find("input[name='deductFlag']").val(deductFlag);
						var execAmt = $(obj).parent().parent().find("input[name='execAmt']").val();
						if(execAmt == null || execAmt == ""){
							execAmt = 0;
						}
						var cntTrAmt = (parseFloat(execAmt) * parseFloat(taxRate)).toFixed(2);
						 
						$(obj).parent().parent().find("input[name='cntTrAmt']").val(cntTrAmt);
						
						showCgAmt();
						
					}
				}
			}
		 );
}
//物料类型添加--跳出页面
function matrTypeOptionPage(obj){
 	var feeDeptObj = $(obj).parent().parent().find("input[name='feeDept']");
	var cntTypeVal = $("#cntType").val();
	var isSpecVal = $("#isSpec").val();
	var isProvinceBuyVal = $("#isProvinceBuy").val();
	var feeTypeVal = $("#feeType").val();
// 	if($.isBlank(isSpecVal)){
// 		App.notyWarning("请先选择是否专项包！");
// 		return false;
// 	}
	if($.isBlank($(feeDeptObj).val())){
		App.notyWarning("请先选择对应的费用承担部门！");
		$(feeDeptObj).focus();
		return false;
	}
	var url="<%=request.getContextPath()%>/sysmanagement/matrtype/matrTypeOption.do?<%=WebConsts.FUNC_ID_KEY %>=010804&matrCode="+$(obj).prev().val();
	url += "&feeDept="+$(feeDeptObj).val()+"&cntType="+cntTypeVal+"&isSpec="+isSpecVal;
	if(curCntType == 0){
		if(isSpecVal == 1){
			if($.isBlank(isProvinceBuyVal)){
				App.notyWarning("请先选择是否省行统购！");
				return false;
			}else{
				url += "&isProvinceBuy="+isProvinceBuyVal;
			}
		}
	}
	if(cntTypeVal==1){
		url += "&feeType="+feeTypeVal;
	}
	$.dialog.open(
			url,
			{
				width: "70%",
				height: "90%",
				lock: true,
			    fixed: true,
			    title:"物料类型选择",
			    id:"dialogCutPage",
				close: function(){
					removeFeeInfoTable();
					var proObj = art.dialog.data('matrObj'); 
					if(proObj){
						$(obj).val(proObj.matrName);
						$(obj).attr('title',proObj.matrName);
						$(obj).prev().val(proObj.matrCode);
						$(obj).prev().prev().val(proObj.cglCode);
						$(obj).parent().next().find("input[name='montCode']").val(proObj.montCode);
						$(obj).parent().next().find("span[name='montName']").text(proObj.montName);
						if(proObj.isNotinfee =='Y' && proObj.matrType =='3'){
							//是不入库费用则单价必须是1
							$(obj).parent().parent().find("td[id='execPriceTd']").html('1<input type="hidden" name="execPrice" value="1"><input type="hidden" name="isBrk" value="1"/>');
							var sl = $(obj).parent().parent().find("input[name='execNum']").val();
							var totalH = '<input type="hidden" value="'+sl+'" name="execAmt"><span name="execAmtText" style="width:80px">'+sl+'</span>';
							$(obj).parent().parent().find("td[id='execAmtTextTd']").html(totalH);
						}else{
							var htmls ='<input type="text" value="1" valid name="execPrice" class="base-input-text" style="width:60px" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);computTotalNum(this);removeFeeInfoTable();" >';
							$(obj).parent().parent().find("td[id='execPriceTd']").html(htmls);
							var sl = $(obj).parent().parent().find("input[name='execNum']").val();
							var totalH = '<input type="hidden" value="'+sl+'" name="execAmt"><span name="execAmtText" style="width:80px">'+sl+'</span>';
							$(obj).parent().parent().find("td[id='execAmtTextTd']").html(totalH);
						}
						showCgAmt();
					}
				}
			}
		 );
} 

//新增采购数量
function addTotalNum(){
	var num = $('#totalNum').val();
	var cntType = $("#cntType").val();
	var execNumTd = '';
	if(cntType == 0){
		//资产类
		execNumTd = '<td id="execNumTd"><input type="text" valid name="execNum" class="base-input-text" style="width:60px;" onblur="computTotalNum(this)" onkeyup="$.clearNoNum(this);" onchange="removeFeeInfoTable()"></td>'; //数量
	}else{
		//费用类
		execNumTd = '<td id="execNumId"><input type="text" valid name="execNum" class="base-input-text" style="width:60px;" onblur="computTotalNum(this)" onkeyup="$.clearNoNum(this);" onchange="removeFeeInfoTable()"></td>'; //数量
	}
	
	
	var appendTr = '<tr>'+
						'<td><input type="hidden" name="projId"/><input type="text" valid name="projName" readonly="readonly" onclick="projOptionPage(this)" title="" class="base-input-text" style="width:100px" ></td>'+//项目
				   		'<td><input name="feeDept" type="hidden"><input name="feeDeptName" type="text" class="base-input-text" style="width:190px"/></td>'+//费用承担部门
				   		'<td><input type="hidden" name="trCglCode" /><input type="hidden" name="matrCode" /><input type="text" name="matrName" title="" valid onclick="checkAprvTransfer(this)" readonly class="base-input-text" style="width:150px"></td>'+//物料类型
				   		'<td><input type="hidden" name="montCode" /><span name="montName" style="width:100px"></span></td>'+//监控指标
				   		'<td><input type="text"  name="deviceModelName" maxlength="20" class="base-input-text" style="width:100px"></td>' +//设备型号
				   		'<td>'+
				   			'<input type="hidden" name="special" value="0"/><input type="text" valid name="specialName" value="默认" readonly="readonly" onclick="specialPop(this)" class="base-input-text" style="width:100px">'+
				   		'</td>' + //专项
				   		'<td>'+
					   		'<input type="hidden" name="reference" value="0"/><input type="text" valid name="referenceName" value="默认" readonly="readonly" onclick="referencePop(this)" class="base-input-text" style="width:100px">'+
				   		'</td>'+//参考
				   		'<td>'+ //税码
				   			'<input type="hidden" name="taxRate"/><input type="text" valid name="taxCode" readonly="readonly" onclick="taxCodeSum(this)" class="base-input-text" style="width:100px"/>'+
				   		'</td>' +
				   		execNumTd+//数量
				   		'<td id="execPriceTd"><input type="text" valid name="execPrice" class="base-input-text" style="width:60px"  onkeyup="$.clearNoNum(this);" onblur="computTotalNum(this);$.onBlurReplace(this);removeFeeInfoTable()" ></td>'+//单价
				   		'<td id="execAmtTextTd"><input type="hidden" name="execAmt"><span name="execAmtText" style="width:80px"></span></td>'+//金额(元)
				   		'<td>'+ //税额
				   			'<input type="text" onChange="cntTrAmtChg()" name="cntTrAmt" class="base-input-text" style="width:60px"/><input type="hidden" name="deductFlag" class="base-input-text" style="width:60px"/>' +
				   		'</td>' +
				   		'<td><input type="text"  name="warranty" class="base-input-text" maxlength="8" style="width:70px"></td>'+//保修期(年)
				   		'<td><input type="text"  name="productor" maxlength="100" class="base-input-tessxt" style="width:70px"></td>'+//制造商
				   		'<td><a><img border="0" alt="删除" width="25px" height="25px" src="<%=request.getContextPath()%>/common/images/delete1.gif" onclick="deleteTotalNum(this)"/></a></td>'+//操作
				   '</tr>';
	$("#totalNumTable").append(appendTr);
	
	feeDeptTag.tagInit();
	var trList = $("#totalNumTable tr:gt(0)");
	var tdProFirst = $(trList[0]).find("td:first");
	var firstProjId = $(tdProFirst).find("input[name='projId']").val();
	var firstProjName = $(tdProFirst).find("input[name='projName']").val();
	if(trList.length > 0){
		//如果第一行是不入库费用 ，那么就应该单价是1
		if($(trList[0]).find("input[name='isBrk']").val() == 1){
			var tdPrice = $(trList[trList.length-1]);
			$(tdPrice).find("td[id='execPriceTd']").html('1<input type="hidden" name="execPrice" value="1">');
		}
		tdProjectLast = $(trList[trList.length-1]).find("td:first");
		$(tdProjectLast).find("input[name='projId']").val(firstProjId);
		$(tdProjectLast).find("input[name='projName']").val(firstProjName);
		$(tdProjectLast).find("input[name='projName']").attr('title',firstProjName);
		
		//物料
	 	var tdTrCglCode = $(trList[0]).find("input[name='trCglCode']").val();
	 	var tdMatrCode = $(trList[0]).find("input[name='matrCode']").val();
	 	var tdMatrName = $(trList[0]).find("input[name='matrName']").val();
	 	var tdMatr = $(trList[trList.length-1]);
	 	$(tdMatr).find("input[name='trCglCode']").val(tdTrCglCode);
	 	$(tdMatr).find("input[name='matrCode']").val(tdMatrCode);
	 	$(tdMatr).find("input[name='matrName']").val(tdMatrName);
	 	//监控指标
	 	var tdMontCode =  $(trList[0]).find("input[name='montCode']").val();
	 	var tdMontName =  $(trList[0]).find("span[name='montName']").html();
	 	$(tdMatr).find("input[name='montCode']").val(tdMontCode);
	 	$(tdMatr).find("span[name='montName']").html(tdMontName);
	 	//设备幸好
	 	var tdDeviceModelName  =  $(trList[0]).find("input[name='deviceModelName']").val();
	 	$(tdMatr).find("input[name='deviceModelName']").val(tdDeviceModelName);
	 	//专项
	 	var tdSpecial =  $(trList[0]).find("input[name='special']").val();
	 	var tdSpecialName =  $(trList[0]).find("input[name='specialName']").val();
	 	$(tdMatr).find("input[name='special']").val(tdSpecial);
	 	$(tdMatr).find("input[name='specialName']").val(tdSpecialName);
	 	//参考
	 	var tdReference =  $(trList[0]).find("input[name='reference']").val();
	 	var tdReferenceName =  $(trList[0]).find("input[name='referenceName']").val();
	 	$(tdMatr).find("input[name='reference']").val(tdReference);
	 	$(tdMatr).find("input[name='referenceName']").val(tdReferenceName);
	 	//税码
	 	var tdTaxRate =  $(trList[0]).find("input[name='taxRate']").val();
	 	var tdTaxCode = $(trList[0]).find("input[name='taxCode']").val();
	 	var tdDeductFlag = $(trList[0]).find("input[name='deductFlag']").val();
	 	$(tdMatr).find("input[name='taxCode']").val(tdTaxCode);
	 	$(tdMatr).find("input[name='taxRate']").val(tdTaxRate);
		if(tdTaxRate > 0 ){
	 		
	 	}else{
	 		var st = 0+'<input type="hidden" onChange="cntTrAmtChg()" name="cntTrAmt" class="base-input-text" style="width:60px"/><input type="hidden" name="deductFlag" class="base-input-text" style="width:60px"/>' ;
	 		$(tdMatr).find("input[name='deductFlag']").parent().html(st);
	 	}
	 	$(tdMatr).find("input[name='deductFlag']").val(tdDeductFlag);
	 	
	}
 	//$("#totalNum").val(Math.floor($("#totalNum").val()) + 1 );
 	$(".selectS").combobox();
	$("#totalNumTable .ui-autocomplete-input").css("width","80px");
	
	$("#totalNumTable").find("input[name='feeDeptName']").css("width","190px");
	//$("#totalNumTable td").attr("style","padding-left: 3px;padding-right: 7px;");
}
function cntTrAmtChg(){
	showCgAmt();
};

//费用部门发生改变时
function changeFeeDept(){
	$("#totalNumTable tr input[name='feeDept']").each(function(){
		if( $(this).val() != $(this).next().attr("title") ){
			$(this).parent().parent().find("input[name='matrCode']").val("");
			$(this).parent().parent().find("input[name='matrName']").val("");
			$(this).parent().parent().find("input[name='cglCode']").val("");
			removeFeeInfoTable();
		}
		$(this).val( $(this).next().attr("title") );
	});
}

//计算采购金额
function computTotalNum(obj){
	var num = $(obj).parent().parent().find("input[name='execNum']");
	var price = $(obj).parent().parent().find("input[name='execPrice']");
	if($.isBlank($(num).val())){
		$(num).val(0);
	}else if($.isBlank($(price).val())){
		$(price).val(0);
	}
	var amt = ($(num).val() * $(price).val()).toFixed(2);
	$(obj).parent().parent().find("input[name='execAmt']").val(amt);
	$(obj).parent().parent().find("span[name='execAmtText']").text(amt);
	var taxRate = $(obj).parent().parent().find("input[name='taxRate']").val();
	if(taxRate =="" || taxRate == null){
		taxRate = 0;
	}
	var cntTrAmt = (parseFloat(taxRate) * parseFloat(amt)).toFixed(2);
	$(obj).parent().parent().find("input[name='cntTrAmt']").val(cntTrAmt);

	showCgAmt();
	computCntTotalNum();
}
//显示物料行统计的不含税金额 和税额
function showCgAmt(){
	var totalCntAmt = 0;
	var totalCntTaxAmt = 0;
	var trList = $("#totalNumTable tr:gt(0)");
	for(var i=0; i<trList.length; i++){
		totalCntAmt += Number($(trList[i]).find("input[name='execAmt']").val());
		totalCntTaxAmt +=  Number($(trList[i]).find("input[name='cntTrAmt']").val());
	}
	$("#execAmt1").html(totalCntAmt.toFixed(2));
	$("#cntTaxAmt1").html(totalCntTaxAmt.toFixed(2));
}
//计算合同采购数量
function computCntTotalNum(){
	var trList = $("#totalNumTable tr:gt(0)");
	var totalNum = 0;
	for(var i=0; i<trList.length; i++){
		totalNum += Number($(trList[i]).find("input[name='execNum']").val());
	}
	$("#totalNum").val(totalNum);
	$("#totalNumSpan").text(totalNum);
}



//改变递增类型
function changeTenancyDzLx(obj){
	var changeVal = $(obj).val();
	var dzdwObj = $(obj).parent().parent().find("select[name='dzdw']");
	if(changeVal == 1){
		$(dzdwObj).combobox("destroy").val("1").combobox();
	}else{
		$(dzdwObj).combobox("destroy").val("2").combobox();
	}
	$("#TenancyDzTable .ui-autocomplete-input").css("width","40px");
}

function changeTenancyDzdw(obj){
	var changeVal = $(obj).val();
	var dzdwObj = $(obj).parent().parent().find("select[name='dzlx']");
	if(changeVal == '1'){
		$(dzdwObj).combobox("destroy").val("1").combobox();
	}else{
		$(dzdwObj).combobox("destroy").val("2").combobox();	
	}
	$("#TenancyDzTable .ui-autocomplete-input").css("width","40px");
}
//修改执行开始日期时，检验房租递增的起始日期
function checkBeginDate(){
	var beginDate = $("#beginDate").val();
	var endDate = $("#endDate").val();
	var tenancyDzTrList = $("#TenancyDzTable tr");
	var prevFromDate = $(tenancyDzTrList[0]).find("input[name='fromDate']").val();
	if(endDate != "" &&beginDate > endDate){
		App.notyError("执行开始日期不能大于执行结束日期!");
		$("#beginDate").val("");
		return false;
	}else if(prevFromDate != "" && beginDate > prevFromDate){
		App.notyError("执行开始日期大于房租开始日期，请修改房租日期!");
		return false;
	}
	return true;
}
//修改执行结束日期时,检验房租递增的结束日期
/* function checkEndDate(){
	var beginDate = $("#beginDate").val();
	var endDate = $("#endDate").val();
	var tenancyDzTrList = $("#TenancyDzTable tr");
	var index = tenancyDzTrList.length;
	var prevToDate = $(tenancyDzTrList[parseInt(index)-1]).find("input[name='toDate']").val();
	if(beginDate != "" && beginDate > endDate){
		App.notyError("执行结束日期不能小于执行开始日期!");
		$("#endDate").val("");
		return false;
	}else if(prevToDate != "" && endDate < prevToDate &&  (prevToDate.substring(0,4)!=endDate.substring(0,4)||prevToDate.substring(5,7)!=endDate.substring(5,7))){
		App.notyError("执行结束日期小于房租结束日期，请修改房租日期! ");
		return false;
	}
	return true;
} */

function addFromDateValue(obj){
	var feeFromDate = $(obj).val();
	$("#TenancyDzTable").find("tr:eq(0)").find("span[name='fromDateShow']").text(feeFromDate.substring(0,7));
	$("#TenancyDzTable").find("tr:eq(0)").find("input[name='fromDate']").val(feeFromDate.substring(0,7));
	
}

//受益期数
function calcfeeEndDate() {
	var feeFromDate = $("#feeStartDate").val();
	var feeCnt = $("#feeCnt").val();
	if(!$.isBlank(feeFromDate)){
		var reg = /^([1-9][0-9]*)$/;
		if (!$.isBlank(feeCnt)) {
			if (reg.test(feeCnt)) {
				var feeEndDate = addMonths(feeFromDate,parseInt(feeCnt));
				var lastDate = addday(feeEndDate.substr(0,7)+"-01",-1);//月末
				$("#feeEndDate").val(lastDate);
				$("#feeEndDateShow").text(feeFromDate.substr(0,7)+" 至 " +lastDate.substr(0,7));
			} else {
				App.notyError('实际受益期数必须为正整数!');
				$("#feeCnt").val("");
				$("#feeEndDate").val("");
				$("#feeEndDateShow").text("");
				return false;
			}
		} else {
			$("#feeEndDate").val("");
			$("#feeEndDateShow").text("");
			return false;
		}
	} 
}

/* function showJe() {
	//展示已用和剩余金额
	var yyje = 0;
	var TenancyDzTrList = $("#TenancyDzTable tr");
	for (var i = 1 ; i <= TenancyDzTrList.length ; i ++ ) {
		var hj = $(TenancyDzTrList[i-1]).find("span[name='hj']").html();
		if (hj == null || hj == "") {
			hj = 0;
		} else {
			hj = parseFloat(hj);
		}
		yyje = yyje + hj;
	}
	var syje = parseFloat($("#htje").text()) - yyje;
	$("#yyje").text(yyje.toFixed(2));
	$("#syje").text(syje.toFixed(2));
} */

//重新整理月份，金额等信息
function modifyYf(obj) {
	var TenancyDzTrList = $(obj).find(".tenancyDz");
	for (var i = 0 ; i < TenancyDzTrList.length; i ++ ) {
		var fromDate = $(TenancyDzTrList[parseInt(i)]).find("input[name='fromDate']").val();
		var toDate = $(TenancyDzTrList[parseInt(i)]).find("input[name='toDate']").val();
		//var dzfz = $(TenancyDzTrList[parseInt(i)]).find("input[name='dzfz']").val() == "" ? 0 : $(TenancyDzTrList[parseInt(i)]).find("input[name='dzfz']").val();
		//var glfy = $(TenancyDzTrList[parseInt(i)]).find("input[name='glfy']").val() == "" ? 0 : $(TenancyDzTrList[parseInt(i)]).find("input[name='glfy']").val();
		var cntMons = cntMonths(fromDate+'-01', toDate);
		$(TenancyDzTrList[parseInt(i)]).find("input[name='dzyf']").val(cntMons);
		//var hj = (parseFloat(dzfz)+parseFloat(glfy))*cntMons;
		//$(TenancyDzTrList[parseInt(i)]).find("span[name='hj']").html(hj.toFixed(2));
	}
	//showJe();
}

//日期加减   参数：日期date  要增加的天数days
function addday(date,days){
	var tempDate =  new Date();
	str = date.split('-'); 
	tempDate.setUTCFullYear(str[0], str[1] - 1, str[2]); 
	tempDate.setUTCHours(0, 0, 0, 0); 
	tempDate.setDate(tempDate.getDate()+days);
	tempDate = $.datepicker.formatDate( "yy-mm-dd",tempDate);
	return tempDate;
}

//月份加减   参数：日期date  要增加月份mon
function addMonths(date,mon){
	var tempDate =  new Date();
	str = date.split('-'); 
	tempDate.setUTCFullYear(str[0], str[1] - 1, 1); 
	tempDate.setUTCHours(0, 0, 0, 0); 
	tempDate.setMonth(tempDate.getMonth()+mon);
	tempDate = $.datepicker.formatDate( "yy-mm-dd",tempDate);
	return tempDate;
}

var scheduleTrCnt = 1; //初始的按进度付款记录期数为1
//按进度新增付款记录
function addOnScheduleTr(){
	scheduleTrCnt++;
	var appendTr = "<tr>"+
						"<td>第<span name='sceduleTrCnt'>"+scheduleTrCnt+"</span>期&nbsp;&nbsp;付款年月&nbsp;"+
						"<input type='text' name='jdDate' readonly  class='base-input-text jdDate' style='width:120px'/>&nbsp;"+
						"支付&nbsp;"+
						"<input type='text' class='base-input-text' onkeyup='$.clearNoNum(this);' onblur='$.onBlurReplace(this);installCount(null,this)' name='jdzf' style='width:60px'>&nbsp;元</td>"+
						"<td><a><img border='0' alt='删除' width='25px' height='25px' src='<%=request.getContextPath()%>/common/images/delete1.gif' onclick='deleteScheduleTr(this)'/></a></td>"+
				"</tr>";
	$("#onScheduleTable").append(appendTr);
	$(".jdDate").datepicker({
		changeMonth: true,
		changeYear: true,
	    dateFormat:"yy-mm-dd",
	});
}

//按日期新增付款记录
function addOnDateTr(){
	var appendTr = "<tr>"+
						"<td>合同签订后<input type='text' name='rqtj' class='base-input-text' style='width:60px'>&nbsp;天&nbsp;&nbsp;支付&nbsp;"+
						"<input type='text' name='rqzf' class='base-input-text' onkeyup='$.clearNoNum(this);' onblur='$.onBlurReplace(this);' style='width:60px'>&nbsp;元</td>"+
						"<td><a><img border='0' alt='删除' width='25px' height='25px' src='<%=request.getContextPath()%>/common/images/delete1.gif' onclick='deleteTr(this)'/></a></td>"+
				"</tr>";
	$("#onDateTable").append(appendTr);
}

//删除一行数据
function deleteTr(obj){
	$(obj).parent().parent().parent().remove();
}

//删除一行进度新增记录
function deleteScheduleTr(obj){
	scheduleTrCnt--;
	$(obj).parent().parent().parent().remove();
	var trList = $("#onScheduleTable tr");
	for(var i=0;i<trList.length;i++){
		$(trList[i]).find("span[name='sceduleTrCnt']").html(i+1);
	}
}

//删除一行电子审批记录
function deleteDZSPTr(obj){
	$(obj).parent().parent().parent().remove();
	getAbcdeNum();
	getAbcdeAmt();
}

//删除一行采购数量记录
function deleteTotalNum(obj){
	$(obj).parent().parent().parent().remove();
	computCntTotalNum();
	$("#tableDiv").empty();
	//计算总金额
	showCgAmt();
} 

//提交验证分期付款条件
function checkFqfktj()
{
	var changeVal = $("#stageType").val();
	if(changeVal == 0){
		//按进度
		var totalAmt = 0;
		var totalJd = 0;
		var trList = $("#onScheduleTable tr");
		if(trList.length < 1){
			App.notyError("请添加进度记录！");
			return false;
		}
		for(var i=0;i<trList.length;i++){
			var nm = 0;
			//不能为空
			$(trList[i]).find("input:text").each(function(){
				if($.isBlank($(this).val())){
					App.notyError("第【"+(i+1)+"】条按进度分期付款的信息不能为空，请填写！");
					$(this).focus();
					nm++;
					return ;
				}
			});
			if(nm!=0){
				return false;
			}
// 			var jdtjObj = $(trList[i]).find("input[name='jdtj']");
			var jdzfObj = $(trList[i]).find("input[name='jdzf']");
			if(!$.checkMoney($(jdzfObj).val())){
				App.notyError("第【"+(i+1)+"】条按进度分期付款的金额输入值不合法，请重新输入！");
				$(jdzfObj).focus();
				return false;
// 			}else if(!$.checkRegExp($(jdtjObj).val(),reg)){
			}
// else if(!$.checkMoney($(jdtjObj).val())){
// 				App.notyError("第【"+(i+1)+"】条按进度分期付款的百分比输入值不合法，请重新输入！");
// 				$(jdtjObj).focus();
// 				return false;
// 			}
			totalAmt=$.numberFormatAdd($.numberFormat(totalAmt,3),$.numberFormat($(jdzfObj).val().replace(/\,/g,''),3),2);
// 			totalJd=$.numberFormatAdd($.numberFormat(totalJd,3),$.numberFormat($(jdtjObj).val().replace(/\,/g,''),3),2);
		}
// 		if(totalJd!=100)
// 		{
// 			App.notyError('分期付款进度之和必须为100%!');
// 			return false;
// 		}
		if(totalAmt*1 != $("#cntAllAmt").val().replace(/\,/g,'')*1)
		{
			App.notyError('分期付款金额之和必须与合同总金额相等!');
			return false;
		}
	}else if(changeVal == 1){
		//按日期
		var totalAmt=0;
		var trList = $("#onDateTable tr");
		if(trList.length < 1){
			App.notyError("请添加进度记录！");
			return false;
		}
		for(var i=0;i<trList.length;i++){
			//不能为空
			$(trList[i]).find("input:text").each(function(){
				if($.isBlank($(this).val())){
					App.notyError("第【"+(i+1)+"】条按日期分期付款的信息不能为空，请填写！");
					$(this).focus();
					return ;
				}
			});
			var rqtjObj = $(trList[i]).find("input[name='rqtj']");
			var rqzfObj = $(trList[i]).find("input[name='rqzf']");
			if(!$.checkMoney($(rqzfObj).val())){
				App.notyError("第【"+(i+1)+"】条按日期分期付款的金额输入值不合法，请重新输入！");
				$(rqzfObj).focus();
				return false;
			}else if(!$.checkRegExp($(rqtjObj).val(),reg)){
				App.notyError("第【"+(i+1)+"】条按日期分期付款的天数输入值不合法，请重新输入！");
				$(rqtjObj).focus();
				return false;
			}
			totalAmt=$.numberFormatAdd($.numberFormat(totalAmt,3),$.numberFormat($(rqzfObj).val().replace(/\,/g,''),3),2);
		}
		if(totalAmt*1!=$("#cntAllAmt").val().replace(/\,/g,'')*1)
		{
			App.notyError('分期付款金额之和必须与合同总金额相等!');
			return false;
		}
	}else if(changeVal == 2){
		//按条件
		var totalAmt=0;
		if(!checkMoney($("#dhzf")) || !checkMoney($("#yszf")) || !checkMoney($("#jszf")))
		{
			return false;
		}
		totalAmt=$.numberFormatAdd($.numberFormat($("#dhzf").val().replace(/\,/g,''),3),$.numberFormat($("#yszf").val().replace(/\,/g,''),3),2);
		totalAmt=$.numberFormatAdd($.numberFormat(totalAmt,3),$.numberFormat($("#jszf").val().replace(/\,/g,''),3),2);
		if(totalAmt.replace(/\,/g,'')*1 != $("#cntAllAmt").val().replace(/\,/g,'')*1)
		{
			App.notyError('分期付款金额之和必须与合同总金额相等!');
			return false;
		}
	}
	return true; 
}

var provinceBuy = "";
//改变是否省行统购
function changeProvinceBuy(){
	var changeVal = $("#isProvinceBuy").val();
	if(changeVal != provinceBuy){
		$("#totalNumTable tr:gt(0)").remove();
		$("#execAmt1").html(0);
		$("#cntTaxAmt1").html(0);
		addTotalNum();
		$("#totalNum").val(0);
		$("#totalNumSpan").text(0);
		$("#tableDiv").empty();
		provinceBuy = changeVal;
	}
}

var boolSpec = "";
//改变是否专项包
function changeIsSpec(){
	var changeVal = $("#isSpec").val();
	if(changeVal != boolSpec){
		$("#totalNumTable tr:gt(0)").remove();
		addTotalNum();
		$("#totalNum").val(0);
		$("#totalNumSpan").text(0);
		$("#tableDiv").empty();
		boolSpec = changeVal;
	}
	$("#isProvinceBuyTr").hide();
	$("#isProvinceBuy").removeAttr("valid");
	if(curCntType == 0){
		if(changeVal == 0){
			//是专项包
		}else{
			$("#isProvinceBuyTr").show();
			$("#isProvinceBuy").attr("valid","valid");
		}
	}
}

function scan(){
	var url="<%=request.getContextPath()%>/common/contract/scan/preadd.do?id=${selectInfo.cntNum}&cntSuccScan="+ isCntSuccScan;
	$.dialog.open(
			url,
			{
				width: "75%",
				height: "90%",
				lock: true,
			    fixed: true,
			    drag:false,
			    title:"中行影像前端控件",
			    id:"dialogCutPage",
				close: function(){					
					var cntSuccScan = art.dialog.data('cntSuccScan');
					if(cntSuccScan != 'undefined'){
						isCntSuccScan = cntSuccScan;
					}
					//alert(isCntSuccScan);
					var feeSubType = $("#feeSubType").val();
					var ptr;
					if (feeSubType == '1') {
						ptr = $("#table4");
					} else {
						ptr = $("#table3");
					}
					if(isCntSuccScan){
					   $(ptr).find("#bSubmit").removeAttr("disabled");
					   $(ptr).find("#bSubmit").removeAttr("aria-disabled");
					   $(ptr).find("#bSubmit").removeClass("ui-button-disabled");
					   $(ptr).find("#bSubmit").removeClass("ui-state-disabled");
					}
					else{
					   $(ptr).find("#bSubmit").attr("disabled", true);
					   $(ptr).find("#bSubmit").attr("aria-disabled",true);
					   $(ptr).find("#bSubmit").addClass("ui-button-disabled");
					   $(ptr).find("#bSubmit").addClass("ui-state-disabled");
					}
				}
			}
		 );
}

//扫描控件下载
function scanUpload(fileId){
	var form = $("#download")[0];
	var url="<%=request.getContextPath()%>/common/contract/scan/scanUpload.do?fileId="+fileId;
	form.action = url;
	form.submit();
}

//查看是否扫描过合同
function hasScaned(){
	var url = "contract/initiate/hasScaned.do?<%=WebConsts.FUNC_ID_KEY%>=0302010104";
	var data = {};
	data["cntNum"] = '${selectInfo.cntNum }';
	var returnValue;
	App.ajaxSubmit(url, {data:data,async : false},  
   		function(data){
			var hasScaned = data.hasScaned;
			returnValue = hasScaned;
		});
	return returnValue;
}

//关联合同号弹出页
function relatedCnt(){
	$.dialog.open(
			'<%=request.getContextPath()%>/contract/initiate/relatedCntPage.do?<%=WebConsts.FUNC_ID_KEY%>=0302010107',
			{
				width: "90%",
				height: "90%",
				lock: true,
			    fixed: true,
			    title:"关联合同号选择",
			    id:"dialogCutPage",
				close: function(){
					var proObj = art.dialog.data('cntObj'); 
					if(proObj){
						$("#cntNumRelated").val(proObj.cntNum);
					}
				}
			}
		 );
}

var isRelatedYN = 0;
function changeIsRelatedCnt(){		
		var changeVal = $("#isRelatedYN").val();
		if(changeVal == 0){
			$(".relateCntTd").show();
			$("#cntNumRelated").attr("valid","valid");
			$("#isRelatedYN").parent().parent().attr("colspan","1");
		}
		else if(changeVal==1){
			$("#isRelatedYN").parent().parent().attr("colspan","3");
			$(".relateCntTd").hide();
			$("#cntNumRelated").removeAttr("valid").val("");
		}
	
}

$(function(){
	$(window).css("overflow-X","hidden");
	$("#scrollTableDiv").css("overflow-Y","hidden");
	$("#scrollTableDiv").css("width",$("#conTable").width());
	$("#scrollTableDivDz").css("overflow-Y","hidden");
	$("#scrollTableDivDz").css("width",$("#conTable").width());
});

//校验项目和物料信息
function checkProjMatr(){
	var trList = $("#totalNumTable tr:gt(0)");
	var totalNum = 0;
	if(trList.length < 1){
		App.notyError("请添加采购项目和物料信息！");
		return false;
	}
	for(var i=0;i<trList.length;i++){
		var execNum = $(trList[i]).find("input[name='execNum']").val(); // 数量
		var execPrice = $(trList[i]).find("input[name='execPrice']").val(); // 单价
		var execAmt = $(trList[i]).find("input[name='execAmt']").val(); // 金额
		var warranty = $(trList[i]).find("input[name='warranty']").val(); // 保修期
		var cntTrAmt =  $(trList[i]).find("input[name='cntTrAmt']").val(); //
		if(!$.checkMoney(execNum) || !(execNum > 0)){
			App.notyError("第"+(i+1)+"条采购项目的数量输入有误，请输入最多含两位小数的18位正浮点数！");
			return false;
		}
		if(!$.checkMoney(execPrice)|| !(execPrice > 0)){
			App.notyError("第"+(i+1)+"条采购项目的单价输入有误，请输入最多含两位小数的18位正浮点数！");
			return false;
		}
		if(!$.checkMoney(cntTrAmt)){
			App.notyError("第"+(i+1)+"条采购项目的税额输入有误，请输入最多含两位小数的18位正浮点数！");
			return false;
		}
		if((warranty !='' &&  warranty != null && !$.checkMoney(warranty)) ){
			App.notyError("第"+(i+1)+"条的保修期输入有误，只能输入数字且最多两位小数！");
			return false;
		}
	}
	return true;
}

var pageOneValid = false;
var pageTwoValid = false;
var pageThreeValid = false;

//第一页校验
function pageOne(){
 	if(!App.valid("#table1")){return false;} 
 	$("#table1 input").css("border-color",""); // 校验通过后去除红色边框警示
	var lxlxVal = $("#lxlx").val();
 	if($("#cntAmt").val()==0){
 		App.notyError("合同金额不能为0，请重新输入大于0的数！");
		$("#cntAmt").focus();
		return false;
 	}
 	
	if(!$.checkMoney($("#cntAmt").val())){
		App.notyError("合同金额格式有误，请输入最多含两位小数的18位正浮点数！");
		$("#cntAmt").focus();
		return false;
	}
	//质保金不能大于100%
 	if($("#zbAmt").val() > 100 || !$.checkMoney($("#zbAmt").val())){
 		App.notyError("质保金不能大于100%且最多包含两位小数！");
 		$("#zbAmt").focus();
 		return false;
 	}
 	if(lxlxVal == 1){
		//电子审批
		if(!checkDZSP()){
			return false;
		}
	}
 	if(trim($("#lxsl").val())!=''&&!$.checkRegExp($("#lxsl").val(),reg)){
 		App.notyError("审批数量格式有误，请输入正整数！");
 		$("#lxsl").focus();
		return false;
 	}
 	if(!$.checkMoney($("#lxje").val())){
		App.notyError("审批金额格式有误，请输入最多含两位小数的18位正浮点数！");
		$("#lxje").focus();
		return false;
	}
	if(Number($("#lxje").val()) < $("#cntAllAmt").val()){
		App.notyError("合同总金额不能大于审批金额！");
		$("#lxje").focus();
		return false;
	}
 	pageOneValid = true;
 	return true;
}

//第一页跳转下一页
function pageOneNext(){
	if(pageOne()){
		$("#table1,#table3,#table4").hide();
		$("#table2").show();
	}
}

//第二页跳转前一页
function pageTwoBefore(){
	$("#table2,#table3,#table4").hide();
	$("#table1").show();
} 

//第二页校验
function pageTwo(){
	//选择合同类型
	if($.isBlank($("#cntType").val())){
		App.notyError("请先选择合同类型！");
		return false;
	}
	var cntType1  = $("#cntType").val();
	if(cntType1 =="0" && $.isBlank($("#isSpec").val())){
		App.notyError("请先选择是否专项包！");
		return false;
	}
	if(curCntType == 0){
		if(boolSpec == "1"){
			//非专项包
			if($.isBlank(provinceBuy)){
				App.notyError("请先选择是否省行统购！");
				return false;
			}
		}
	}
	//选择付款条件
	if($.isBlank($("#payTerm").val())){
		App.notyError("请先选择付款条件！");
		return false;
	}
	
	//校验分期付款
	if($("#payTerm").val() == 3){
		//校验分期后面的条件
		if($.isBlank($("#stageType").val())){
			App.notyError("请先选择分期付款的条件！");
			return false;
		}
		if(!checkFqfktj()){
			return false;
		}
	}
	
	if(curCntType == 1){
		//校验费用类型
		if($.isBlank($("#feeType").val())){
			App.notyError("请先选择费用类型！");
			return false;
		}
		//费用子类
		if($.isBlank($("#feeSubType").val())){
			App.notyError("请先选择费用子类型！");
			return false;
		}
		//费用类
		var feeStartDate = $("#feeStartDate").val();
		//var feeEndDate = $("#feeEndDate").val();
		var actualFeeEndDate = $("#actualFeeEndDate").val();
		var feeTypeVal = $("#feeType").val();
		var feeCnt = $("#feeCnt").val();
		if(feeTypeVal == "0" || feeTypeVal == "1"){
			if($.isBlank($("#isSpec").val())){
				App.notyError("请先选择是否专项包！");
				return false;
			}
			if(!App.valid("#table2")){
				return false;
				} 
		}
		if(feeTypeVal == 0){
			//金额固定、受益期固定
			if($.isBlank(feeStartDate)){
				App.notyError("合同受益起始日期不能为空！");
				return false;
			}
			if($.isBlank(actualFeeEndDate)){
				App.notyError("合同受益结束日期不能为空！");
				return false;
			}
			if(feeStartDate > actualFeeEndDate){
				App.notyError("合同受益起始日期不能大于合同受益结束日期！");
				return false;
			}
			if($.isBlank(feeCnt)){
				App.notyError("合同受益期数不能为空！");
				return false;
			}
			/* if($("#feeSubType").val() == 1){
				//房屋租赁
				if($.isBlank($("#wydz").val())){
					App.notyError("地址说明不能为空！");
					return false;
				}
				
				//金额的校验
				if(!$.checkMoney($("#area").val()) || $("#area").val()==0){
					App.notyError("租赁面积输入有误，请输入最多含两位小数的18位正浮点数！");
					return false;
				}
				//房产性质
				if($.isBlank($("#houseKindId").val())){
					App.notyError("房产(项目)性质不能为空！");
					return false;
				}
				
				//租金递增条件校验
				var trList = $("#TenancyDzTable tr");
				if(trList.length > 0){
					for(var i=0;i<trList.length;i++){
						//不能为空
						$(trList[i]).find("input:text").each(function(){
							if($.isBlank($(this).val())){
								App.notyError("第【"+(i+1)+"】条租金递增条件的信息不能为空，请填写！");
								$(this).focus();
								return ;
							}
						});
						var fromDate = $(trList[i]).find("input[name='fromDate']");
						var toDate = $(trList[i]).find("input[name='toDate']");
						var dzedObj = $(trList[i]).find("input[name='dzfz']");
						var glfyObj = $(trList[i]).find("input[name='glfy']");
						if(fromDate.val() == "" || fromDate.val() == null){
							App.notyError("请选择房租递增开始日期！");
							return false;
						}else if(toDate.val() == "" || toDate.val() == null){
							App.notyError("请选择房租递增结束日期！ ");
							return false;
						}else if(!$.checkMoney($(dzedObj).val())){
							App.notyError("第【"+(i+1)+"】条租金变动金额输入值不合法，请重新输入！");
							$(dzedObj).focus();
							return false;
						}else if(!$.checkMoney($(glfyObj).val())){
							App.notyError("第【"+(i+1)+"】条管理费及其它金额输入值不合法，请重新输入！");
							$(glfyObj).focus();
							return false;
						}
					}
				
			} */
		}else if(feeTypeVal == 1){
			if($.isBlank(feeStartDate)){
				App.notyError("合同受益起始日期不能为空！");
				return false;
			}
			if($.isBlank(actualFeeEndDate)){
				App.notyError("合同受益结束日期不能为空！");
				return false;
			}
			if($.isBlank(feeCnt)){
				App.notyError("合同受益期数不能为空！");
				return false;
			}
			//受益期固定、合同金额不固定
			var feeAmt = $("#feeAmt").val();
			var feePenalty = $("#feePenalty").val();
			var cntAmt = $("#cntAmt").val();
			var cntAllAmt = $("#cntAllAmt").val();
			if((Number(feeAmt)+Number(feePenalty)) != Number(cntAllAmt)){
				App.notyError("合同金额确定部分与约定罚金之和不等于合同总金额！");
				return false;
			}
			$("#feeStartDate,#feeEndDate,#actualFeeEndDate,#feeAmt").attr("valid","");
			if(feeStartDate > actualFeeEndDate){
				App.notyError("合同受益起始日期不能大于合同受益结束日期！");
				return false;
			}
		}else if(feeTypeVal == 2){
			//其他
		}
	}

	
	$("#table2 input").css("border-color",""); // 校验通过后去除红色边框警示
 	pageTwoValid = true;
	return true;
}

//产品性质选择自助银行时，给出自助银行名称选项
function fcSelect(){
	var houseKindId = $("#houseKindId").val();
	if (houseKindId == '1') {
		$("#fc_select").find("td:eq(1)").attr("colspan",1);
		$("#fc_select").append("<td class='tdLeft'>自助银行名称</td><td class='tdRight'><input type='text' name='autoBankName' maxlength='1000' class='base-input-text'></td>");
	} else {
		$("#fc_select").find("td:eq(1)").attr("colspan",3);
		$("#fc_select").find("td:gt(1)").remove();
	}
}

//第二页跳转下一页
function pageTwoNext(){
	if(pageTwo()){
		$("#table1,#table2,#table4").hide();
		$("#table3").show();
		
		if ($("#feeSubType").val() == '1') {
			$("#table3 #fz_select").show();
			$("#table3 #fz_notselect").hide();
		} else {
			$("#table3 #fz_select").hide();
			$("#table3 #fz_notselect").show();
		}
	}
} 

//第三页跳转前一页
function pageThreeBefore(){
	$("#table1,#table3,#table4").hide();
	$("#table2").show();
} 

//第三页校验
function pageThree(){
	if(!App.valid("#table3")){return false;} 
	$("#table3 input").css("border-color",""); // 校验通过后去除红色边框警示
	
	if(!checkProjMatr()){
		return false;
	}
	//采购金额等于合同金额
	if(!checkCntAmt()){
		return false;
	}
	return true;
}

//第三页点击合同新增
function pageThreeSubmit(){
	if(!pageThree()){
		return false;
	}else{
		//校验项目金额是否超出预算
		if(!checkProjAmt()){
			pageThreeBefore();
			return false;
		}
		if(!pageTwoValid){
			pageThreeBefore();
			pageTwo();
		}
		if(!pageOneValid){
			pageTwoBefore();
			pageOne();
		}
		//项目日期校验
		var strs = checkProjDate();
		if(strs.length>0){
			var str = "";
			for(var i=0;i<strs.length;i++){
				str += strs[i]+";";
			}
			App.notyError(strs);
			return false;
		}
		if(!isCntSuccScan){
			alert('完成扫描合同后，才能将合同提交至待复核！');
			return false;
		}
		if(!confirm("你当前所属责任中心为："+$("#dutyCodeName").val()+",是否确认将合同提交至待复核？")){
			return false;
		}
		var form = $("#addForm");
		form.attr('action', '<%=request.getContextPath()%>/contract/initiate/add.do?<%=WebConsts.FUNC_ID_KEY%>=0302010106');
		App.submit(form);
	}
}
function checkAprvTransfer(obj){
		//说明是第一行 就执行校验
		
		var type="";
		var cntTypeVal = $("#cntType").val();
		var isSpec = $("#isSpec").val();
		var isProvinceBuy = $("#isProvinceBuy").val();
		if("0"== isSpec){
			//专项包
			type="11";
		}
		if("0" == isProvinceBuy){
			//省行统购
			type="12";
		}
		if("1" == isProvinceBuy && "0"==cntTypeVal){
			//是非省行统购资产
			type="21";
		}
		if("1" == isSpec && "1"==cntTypeVal){
			//是专项包费用
			type="22";
		}
		var data = {};
		data['type'] = type;
		App.ajaxSubmit("common/montAprvTransfer/aprvTransfer.do", {
			data : data,
			async : false
		}, function(data) {
			var resultMap= data.data;
			var flag = resultMap.flag;
			var msg = resultMap.msg;
			if(flag == false){
				eval(msg);
				return;
			}else{
				matrTypeOptionPage(obj);
			}

		});
}
//第三页点击合同保存
function pageThreeSave(){
	if(!pageThree()){
		return false;
	}else{
		//校验项目金额是否超出预算
		if(!checkProjAmt()){
			pageThreeBefore();
			return false;
		}
		if(!pageTwoValid){
			pageThreeBefore();
			pageTwo();
		}
		if(!pageOneValid){
			pageTwoBefore();
			pageOne();
		}
		if(!confirm("你当前所属责任中心为："+$("#dutyCodeName").val()+",是否确认？")){
			return false;
		}
		var form = $("#addForm");
		form.attr('action', '<%=request.getContextPath()%>/contract/initiate/save.do?<%=WebConsts.FUNC_ID_KEY%>=0302010108');
		App.submit(form);
	}
}

//过滤掉重复物料行
function distinctMatr(){
	var res = [];
	var totalNumTableList = $("#totalNumTable tr:gt(0)");
	for (var i =0;i<totalNumTableList.length;i++) {
		var flag = false;
		var matrCode = $(totalNumTableList[i]).find("input[name='matrCode']").val();
		var matrName = $(totalNumTableList[i]).find("input[name='matrName']").val();
		var execAmt = $(totalNumTableList[i]).find("input[name='execAmt']").val();
		var cntTrAmt = $(totalNumTableList[i]).find("input[name='cntTrAmt']").val();
		if(i==0) {
			res.push([matrCode,matrName,execAmt,cntTrAmt]);
			flag = true;
		}else{
			for(var j=0;j<res.length;j++){
				if(matrCode == res[j][0]) {
					res[j][2]=Number(execAmt)+Number(res[j][2]);
					res[j][3]=Number(cntTrAmt)+Number(res[j][3]);
					flag = true;
					break;
				}
			}
		}
		if(!flag){
			res.push([matrCode,matrName,execAmt,cntTrAmt]);
		}
	} 
	return res;
}

var matrListOut= [];
//第三页跳转下一页
function pageThreeNext(){
	if(pageThree()){
		$("#table1,#table2,#table3").hide();
		$("#table4").show();
	}
	
	$("#showFeeEndDate").text($("#feeEndDate").val().substring(0,7));
	
	//将合同金额、不含税金额、税额显示在第四页表头
	$("#cntAmt4").text($("#cntAllAmt").val());
	$("#execAmt4").text($("#cntAmt").val());
	$("#cntTaxAmt4").text($("#cntTaxAmt").val());

	var feeStartDate = ($("#feeStartDate").val()).substring(0,7);
	var matrList = distinctMatr();
	
	for (var i=0;i<matrList.length;i++) {
		//该物料不含税总金额
		var execAmt = matrList[i][2];
		//该物料总税额
		var cntTrAmt = matrList[i][3];
		//该物料总金额
		var cntAmtMt = Number(execAmt)+Number(cntTrAmt);
		var matrRate = parseFloat(execAmt) / parseFloat(cntAmtMt);
		
		execAmt = Number(execAmt).toFixed(2);
		cntTrAmt = Number(cntTrAmt).toFixed(2);
		cntAmtMt = cntAmtMt.toFixed(2);
		
	
			
		var appendFlag = false;
		for(var j = 0 ;j<matrListOut.length;j++){
			if(matrListOut[j][0]==matrList[i][0]){
				appendFlag = true;
				break;
			}
		}
		if(!appendFlag){
			
			var appendTable ='<table id="TenancyDzTdTable">'+
								'<tr class="collspan-con" style="cursor: pointer;" id="TenancyDzTr'+matrList[i][0]+'">'+
									'<th colspan="8"><input type="hidden" id="matrCode" value="'+matrList[i][0]+'"><input type="hidden" id="matrRate" value="'+matrRate+'">'+
									'<div><div style="display: block; float: center; ">'+matrList[i][1]+'</div>'+
									'</div>'+
								'</th></tr>'+
								'<tr>'+
									'<td>序号<a><img border="0" width="15px" src="<%=request.getContextPath()%>/common/images/add_normal.png" alt="添加" onclick="addTenancyDz(this)"/></a></td>'+
									'<td>开始日期<span class="red">*</span></td>'+
									'<td>结束日期<span class="red">*</span></td>'+
									'<td>总金额：<span id="totalCntAmtMt">'+cntAmtMt+'</span> ， 累计金额：<span id="ljCntAmtMt" style="color:red">0.00</span>&nbsp;<span class="red">*</span></td>'+
									'<td>不含税总金额：<span id="totalExecAmt">'+execAmt+'</span> ， 累计金额：<span id="ljExecAmt" style="color:red">0.00</span>&nbsp;<span class="red">*</span></td>'+
									'<td>总税额： <span id="totalCntTrAmt">'+cntTrAmt+'</span>， 累计金额：<span id="ljCntTrAmt" style="color:red">0.00</span>&nbsp;<span class="red">*</span></td>'+
									'<td>本行合计</td>'+
									'<td>操作</td>'+
								'</tr>'+
								'<tr class="tenancyDz" >'+
									'<td><span name="tdSpan">1</span></td>'+
									'<td><span name="fromDateShow">'+feeStartDate+'</span><input type="hidden" name="matrCodeFz" id="matrCodeFz" value="'+matrList[i][0]+'"><input type="hidden" id="fromDate" name="fromDate" value="'+feeStartDate+'" class="base-input-text fromDate"></td>'+
									'<td id="toDateHidden"><input type="text" name="toDate" class="base-input-text toDate" valid onchange="checkTenancyDzToDate(this);" readonly  style="width:75px"></td>'+
									'<td><input type="text" maxlength="18" name="cntAmtTr" class="base-input-text" valid onblur="countCntAmtTr(this);" onkeyup="$.clearNoNum(this);" style="width:100px">&nbsp;元/月</td>'+
									'<td><input type="text" maxlength="18" name="execAmtTr" class="base-input-text" valid onblur="countleiji(this);" onkeyup="$.clearNoNum(this);" style="width:100px">&nbsp;元/月</td>'+
									'<td><input type="text" maxlength="18" name="taxAmtTr" class="base-input-text" valid onblur="countleiji(this);" onkeyup="$.clearNoNum(this);" style="width:100px">&nbsp;元/月</td>'+
									'<td><span name="heji"></span></td>'+
									'<td><img border="0" alt="删除"  width="30px" height="30px" src="<%=request.getContextPath()%>/common/images/delete1.gif" onclick="deleteTenancyDzTr(this)" style="vertical-align: middle;"/><input type="hidden" size="4" name="dzyf"/></td>'+
								'</tr>'+
							'</table>';
			$("#TenancyDzTd").append(appendTable);
		}else{
			$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='totalCntAmtMt']").text(cntAmtMt);
			$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='totalExecAmt']").text(execAmt);
			$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='totalCntTrAmt']").text(cntTrAmt);
			
			var ljCntAmtMt = $("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljCntAmtMt']").html();
			var ljExecAmt =$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljExecAmt']").html();
			var ljCntTrAmt = $("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljCntTrAmt']").html();
			
			if(Number(cntAmtMt)==Number(ljCntAmtMt)){
				$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljCntAmtMt']").attr("style","color:blue");
			}else{
				$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljCntAmtMt']").attr("style","color:red");
			}
			if(Number(execAmt)==Number(ljExecAmt)){
				$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljExecAmt']").attr("style","color:blue");
			}else{
				$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljExecAmt']").attr("style","color:red");
			}
			if(Number(cntTrAmt)==Number(ljCntTrAmt)){
				$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljCntTrAmt']").attr("style","color:blue");
			}else{
				$("#TenancyDzTr"+matrList[i][0]+"").parent().find("span[id='ljCntTrAmt']").attr("style","color:red");
			}
		}
			
		
		$(".collspan-con").unbind("click");
		
		$(".collspan-con").bind("click",function(){
			$(this).siblings("tr").toggle();
		});
	}
	
	matrListOut = matrList;
	var trList = $(".collspan-con");
	for (var i=0;i<trList.length;i++) {
		var matrCode = $(trList[i]).find("#matrCode").val();
		var flag = true;
		for (var j=0;j<matrList.length;j++) {
			if (matrList[j][0] == matrCode) {
				flag = false;
			}
		}
		if (flag) {
			$(trList[i]).parent().remove();
		}
	}
	
	
	var _parseDate = $.datepicker.parseDate;
	$.datepicker.parseDate = function (format,value,settings){
		if (format == 'yy-mm')
			return _parseDate.apply(this,['yy-mm-dd',value+'-01',settings]);
		else 
			return _parseDate.apply(this,arguments);
	};
	$(".toDate").datepicker({
		changeMonth: true,
		changeYear: true,
	    dateFormat:"yy-mm",
	    defaultDate:feeStartDate
	});
	
} 

//删除一行房租递增记录
function deleteTenancyDzTr(obj){
	var trCurr = $(obj).parents(".tenancyDz");
	var trTable = $(trCurr).parent();
	var index = $(trCurr).find("span[name='tdSpan']").html();
	var trCurrFromDate;
	if (index == 1) {
		trCurrFromDate = ($("#feeStartDate").val()).substring(0,7);
	} else {
		trCurrFromDate = $(trCurr).find("span[name='fromDateShow']").html();
	} 
	
	$(trCurr).remove();//删除行
	
	var trList = $(trTable).find(".tenancyDz");
	
	//删除行后，将上一行结束日期与下一行开始日期相连
	$(trList[index-1]).find("span[name='fromDateShow']").html(trCurrFromDate);
	$(trList[index-1]).find("input[name='fromDate']").val(trCurrFromDate);
	
	if($.isBlank($(trList[index-1]).find("input[name='toDate']").val())){
		
		$(trList[index-1]).find("input[name='toDate']").remove();
		$(trList[index-1]).find("td[id='toDateHidden']").append('<input type="text" name="toDate" class="base-input-text toDate" valid onchange="checkTenancyDzToDate(this);" readonly  style="width:75px">');
		
		$(trList[index-1]).find("input[name='toDate']").datepicker({
			changeMonth: true,
			changeYear: true,
		    dateFormat:"yy-mm",
		    defaultDate:trCurrFromDate
		});
	}
	
	
	var trs = $(trList[index-1]).find("span[name='fromDateShow']").parents(".tenancyDz");
	
	var fromDate = $(trs).find("input[name='fromDate']").val();
	var toDate = $(trs).find("input[name='toDate']").val();
	var cntMons = cntMonths(fromDate+"-01", toDate+"-01");
	$(trs).find("input[name='dzyf']").val(cntMons);
	
	var ljCntAmtMt = 0;
	var ljExecAmt = 0;
	var ljCntTrAmt = 0;
	
	for(var i=0;i<trList.length;i++){
		$(trList[i]).find("span[name='tdSpan']").text(i+1);
		
		var cntAmtTr = $(trList[i]).find("input[name='cntAmtTr']").val();
		var execAmtTr = $(trList[i]).find("input[name='execAmtTr']").val();
		var taxAmtTr = $(trList[i]).find("input[name='taxAmtTr']").val();
		var monthTrVal = $(trList[i]).find("input[name='dzyf']").val();
		var endDate = $(trList[i]).find("input[name='toDate']").val();
		
		if($.isBlank(endDate)){
			monthTrVal = 0;
		}
		if($.isBlank(cntAmtTr)){
			cntAmtTr = 0;
		}
		if($.isBlank(execAmtTr)){
			execAmtTr = 0;
		}
		if($.isBlank(taxAmtTr)){
			taxAmtTr = 0;
		}
		ljCntAmtMt += parseFloat(cntAmtTr)*Number(monthTrVal);
		ljExecAmt += parseFloat(execAmtTr)*Number(monthTrVal);
		ljCntTrAmt += parseFloat(taxAmtTr)*Number(monthTrVal);
		
		//本行合计
		var benhangheji = (parseFloat(cntAmtTr) * parseFloat(monthTrVal)).toFixed(2);
		$(trList[i]).find("span[name='heji']").html(benhangheji);
	}
	
	changeSpanStyle(trTable,ljCntAmtMt,ljExecAmt,ljCntTrAmt);
}

function changeSpanStyle(trTable,ljCntAmtMt,ljExecAmt,ljCntTrAmt){
	
	ljCntAmtMt = ljCntAmtMt.toFixed(2);
	ljExecAmt = ljExecAmt.toFixed(2);
	ljCntTrAmt = ljCntTrAmt.toFixed(2);
	
	$(trTable).find("span[id='ljCntAmtMt']").html(ljCntAmtMt);
	$(trTable).find("span[id='ljExecAmt']").html(ljExecAmt);
	$(trTable).find("span[id='ljCntTrAmt']").html(ljCntTrAmt);
	
	var totalCntAmtMt = $(trTable).find("span[id='totalCntAmtMt']").html();
	var totalExecAmt = $(trTable).find("span[id='totalExecAmt']").html();
	var totalCntTrAmt = $(trTable).find("span[id='totalCntTrAmt']").html();
	
	if(Number(totalCntAmtMt)==Number(ljCntAmtMt)){
		$(trTable).find("span[id='ljCntAmtMt']").attr("style","color:blue");
	}else{
		$(trTable).find("span[id='ljCntAmtMt']").attr("style","color:red");
	}
	if(Number(totalExecAmt)==Number(ljExecAmt)){
		$(trTable).find("span[id='ljExecAmt']").attr("style","color:blue");
	}else{
		$(trTable).find("span[id='ljExecAmt']").attr("style","color:red");
	}
	if(Number(totalCntTrAmt)==Number(ljCntTrAmt)){
		$(trTable).find("span[id='ljCntTrAmt']").attr("style","color:blue");
	}else{
		$(trTable).find("span[id='ljCntTrAmt']").attr("style","color:red");
	}
}

//自动计算该物料不含税金额以及税额
function countCntAmtTr(obj){
	var cntAmtTr = $(obj).val();
	if($.isBlank(cntAmtTr)){
		cntAmtTr=0;
	}
		
	//物料不含税金额占比
	var matrRate = $(obj).parent().parent().parent().find("input[id='matrRate']").val();
	//不含税金额
	var execAmt = (Number(cntAmtTr) * Number(matrRate)).toFixed(2);
	$(obj).parent().parent().find("input[name='execAmtTr']").val(execAmt);

	//税额
	var cntTrAmt = (Number(cntAmtTr) - Number(execAmt)).toFixed(2);
	$(obj).parent().parent().find("input[name='taxAmtTr']").val(cntTrAmt);
	
	countleiji(obj);
	
}

//物料行统计的累计金额
function countleiji(obj){
	
	var trCurr = $(obj).parents(".tenancyDz");
	var tableObj = $(trCurr).parent();
	var ljCntAmtMt = 0;
	var ljExecAmt = 0;
	var ljCntTrAmt = 0;
	
	var trList = $(tableObj).find(".tenancyDz");
	for(var i=0;i<trList.length;i++){
		
		var cntAmtTr = $(trList[i]).find("input[name='cntAmtTr']").val();
		var execAmtTr = $(trList[i]).find("input[name='execAmtTr']").val();
		var taxAmtTr = $(trList[i]).find("input[name='taxAmtTr']").val();
		var monthTrVal = $(trList[i]).find("input[name='dzyf']").val();
		var endDate = $(trList[i]).find("input[name='toDate']").val();
		if($.isBlank(endDate)){
			monthTrVal = 0;
		}
		if($.isBlank(cntAmtTr)){
			cntAmtTr = 0;
		}
		if($.isBlank(execAmtTr)){
			execAmtTr = 0;
		}
		if($.isBlank(taxAmtTr)){
			taxAmtTr = 0;
		}
		ljCntAmtMt += Number(cntAmtTr)*Number(monthTrVal);
		ljExecAmt += Number(execAmtTr)*Number(monthTrVal);
		ljCntTrAmt += Number(taxAmtTr)*Number(monthTrVal);
		
		//本行合计
		var benhangheji = (parseFloat(cntAmtTr) * parseFloat(monthTrVal)).toFixed(2);
		$(trList[i]).find("span[name='heji']").html(benhangheji);
	}
	
	changeSpanStyle(tableObj,ljCntAmtMt,ljExecAmt,ljCntTrAmt);
	
	checkleiji(obj);
}

//校验是否超过累计金额
function checkleiji(obj){
	var flag = true;
	var trCurr = $(obj).parents(".tenancyDz");
	var trTable = $(trCurr).parent();
	
	var zongjine = $(trTable).find("span[id='totalCntAmtMt']").html();
	var ljCntAmtMt = $(trTable).find("span[id='ljCntAmtMt']").html();
	var shengyu = Number(zongjine) - Number(ljCntAmtMt);
	
	if(0>Number(shengyu)){
		App.notyError("该物料的累计金额超出总金额！");
		$(trCurr).find("input[name='cntAmtTr']").val('');
		$(trCurr).find("input[name='execAmtTr']").val('');
		$(trCurr).find("input[name='taxAmtTr']").val('');
		countleijiTemp(obj);
		flag = false;
	}
	return flag;
}

function countleijiTemp(obj){
	
	var trCurr = $(obj).parents(".tenancyDz");
	var tableObj = $(trCurr).parent();
	var ljCntAmtMt = 0;
	var ljExecAmt = 0;
	var ljCntTrAmt = 0;
	
	var trList = $(tableObj).find(".tenancyDz");
	for(var i=0;i<trList.length;i++){
		
		var cntAmtTr = $(trList[i]).find("input[name='cntAmtTr']").val();
		var execAmtTr = $(trList[i]).find("input[name='execAmtTr']").val();
		var taxAmtTr = $(trList[i]).find("input[name='taxAmtTr']").val();
		var monthTrVal = $(trList[i]).find("input[name='dzyf']").val();
		var endDate = $(trList[i]).find("input[name='toDate']").val();
		if($.isBlank(endDate)){
			monthTrVal = 0;
		}
		if($.isBlank(cntAmtTr)){
			cntAmtTr = 0;
		}
		if($.isBlank(execAmtTr)){
			execAmtTr = 0;
		}
		if($.isBlank(taxAmtTr)){
			taxAmtTr = 0;
		}
		ljCntAmtMt += Number(cntAmtTr)*Number(monthTrVal);
		ljExecAmt += Number(execAmtTr)*Number(monthTrVal);
		ljCntTrAmt += Number(taxAmtTr)*Number(monthTrVal);
		
		//本行合计
		var benhangheji = (parseFloat(cntAmtTr) * parseFloat(monthTrVal)).toFixed(2);
		$(trList[i]).find("span[name='heji']").html(benhangheji);
	}
	
	changeSpanStyle(tableObj,ljCntAmtMt,ljExecAmt,ljCntTrAmt);
}

//校验租金递增结束日期
function checkTenancyDzToDate(obj){
	var TenancyDzTr = $(obj).parents(".tenancyDz");
	var feeStartDate = ($("#feeStartDate").val()).substring(0,7);
	var feeEndDate = ($("#feeEndDate").val()).substring(0,7);
	var TenancyDzTrListTr = $(TenancyDzTr).parent().find(".tenancyDz");
	var index = $(TenancyDzTr).find("span[name='tdSpan']").html();
	//alert(index);
	
	var fromDatei = $(TenancyDzTrListTr[index-1]).find("input[name='fromDate']").val();
	//alert(fromDatei);
	var toDatei = ($(obj).val()).substring(0,7);
	if("" == feeStartDate){
		App.notyError("请选择合同受益起始日期!");
		$(obj).val("");
		return false;
	}
	if("" == feeEndDate){
		App.notyError('请选择合同受益终止日期!');
		$(obj).val("");
		return false;
	}
	if(fromDatei == ""){
		App.notyError('请先选择递增开始日期!');
		$(obj).val("");
		return false;
	}
	//判断第二条及以后递增条件输入规则月初规则(所有开始日期为01),月中规则(开始日期相同,例如都为15号)
	if(index>1){
		$(TenancyDzTrListTr).find("input[name='toDate']").each(function(i){
			if(i<$(TenancyDzTrListTr).find("input[name='fromDate']").length-1){
				var f = $(TenancyDzTrListTr).find("input[name='fromDate']")[i].value;
				var t = $(TenancyDzTrListTr).find("input[name='toDate']")[i].value;
				if(f==""||f==null||t==""||t==null){
					$(obj).val("");
					App.notyError('前面的日期条件不能为空,请先填好前面的值!');
					return false;
				}
			}
		});
		var i = index-1;
		var preFromDate = $(TenancyDzTrListTr[i-1]).find("input[name='fromDate']").val();
		var preToDate = $(TenancyDzTrListTr[i-1]).find("input[name='toDate']").val();
		if(preToDate==''){
			App.notyError('请先选择上一条递增条件结束日期!');
			$(obj).val("");
			return false;
		}else if(preFromDate == ''){
			App.notyError('请先选择上一条递增条件开始日期!');
			$(obj).val("");
			return false;
		}
	}
	
	if(""!=toDatei){
		if(fromDatei>toDatei){
			App.notyError('递增结束日期必须大于开始日期!');
			$(obj).val("");
			return false;
		}
		if(toDatei>feeEndDate){
			App.notyError('递增结束日期不能大于合同受益终止日期所在月份,请重新选择!');
			$(obj).val("");
			return false;
		}
		
	}
	
	if (index < TenancyDzTrListTr.length) {
		if(toDatei>=feeEndDate){
			App.notyError('中间行递增结束日期只能小于合同受益终止日期所在月份,请重新选择!');
			$(obj).val("");
			return false;
		} else {
			var currToDate = $(TenancyDzTrListTr[parseInt(index)-1]).find("input[name='toDate']").val();
			var tempDate = addMonths(currToDate+"-01",1,0);
			tempDate = tempDate.substring(0,7);
			$(TenancyDzTrListTr[parseInt(index)]).find("span[name='fromDateShow']").html(tempDate);
			$(TenancyDzTrListTr[parseInt(index)]).find("input[name='fromDate']").val(tempDate);
			
			//if($.isBlank($(TenancyDzTrListTr[parseInt(index)]).find("input[name='toDate']").val())){
				
			$(TenancyDzTrListTr[parseInt(index)]).find("input[name='toDate']").remove();
			$(TenancyDzTrListTr[parseInt(index)]).find("td[id='toDateHidden']").append('<input type="text" name="toDate" class="base-input-text toDate" valid onchange="checkTenancyDzToDate(this);" readonly  style="width:75px">');
			
			$(TenancyDzTrListTr[parseInt(index)]).find("input[name='toDate']").datepicker({
				changeMonth: true,
				changeYear: true,
			    dateFormat:"yy-mm",
			    defaultDate:tempDate
			});
			//}
		}
	} 
	
	//只要结束日期有变动，重新计算金额和月份
	modifyYf($(TenancyDzTr).parent());//将table传过去
	
	countleiji(obj);
	return true;
}

var TenancyDzCnt = 1;
//新增房租递增记录
function addTenancyDz(obj){
	var feeStartDate = ($("#feeStartDate").val()).substring(0,7);
	var feeEndDate = ($("#feeEndDate").val()).substring(0,7);
	var tenancyDzTrList = $(obj).parent().parent().parent().nextAll("tr");
	var index = tenancyDzTrList.length;
	var prevFromDate = $(tenancyDzTrList[parseInt(index)-1]).find("input[name='fromDate']").val();
	var prevToDate = $(tenancyDzTrList[parseInt(index)-1]).find("input[name='toDate']").val();
	var tempDate;
	if(feeStartDate==null||feeStartDate==''){
		App.notyError("请先选择合同受益起始日期!");
		return false;
	}
	if(feeEndDate==null||feeEndDate==''){
		App.notyError("请先选择合同受益终止日期!");
		return false;
	}
	if(index != 0){
	   if(prevFromDate == "" || prevToDate == "" ){
		   App.notyError("请先选择结束日期!");
		   return false;
	   }
	   if(prevToDate>=feeEndDate){
		  App.notyError("已到合同受益终止日期所在月份上限,若需添加请修改合同受益终止日期!");
		  return false;
	   }
	}
	
	//将上一行结束日期加一个月后默认赋值给新加行开始日期
	if (index == 0) {
		tempDate = feeStartDate;
	} else {
		tempDate= addMonths(prevToDate+"-01",1,0);
	}
	tempDate = tempDate.substring(0,7);
	
	var trTable = $(obj).parents("#TenancyDzTdTable");
	var matrCodeFz = $(trTable).find("input[id='matrCode']").val();
	
	TenancyDzCnt= parseInt(index) + 1;
	var appendTr ='<tr class="tenancyDz">'+
						'<td><span name="tdSpan">'+TenancyDzCnt+'</span></td>'+
						'<td><span name="fromDateShow">'+tempDate+'</span><input type="hidden" name="matrCodeFz" id="matrCodeFz" value="'+matrCodeFz+'"><input type="hidden" id="fromDate" name="fromDate" value="'+tempDate.substring(0,7)+'" class="base-input-text fromDate"></td>'+
						'<td id="toDateHidden"><input type="text" name="toDate" class="base-input-text toDate" valid onchange="checkTenancyDzToDate(this);" readonly  style="width:75px"></td>'+
						'<td><input type="text" maxlength="18" name="cntAmtTr" class="base-input-text" valid onblur="countCntAmtTr(this);" onkeyup="$.clearNoNum(this);" style="width:100px">&nbsp;元/月</td>'+
						'<td><input type="text" maxlength="18" name="execAmtTr" class="base-input-text" valid onblur="countleiji(this)" onkeyup="$.clearNoNum(this);" style="width:100px">&nbsp;元/月</td>'+
						'<td><input type="text" maxlength="18" name="taxAmtTr" class="base-input-text" valid onblur="countleiji(this)" onkeyup="$.clearNoNum(this);" style="width:100px">&nbsp;元/月</td>'+
						'<td><span name="heji"></span></td>'+
						'<td><a><img border="0" alt="删除"  width="30px" height="30px" src="<%=request.getContextPath()%>/common/images/delete1.gif" onclick="deleteTenancyDzTr(this)" style="vertical-align: middle;"/></a><input type="hidden" size="4" name="dzyf"/></td>'+
					'</tr>';
			$(obj).parent().parent().parent().parent().append(appendTr);
	
	$(".selectD").combobox();
	$("#TenancyDzTable .ui-autocomplete-input").css("width","35px");
	var _parseDate = $.datepicker.parseDate;
	$.datepicker.parseDate = function (format,value,settings){
		if (format == 'yy-mm')
			return _parseDate.apply(this,['yy-mm-dd',value+'-01',settings]);
		else 
			return _parseDate.apply(this,arguments);
	};
	$(".toDate").datepicker({
		changeMonth: true,
		changeYear: true,
	    dateFormat:"yy-mm",
	    defaultDate:tempDate
	});
}

//第四页跳转前一页
function pageFourBefore(){
	
	//$("table[id='TenancyDzTdTable']").remove();
	$("#table1,#table2,#table4").hide();
	$("#table3").show();
} 




//第四页校验
function pageFourSave(){
	if(!pageFour()){
		return false;
	}else{
		//校验项目金额是否超出预算
		if(!checkProjAmt()){
			pageThreeBefore();
			return false;
		}
		if(!pageTwoValid){
			pageThreeBefore();
			pageTwo();
		}
		if(!pageOneValid){
			pageTwoBefore();
			pageOne();
		}
		if(!confirm("你当前所属责任中心为："+$("#dutyCodeName").val()+",是否确认？")){
			return false;
		}
		var form = $("#addForm");
		form.attr('action', '<%=request.getContextPath()%>/contract/initiate/save.do?<%=WebConsts.FUNC_ID_KEY%>=0302010108');
		App.submit(form);
	}
	
	return true;
}
function pageFourSubmit(){
	if(!pageFour()){
		return false;
	}else{
		//校验项目金额是否超出预算
		if(!checkProjAmt()){
			pageThreeBefore();
			return false;
		}
		if(!pageTwoValid){
			pageThreeBefore();
			pageTwo();
		}
		if(!pageOneValid){
			pageTwoBefore();
			pageOne();
		}
		//项目日期校验
		var strs = checkProjDate();
		if(strs.length>0){
			var str = "";
			for(var i=0;i<strs.length;i++){
				str += strs[i]+";";
			}
			App.notyError(strs);
			return false;
		}
		if(!isCntSuccScan){
			alert('完成扫描合同后，才能将合同提交至待复核！');
			return false;
		}
		if(!confirm("你当前所属责任中心为："+$("#dutyCodeName").val()+",是否确认将合同提交至待复核？")){
			return false;
		}
		var form = $("#addForm");
		form.attr('action', '<%=request.getContextPath()%>/contract/initiate/add.do?<%=WebConsts.FUNC_ID_KEY%>=0302010106');
		App.submit(form);
	}
}
//第四页校验
function pageFour(){
	
	if($.trim($('#wydz').val())==''||$.trim($('#wydz').val())==null)
	{
		App.notyError("地址不能为空");
		return false;
	}
	if($.trim($('#area').val())==''||$.trim($('#area').val())==null)
	{
		App.notyError("租赁面积不能为空");
		return false;
	}
	if(!$.checkMoney($("#area").val()) || $("#area").val()==0){
		App.notyError("租赁面积输入有误，请输入最多含两位小数的18位正浮点数！");
		return false;
	}
	if($.trim($('#houseKindId').val())==''||$.trim($('#houseKindId').val())==null)
	{
		App.notyError("请选择租赁类型");
		return false;
	}
	
	if(!App.valid("#table4")){return false;} 
	$("#table4 input").css("border-color",""); // 校验通过后去除红色边框警示
	
	var feeEndDate = ($("#feeEndDate").val()).substring(0,7);
	
	var tableList = $("#TenancyDzTd").find("table[id='TenancyDzTdTable']");
	
	for(var i = 0;i<tableList.length;i++){
		var trList = $(tableList[i]).find("tr[class='tenancyDz']");
		for(var j = 0;j<trList.length;j++){
			var cntAmtTr = $(trList[j]).find("input[name='cntAmtTr']").val();
			var execAmtTr = $(trList[j]).find("input[name='execAmtTr']").val();
			var taxAmtTr = $(trList[j]).find("input[name='taxAmtTr']").val();
			
			if(!$.checkMoney(cntAmtTr) || cntAmtTr==0){
				App.notyError("第"+(i+1)+"条物料序号为"+(j+1)+"的合同总金额输入有误，请输入最多含两位小数的18位正浮点数！");
				return false;
			}
			 if(!$.checkMoney(execAmtTr) || execAmtTr==0){
				App.notyError("第"+(i+1)+"条物料序号为"+(j+1)+"的不含税金额输入有误，请输入最多含两位小数的18位正浮点数！");
				return false;
			}
			if(!$.checkMoney(taxAmtTr) || taxAmtTr==0){
				App.notyError("第"+(i+1)+"条物料序号为"+(j+1)+"的税额输入有误，请输入最多含两位小数的18位正浮点数！");
				return false;
			} 
			
			if(j==trList.length-1){
				var lastToDate = $(trList[j]).find("input[name='toDate']").val();
				if (feeEndDate.substring(0,7) != lastToDate) {
					App.notyError("第"+(i+1)+"条物料的租金递增条件最后一行结束日期有误，必须等于合同受益终止年月！");
					return false;
				}
				
			}
		}
	}
	
	
	//校验各个物料的累计金额是否等于总金额
	if(!checkMatrLeiji()){
		return false;
	}
	
	return true;
}

function checkMatrLeiji(){
	
	var tableList = $("#TenancyDzTd").find("table[id='TenancyDzTdTable']");
	
	for(var i = 0;i<tableList.length;i++){
		var count1 = $(tableList[i]).find("span[id='ljCntAmtMt']").text();
		var count2 = $(tableList[i]).find("span[id='totalCntAmtMt']").html();
		if(Number(count1) != Number(count2)){
			App.notyError("第"+(i+1)+"条物料的总金额与总金额的累计金额不等！");
			return false;
		}
		var count3 = $(tableList[i]).find("span[id='ljExecAmt']").html();
		var count4 = $(tableList[i]).find("span[id='totalExecAmt']").html();
		if(Number(count3) != Number(count4)){
			App.notyError("第"+(i+1)+"条物料的不含税总金额与不含税总金额的累计金额不等！");
			return false;
		}
		var count5 = $(tableList[i]).find("span[id='ljCntTrAmt']").html();
		var count6 = $(tableList[i]).find("span[id='totalCntTrAmt']").html();
		if(Number(count5) != Number(count6)){
			App.notyError("第"+(i+1)+"条物料的总税额与总税额的累计金额不等！");
			return false;
		}
		
		var trList = $(tableList[i]).find("tr[class='tenancyDz']");
		
		for(var j = 0;j<trList.length;j++){
			var count7 = $(trList[j]).find("input[name='cntAmtTr']").val();
			var count8 = $(trList[j]).find("input[name='execAmtTr']").val();
			var count9 = $(trList[j]).find("input[name='taxAmtTr']").val();
			var count10 = (Number(count8)+Number(count9)).toFixed(2);
			if(Number(count7) != Number(count10)){
				App.notyError("第"+(i+1)+"条物料序号为"+(j+1)+"的不含税金额与税额之和不等于总金额！");
				return false;
			}
		}
	}
	
	return true;
}


//计算递增后每月费用合计
function countDzhhj(rent,dzlx,dzed,dzdw)
{
	//changeTwoDecimal  parseFloat
	if("1"==dzdw)//单位：元
	{
		if ("1"==(dzlx))//固定
		{
			return dzed;
		}
		else if ("2"==(dzlx))//上浮
		{
			return parseFloat(rent)+parseFloat(dzed/100);
		}
		else if ("3"==(dzlx))//下调
		{
			return parseFloat(rent)-parseFloat(dzed/100);
		}
	}
	else if("2"==dzdw)//单位：百分比
	{
		if ("1"==(dzlx))//固定
		{
			return dzed;
		}
		else if ("2"==(dzlx))//上浮
		{
			return parseFloat(rent)*(1+parseFloat(dzed/100));
		}
		else if ("3"==(dzlx))//下调
		{
			return parseFloat(rent)*(1-parseFloat(dzed/100));
		}
	}
	
}

//计算月份差
function cntMonths(statDate,enDate){
	//两个日期
	var date1 = statDate;
	var date2 = enDate;
	// 拆分年月日
	date1 = date1.split('-');
	// 得到月数
	date1 = parseInt(date1[0]) * 12 + parseInt(date1[1],10);
	// 拆分年月日
	date2 = date2.split('-');
	// 得到月数
	date2 = parseInt(date2[0]) * 12 + parseInt(date2[1],10);
	var m = Math.abs(date1 - date2)+1;
	return m;
}

//分期付款中的比例与金额计算
function installCount(obj1,obj2){
// 	var cntAmt = $("#cntAllAmt").val();//合同金额 
// 	if(!$.isNull(obj1)){//通过比例来计算金额
// 		var temp1 = 0;
// 		var temp2 = 0;
// 		$(obj1).parent().find("input[name='jdzf']").val("");
// 		//拿到所有的金额来判断
// 		$(obj1).parent().parent().parent().find("input[name='jdzf']").each(function(){
// 			if(!$.isBlank($(this).val())){
// 				temp1 += parseFloat($(this).val());
// 			}
// 		});
// 		//比例
// 		$(obj1).parent().parent().parent().find("input[name='jdtj']").each(function(){
// 			if(!$.isBlank($(this).val())){
// 				temp2 += parseFloat($(this).val());
// 			}
// 		});
// 		if(parseFloat(temp2)==parseFloat(100)){//比例相等
// 			$(obj1).parent().find("input[name='jdzf']").val(parseFloat(cntAmt-temp1).toFixed(2));
// 		}else{
// 			$(obj1).parent().find("input[name='jdzf']").val(parseFloat($(obj1).val()*cntAmt/100).toFixed(2));
// 		}
// 	}
// 	if(!$.isNull(obj2)){//通过金额 来计算比例
// 		var temp1 = 0;
// 		var temp2 = 0;
// 		$(obj2).parent().find("input[name='jdtj']").val("");
// 		//拿到所有的金额来判断
// // 		alert($(obj2).parent().parent().parent().find("input[name='jdzf']").length);
// 		$(obj2).parent().parent().parent().find("input[name='jdzf']").each(function(){
// 			if(!$.isBlank($(this).val())){
// 				temp1 += parseFloat($(this).val());
// 			}
// 		});
// 		//比例
// 		$(obj2).parent().parent().parent().find("input[name='jdtj']").each(function(){
// 			if(!$.isBlank($(this).val())){
// 				temp2 += parseFloat($(this).val());
// 			}
// 		});
// 		if(parseFloat(temp1)==parseFloat(cntAmt)){//如果相等了。则拿总比例-当前比例和
// 			$(obj2).parent().find("input[name='jdtj']").val(parseFloat(100-temp2).toFixed(2));
// 		}else{
// 			$(obj2).parent().find("input[name='jdtj']").val(parseFloat($(obj2).val()*100/cntAmt).toFixed(2));
// 		}
// 	}
}
function cntAllAmtSum(){
	var cntAmt = $("#cntAmt").val();
	if(cntAmt==null || cntAmt ==""){
		cntAmt = 0;
	}
	var cntTaxAmt = $("#cntTaxAmt").val();
	if(cntTaxAmt == null || cntTaxAmt ==""){
		cntTaxAmt = 0;
	}
	var cntAllAmt = (parseFloat(cntAmt)+parseFloat(cntTaxAmt)).toFixed(2);
	$("#cntAllAmt").val(cntAllAmt);
	$("#cntAllAmtSpan").html(cntAllAmt);
	
	$("#execAmt0").html(parseFloat(cntAmt));
	$("#cntTaxAmt0").html(parseFloat(cntTaxAmt));
	
	$("#htje,#syje").text(cntAllAmt);//将合同金额赋值到第三页进行校验及展示
 	$("#yyje").text(0);//将合同金额赋值到第三页进行校验及展示
 	//showJe();//重新计算已用金额和剩余金额
}
</script>

</head>
<body >
<p:authFunc funcArray="0302010106,010711"/>
<form id="download" method="post" ></form>
<form method="post" id="addForm">
<input type="hidden" id="feeTypePre"/>
<p:token/>
<table id="table1">
	<tr>
		<td>
			<table class="tableList" id="conTable">
				<tr>
<!-- 				<tr class="collspan-control"> -->
					<th colspan="4">
						<div>
							<div style="display:block;float: left">
								基础信息
								（合同编号：<c:out value="${selectInfo.cntNum }"></c:out>）
								<input type="hidden" value="${selectInfo.cntNum }" name="cntNum" >
							</div>
							<div align="right" style="display:block;float: right;" ><span>第1页</span></div>
						</div>
					</th>
				</tr>
				<tr class="collspan">
					<td class="tdLeft">合同事项<span class="red">*</span></td>
					<td class="tdRight"  >
						<input type="text" name="cntName" id="cntName" maxlength="100" class="base-input-text" valid/>
					</td>
					<td class="tdLeft">合同总金额(不含税金额+税额)</td>
					<td class="tdRight"  >
						<span id="cntAllAmtSpan"></span>
						<input type="hidden" name="cntAllAmt" id="cntAllAmt" maxlength="100" class="base-input-text" />
					</td>
				</tr>
				<tr class="collspan">					
					<td class="tdLeft">合同金额（不含税金额）<span id="cntAmtRedSpan" class="red">*</span></td>
					<td class="tdRight" >
						<input type="text" name="cntAmt" id="cntAmt"   onkeyup="$.clearNoNum(this);" style="width: 100px"  onblur="$.onBlurReplace(this);cntAllAmtSum()"  valid class="base-input-text" />
					</td>
					<td class="tdLeft">税额<span   class="red">*</span></td>
					<td class="tdRight" >
						<input type="text" name="cntTaxAmt" id="cntTaxAmt" onkeyup="$.clearNoNum(this);" style="width: 100px"  onblur="$.onBlurReplace(this);cntAllAmtSum()" valid class="base-input-text" />
					</td>
				</tr>
				<tr class="collspan">
					<td class="tdLeft">供应商<span id="providerCodeRedSpan" class="red">*</span></td>
					<td class="tdRight" colspan="3">
						<input type="hidden" name="providerType" id="providerType">
						<input type="hidden" name="provActCurr" id="provActCurr">
						<input type="hidden" name="providerCode" id="providerCode" />
						<input type="hidden" name="bankArea" id="bankArea" />
						<input type="hidden" name="actType" id="actType" />
						<input type="hidden" name="payMode" id="payMode" />
						<input type="hidden" name="bankName" id="bankName" />
						<input type="hidden" name="provActNo" id="provActNo" />
						<input type="hidden" name="providerAddr" id="providerAddr" />
						<input type="hidden" name="providerAddrCode" id="providerAddrCode" />
						<input type="hidden" name="actName" id="actName" />
						<input type="hidden" name="bankCode" id="bankCode" />
						<input type="hidden" name="bankInfo" id="bankInfo" />
						<input type="text" name="providerName" id="providerName" class="base-input-text" valid readonly onclick="queryProvider(this,'provider')"/>
					</td>
					<td class="tdLeft" id="srcPoviderTdLeft" style="display:none">实际供应商<span class="red">*</span></td>
					<td class="tdRight" id="srcPoviderTdRight" style="display:none">
						<input type="text" name="srcPoviderName" id="srcPovider" class="base-input-text"  readonly="readonly" />
						<a><img border="0" alt="查找" width="25px" height="25px" src="<%=request.getContextPath()%>/common/images/search.jpg" onclick="querySrcProvider(this)" style="vertical-align: middle;margin-left: 10px"></a>
					</td>
				</tr>
				<tr class="collspan">
					<td class="tdLeft">供应商信息</td>
					<td class="tdRight" colspan="3">
						<table >
							<tr>
								<td style="border: 0">银行名称：<span id="bankNameSpan"></span></td>
								<td style="border: 0">供应商账号：<span id="provActNoSpan"></span></td>
							</tr>
							<tr>
								<td style="border: 0">供应商地址：<span id="providerAddrSpan"></span></td>
								<td style="border: 0">银行账户名称：<span id="actNameSpan"></span></td>
							</tr>
							<tr>
								<td style="border: 0">开户行行号：<span id="bankCodeSpan"></span></td>
								<td style="border: 0">开户行详细信息：<span id="bankInfoSpan"></span></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class="collspan">
					<td class="tdLeft">
						是否存在关联合同
					</td>
					<td class="tdRight" colspan="3">
						<div class="ui-widget" style="display:inline">
							<select id="isRelatedYN" class="selectC" onchange="changeIsRelatedCnt()">
								<%-- <forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
								 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
								 conditionStr="CATEGORY_ID = 'CNT_IS_YN'"
								 orderType="ASC" selectedValue="0"/> --%>
								 <option value="0">是</option>
								 <option value="1" selected="selected">否</option>								 
							</select>
						</div>
					</td>
					<td class="tdLeft relateCntTd" style="display: none">关联合同号<span class="red">*</span></td>
					<td class="tdRight relateCntTd" style="display: none">
						<input type="text" id="cntNumRelated" name="cntNumRelated" class="base-input-text" onclick="relatedCnt()" readonly/>
					</td>
				</tr>
				<tr class="collspan">
					<td class="tdLeft">审批类别</td>
					<td class="tdRight">
						<div class="ui-widget">
							<!-- 深圳 （电子审批）-->
							<c:if test="${selectInfo.org1Code == 'A0033' }">
								<select id="lxlx" name="lxlx" class="selectC" onchange="changLxlx()">
									<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
									 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
									 conditionStr="CATEGORY_ID = 'CNT_APPROVE_TYPE'"
									 orderType="DESC" selectedValue="${selectInfo.lxlx }" />
								</select>
							</c:if>
							<!-- 非深圳（电子审批） -->
							<c:if test="${selectInfo.org1Code != 'A0033' }">
								<select id="lxlx" name="lxlx" class="selectC" onchange="changLxlx()">
									<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
									 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
									 conditionStr="CATEGORY_ID = 'CNT_APPROVE_TYPE' AND PARAM_VALUE !='1'"
									 orderType="DESC" selectedValue="${selectInfo.lxlx }" />
								</select>
							</c:if>
						</div>
					</td>
					<td class="tdLeft" id="qbhTdLeft"> 签报文号<span id="qbhRedSpan" class="red">*</span></td>
					<td class="tdRight" id="qbhTdRight">
						<input type="text" name="qbh" id="qbh" maxlength="40" valid class="base-input-text" />
					</td>
				</tr>
				<tr class="collspan">
					<td class="tdLeft">集采编号</td>
					<td class="tdRight"><input type="text" name="stockNum" id="stockNum" maxlength="100" class="base-input-text"/></td>
					<td class="tdLeft">评审编号</td>
					<td class="tdRight"><input type="text" name="psbh" id="psbh" maxlength="400" class="base-input-text"/></td>
				</tr>
				<tr class="collspan">
					<td class="tdLeft">其中合同质保金(%)<span id="zbAmtRedSpan" class="red">*</span></td>
					<td class="tdRight">
						<input type="text" name="zbAmt" valid id="zbAmt" class="base-input-text"/>
					</td>
					<td class="tdLeft">签订日期<span class="red">*</span></td>
					<td class="tdRight">
						<input type="text" name="signDate" id="signDate" valid class="base-input-text" readonly/>
					</td>
				</tr>
				<!-- 
				<tr class="collspan">
					<td class="tdLeft">增值税率</td>
					<td class="tdRight" id="providerTaxRateSpan">
						<input type="text" id="providerTaxRate" name="providerTaxRate" class="base-input-text"/>
					</td>
					<td class="tdLeft">增值税金</td>
					<td class="tdRight">
						<input type="text" name="providerTax" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);" id="providerTax" class="base-input-text"/>
					</td>
				</tr>
				 -->
				<tr class="collspan">
					<td class="tdLeft">审批数量</td>
					<td class="tdRight">
						<input type="text" id="lxsl" name="lxsl" maxlength="10" class="base-input-text"><span id="lxslSpan"></span>
					</td>
					<td class="tdLeft"> 审批金额<span id="lxjeRedSpan" class="red">*</span></td>
					<td class="tdRight"><input type="text" name="lxje" id="lxje" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);" valid class="base-input-text"/><span id="lxjeSpan"></span></td>
				</tr>
				<tr id="DZSPTr" style="display:none">
					<td colspan="4">
						<table id="DZSPTable" >
							<tr>
								<th width='20%'>缩位码</th>
								<th width='20%'>审批编号</th>
								<th width='10%'>日期</th>
								<th width='15%'>审批数量</th>
<!-- 								<th width='10%'>已执行数量</th> -->
								<th width='15%'>数量</th>
								<th width='15%'>审批金额</th>
<!-- 								<th width='15%'>已执行金额</th> -->
<!-- 								<th width='10%'>金额</th> -->
								<th width='5%'>
									<a><img id="addlxslImg" style="display:none" width="90%"
									src='<%=request.getContextPath()%>/common/images/add2.jpg' 
									alt='添加' onclick='addLxsl()'></a>
								</th>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="tdLeft">合同管理部门<span class="red">*</span></td>
					<td class="tdRight" colspan="3">
						<input type="text" id="payDutyCodeName" name="payDutyCodeName" readonly="readonly"  class="base-input-text"  valid  />
						<input type="hidden" id="payDutyCode" name="payDutyCode"   class="base-input-text"     />
						<forms:OrgSelPlugin  suffix="004" triggerEle="#addForm tr payDutyCodeName,payDutyCode::name,id" rootNodeId="${rootFeeDept}" 
							rootLevel="1" parentCheckFlag="false"  jsVarName="payDutyCodeTree"  initValue="${defaultFeeDept }"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<input type="button" class="base-input-button" value="下一页" onclick="pageOneNext()"/>
		</td>
	</tr>
</table>
<table id="table2" style="display:none;">
	<tr>
		<td>
			<table class="tableList">
				<tr>
<!-- 				<tr class="collspan-control"> -->
					<th colspan="4">
						<div>
							<div style="display:block;float: left">
								合同信息（合同编号：<c:out value="${selectInfo.cntNum }"></c:out>）
								<input id="dutyCodeName" value="${dutyCodeName }" type="hidden"/>
							</div>
							<div style="display:block;float: right;">
								第2页
							</div>							
						</div>
					</th>
				</tr>
				<tr class="collspan"> 
					<td class="tdLeft">合同类型<span class="red">*</span></td>
					<td class="tdRight">
						<div class="ui-widget">
							<select id="cntType" name="cntType" class="selectC" onchange="changeCntType()" valid errorMsg="请选择合同类型">
								<option value="">--请选择--</option>						
								<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
								 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
								 conditionStr="CATEGORY_ID = 'CNT_TYPE'"
								 orderType="ASC" selectedValue="${selectInfo.cntType }" />
							</select>
						</div>
					</td>
					<td class="tdLeft"></td>
					<td class="tdRight"></td>
				</tr>
				
				<tr id="isProvinceBuyTr" style="display:none;">
					<td class="tdLeft">省行统购项目<span class="red">*</span></td>
					<td class="tdRight" colspan="3">
						<div class="ui-widget" style="display:inline">
							<select id="isProvinceBuy" name="isProvinceBuy" class="selectC" onchange="changeProvinceBuy()" errorMsg="请选择是否省行统购">
								<option value="">--请选择--</option>						
								<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
								 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
								 conditionStr="CATEGORY_ID = 'CNT_IS_YN'"
								 orderType="ASC" selectedValue="${selectInfo.isProvinceBuy }"/>
							</select>
						</div>
					</td>
				</tr>
				<tr class="collspan">
					<td class="tdLeft">付款条件<span class="red">*</span></td>
					<td class="tdRight" colspan="3">
						<div>
							<div class="ui-widget" style="display:inline">
								<select id="payTerm" name="payTerm" class="selectC" onchange="changePayTerm()">
									<option value="">--请选择--</option>						
									<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
									 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
									 conditionStr="CATEGORY_ID = 'CNT_PAY_TERM'"
									 orderType="ASC" selectedValue="${selectInfo.payTerm }"/>
								</select>
							</div>
							<div class="ui-widget" id="stageTypeDiv" style="display:none">
								<select id="stageType" name="stageType" onchange="changeStageType()" class="selectC">
									<option value="">--请选择--</option>						
									<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
									 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
									 conditionStr="CATEGORY_ID = 'CNT_STAGE_TYPE'"
									 orderType="ASC" />
								</select>
							</div>
						</div>
					</td>		
				</tr>
				<tr id="onScheduleTr" style="display:none">
					<td class="tdLeft" valign="top">按进度分期付款<a><img border="0" width="15px" src='<%=request.getContextPath()%>/common/images/add_normal.png' alt='添加' onclick='addOnScheduleTr()'></a></td>
					<td class="tdRight" colspan="3">
						<table id="onScheduleTable">
							<tr>
								<td>第1期&nbsp;&nbsp;付款年月
									<input type='text' name='jdDate' readonly class='base-input-text jdDate'style='width:120px'/>
									支付
									<input type='text' name='jdzf' class='base-input-text' onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);installCount(null,this)" style='width:60px'>&nbsp;元</td>
								<td><a><img border='0' alt='删除' width='25px' height='25px' src='<%=request.getContextPath()%>/common/images/delete1.gif' onclick='deleteScheduleTr(this)'/></a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="onDateTr" style="display:none">
					<td class="tdLeft" valign="top">按日期分期付款<a><img border="0" width="15px" src='<%=request.getContextPath()%>/common/images/add_normal.png' alt='添加' onclick='addOnDateTr()'></a></td>
					<td class="tdRight" colspan="3">
						<table id="onDateTable">
							<tr>
								<td>合同签订后<input type='text' name='rqtj' class='base-input-text' style='width:60px'>&nbsp;天&nbsp;&nbsp;支付
									<input type='text' name='rqzf' class='base-input-text' onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);" style='width:60px'>&nbsp;元</td>
								<td><a><img border='0' alt='删除' width='25px' height='25px' src='<%=request.getContextPath()%>/common/images/delete1.gif' onclick='deleteScheduleTr(this)'/></a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="onTermTr" style="display:none">
					<td class="tdLeft">按条件分期付款</td>
					<td class="tdRight" colspan="3">
						到货支付&nbsp;&nbsp;<input type="text" class="base-input-text" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);" id="dhzf" name="dhzf" value="0.00">&nbsp;&nbsp;元&nbsp;&nbsp;&nbsp;&nbsp;
						验收支付&nbsp;&nbsp;<input type="text" class="base-input-text" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);" id="yszf" name="yszf" value="0.00">&nbsp;&nbsp;元<br/>
						结算支付&nbsp;&nbsp;<input type="text" class="base-input-text" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);" id="jszf" name="jszf" value="0.00">&nbsp;&nbsp;元
					</td>
				</tr>
				<tr class="feeClass" style="display:none">
					<td class="tdLeft">费用类型<span class="red">*</span>
						<%-- <img border='0' id='feeInfoImg' alt='费用信息' width='25px' src='<%=request.getContextPath()%>/common/images/search.jpg' onclick='feeTypePage()' align="center"/> --%>
					</td>
					<td class="tdRight">
						<div class="ui-widget">
							<select id="feeType" name="feeType" class="selectC" onchange="changeFeeType()">
								<option value="">--请选择--</option>						
								<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
								 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
								 conditionStr="CATEGORY_ID = 'CNT_FEE_TYPE'"
								 orderType="ASC" selectedValue="${selectInfo.feeType }"/>
							</select>
						</div>
					</td>
					<td class="tdLeft" id="feeSubTypeTdLeft"> 费用子类型<span class="red">*</span></td>
					<td class="tdRight" id="feeSubTypeTdRight">
						<div class="ui-widget">
							<select id="feeSubType" name="feeSubType" class="selectC" onchange="changeFeeSubType()">
								<option value="">--请选择--</option>						
								<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
								 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
								 conditionStr="CATEGORY_ID = 'CNT_FEE_SUB_TYPE'"
								 orderType="ASC" selectedValue="${selectInfo.feeSubType }"/>
							</select>
						</div>
					</td>
				</tr>
				<tr class="collspan" id="isSpecTr"> 
					<td class="tdLeft"><span class="prompt">是否专项包</span><span id="isSpecTd"   class="red">*</span></td>
					<td class="tdRight"> 
						<div class="ui-widget" style="display:inline">
							<select id="isSpec" name="isSpec" class="selectC" onchange="changeIsSpec()"  errorMsg="请选择是否专项包">
								<option value="">--请选择--</option>						
								<forms:codeTable tableName="SYS_SELECT" selectColumn="PARAM_VALUE,PARAM_NAME"
								 valueColumn="PARAM_VALUE" textColumn="PARAM_NAME" orderColumn="PARAM_VALUE" 
								 conditionStr="CATEGORY_ID = 'CNT_IS_YN'"
								 orderType="ASC"/>
							</select>
						</div>
					</td>
					<td class="tdLeft"></td>
					<td class="tdRight"></td>
				</tr>
				<tr id="feeDateTr" class="feeClass" style="display:none">
					<td class="tdLeft">合同受益起始日期<span id="feeStartDateRedSpan" class="red">*</span></td>
					<td class="tdRight"><input type="text" name="feeStartDate" id="feeStartDate" class="base-input-text" readonly onchange="removeFeeInfoTable();addFromDateValue(this);calcfeeEndDate();"/></td>
					<td class="tdLeft">合同受益终止日期<span id="actualFeeEndDateRedSpan" class="red">*</span></td>
					<td class="tdRight"><input type="text" name="actualFeeEndDate" id="actualFeeEndDate" class="base-input-text" readonly onchange="removeFeeInfoTable()"/></td>
				</tr>
				<tr id="feeCntTr" class="feeClass" style="display:none">
					<td class="tdLeft">实际受益期数<span id="feeCntRedSpan" class="red">*</span></td>
					<td class="tdRight"><input type="text" name="feeCnt" id="feeCnt" class="base-input-text" maxlength="3" onkeyup="$.clearNoNum(this);calcfeeEndDate();" onblur="$.onBlurReplace(this);" onchange="removeFeeInfoTable();"/></td>
					<td class="tdLeft">实际合同受益终止日期区间</td>
					<td class="tdRight"><span id="feeEndDateShow"></span><input type="hidden" name="feeEndDate" id="feeEndDate"/></td>
				</tr>
				<tr id="feeAmtTr" class="feeClass" style="display:none">
					<td class="tdLeft">合同金额（人民币）确定部分<span id="feeAmtRedSpan" class="red">*</span></td>
					<td class="tdRight"><input type="text" name="feeAmt" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);" id="feeAmt" class="base-input-text"/></td>
					<td class="tdLeft">合同金额（人民币）约定罚金</td>
					<td class="tdRight"><input type="text" name="feePenalty" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);" id="feePenalty" class="base-input-text" value="0"/></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<input type="button" value="上一页" onclick="pageTwoBefore()"/>
			<input id="pageTwoNextButton" type="button" value="下一页" onclick="pageTwoNext()"/>
		</td>
	</tr>
</table>
<table id="table3" style="display:none;" ><!--  -->
	<tr id="tr3">
		<td>
			<table id="feeInfo" class="tableList">
				<tr>
<!-- 				<tr class="collspan-control"> -->
					<th colspan="4">
						<div>
							<div style="display:block;float: left;">
								物料采购信息（合同编号：<c:out value="${selectInfo.cntNum }"></c:out>）
							</div>
							<div style="display:block;float: left;margin-left: 20px;">
								合同不含税金额：<span id="execAmt0"></span>
								&nbsp;&nbsp;合同税额：<span id="cntTaxAmt0"></span>
							</div>
							<div style="display:block;float: right;">
								第3页
							</div>							
						</div>	
					</th> 
				</tr>
				<tr class="collspan">
					<td class="tdLeft" colspan="2">
						<div style="width:30%;height: 100%;float: left;">采购数量：
							<input type="hidden" name="totalNum" id="totalNum" value="0"/>
							<span id="totalNumSpan"></span>
						</div>
						<div style="width: 30%;height: 100%;float: left;">采购的不含税总金额:<span id="execAmt1">0</span>
						
						</div>
						<div style="width: 30%;height: 100%;float: left;">采购的税额:<span id="cntTaxAmt1">0</span>
						
						</div>
					</td>
				</tr>
				<tr class="collspan">
					<td style="padding-left:5px;" colspan="2">
						<div id="scrollTableDiv" style="width:1250px; overflow-x:scroll;">
							<table id="totalNumTable"  style="table-layout: fixed;">
								<tr>
									<th  width="100px"><a><img border="0" width="15px" src='<%=request.getContextPath()%>/common/images/add_normal.png' alt='添加' onclick="addTotalNum()"></a>&nbsp;&nbsp;项目<span   class="red">*</span></th>			
									<th  width="190px">费用承担部门<span   class="red">*</span></th> 
									<th  width="150px">物料类型<span   class="red">*</span></th>      
									<th  width="100px">监控指标<span   class="red">*</span></th>      
									<th  width="100px">设备型号</th>      
									<th  width="110px">专项<span   class="red">*</span></th>         
									<th  width="110px">参考<span   class="red">*</span></th> 
									<th  width="110px">税码<span   class="red">*</span></th>         
									<th  width="60px">数量<span   class="red">*</span></th>          
									<th  width="60px">单价(元)<span   class="red">*</span></th>  
									<th  width="80px">金额(元)</th> 
									<th  width="80px">税额(元)<span   class="red">*</span></th>  
									<th  width="70px">保修期(年)</th>
									<th  width="70px">制造商</th>        
									<th  width="50px">操作</th>          
								</tr>
								<tr>
									<td><input type="hidden" name="projId"/><input type="text" valid name="projName" readonly="readonly" onclick="projOptionPage(this)" class="base-input-text" style="width:100px"></td>
									<td><input name="feeDept" type="hidden"><input name="feeDeptName" valid type="text" class="base-input-text" style="width:190px"/></td>
									<td><input type="hidden" name="trCglCode" /><input type="hidden" name="matrCode" /><input type="text" name="matrName" valid onclick="matrTypeOptionPage(this)" readonly class="base-input-text" style="width:150px"></td>
									<td><input type="hidden" name="montCode" /><span name="montName" style="width: 100px;"></span></td>
									<td><input type="text"  name="deviceModelName" maxlength="20" class="base-input-text" style="width:100px"/></td>
									<td><input type="hidden" name="special" value="0"/><input type="text" valid name="specialName" value="默认" readonly="readonly" onclick="specialPop(this)" class="base-input-text" style="width:100px"></td>
									<td><input type="hidden" name="reference" value="0"/><input type="text" valid name="referenceName" value="默认" readonly="readonly" onclick="referencePop(this)" class="base-input-text" style="width:100px"></td>
									
									<td>
										 <input type="hidden" name="taxCode"/><input type="text" valid name="taxCode" readonly="readonly" onclick="taxCode(this)" class="base-input-text" style="width:100px"/>
									</td>
									
									<td id="execNumTdInit">
										<input type="text" valid name="execNum" class="base-input-text" style="width:60px;" onblur="computTotalNum(this)" onkeyup="$.clearNoNum(this);" onchange="removeFeeInfoTable()">
									</td>
									<td><input type="text" valid name="execPrice" class="base-input-text" style="width:60px" onkeyup="$.clearNoNum(this);" onblur="$.onBlurReplace(this);computTotalNum(this);removeFeeInfoTable();" ></td>
									<td>
										<input type="hidden" name="execAmt"><span name="execAmtText" style="width:80px"></span>
									</td>
									<td>
										<input type="hidden" name="taxRate"><span name="cntTrAmt" style="width:80px"></span>
										<input type="hidden" name ="deductFlag"/>
									</td>
									<td><input type="text"  name="warranty" class="base-input-text" style="width:70px;"></td>
									<td><input type="text"  name="productor" maxlength="100" class="base-input-text" style="width:70px;"></td>
									<td><a><img border="0" alt="删除" width="25px" height="25px" src="<%=request.getContextPath()%>/common/images/delete1.gif" onclick="deleteTotalNum(this)"/></a></td>
								</tr>
							</table>
						</div>
						<forms:OrgSelPlugin relayLoadFlag ="FALSE"
						  triggerEle="#totalNumTable tr feeDeptName::name" rootNodeId="${rootFeeDept}" 
							initValue="${defaultFeeDept }" parentCheckFlag="false" dialogFlag="true" jsVarName="feeDeptTag" changeFun="changeFeeDept"/>
					</td>
				</tr>
				<tr class="collspan">
					<td class="tdLeft" style="width:25%;">备注(<span id="authmemoSpan">0/2000</span>)</td>
					<td class="tdRight" style="width:75%;">
						<textarea class="base-textArea" onkeyup="$_showWarnWhenOverLen1(this,2000,'authmemoSpan')" id="memo" name="memo"></textarea>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id="fz_select" style="display: none">
		<td>
			<input type="button" value="上一页" onclick="pageThreeBefore()"/>
			<input id="pageThreeNextButton" type="button" value="下一页" onclick="pageThreeNext()"/>
		</td>
	</tr>
	<tr id="fz_notselect">
		<td>
			<input type="button" value="上一页" onclick="pageThreeBefore()"/>
			<input type="button" value="扫描合同影像" onclick="scan()"/> 
			<!-- <input type="button" value="扫描控件下载" onclick="scanUpload('ICMS_SCAN_PLUGIN')"/> -->
			<input type="button" value="保存为草稿" onclick="pageThreeSave()"/>
			<input type="button" id="bSubmit" value="提交至待复核" disabled="disabled" onclick="pageThreeSubmit()"/>
			
<!-- 			<input type="button" value="重置" onclick="resetAll()"/> -->
		</td>
	</tr>
</table>
<table id="table4" style="display: none;">
	<tr id="tr4">
		<td>
			<table id="feeInfoDz" class="tableList">
				<tr>
					<th colspan="4">
						<div>
							<div style="display:block;float: left;">
								物料采购信息（合同编号：<c:out value="${selectInfo.cntNum }"></c:out>）
							</div>
							<div style="display: block; float: left; margin-left: 20px;">
								合同总金额：<span id="cntAmt4"></span> &nbsp;&nbsp;
								合同不含税金额：<span id="execAmt4"></span> &nbsp;&nbsp;
								合同税额：<span id="cntTaxAmt4"></span>
							</div>
							<div style="display: block; float: right;">第4页</div>
						</div>
					</th>
				</tr>
				<tr id="houseTr" style="display: none" class="feeClass">
					<td colspan="4">
						<table id="houseTable">
							<tr>
								<td class="tdLeft">地址(说明)<span class="red">*</span></td>
								<td class="tdRight"><input type="text" name="wydz" id="wydz" maxlength="1000" valid class="base-input-text" /></td>
								<td class="tdLeft">租赁面积(数量)<span class="red">*</span></td>
								<td class="tdRight"><input type="text" name="area" id="area" valid onkeyup="$.clearNoNum(this);" class="base-input-text" /><br>平方米(项)</td>
							</tr>
							<tr id="fc_select">
								<td class="tdLeft">租赁类型<span class="red">*</span></td>
								<td class="tdRight" colspan="3">
									<div class="ui-widget">
										<select id="houseKindId" name="houseKindId" class="selectC" valid onchange="fcSelect();">
											<option value="">--请选择--</option>
											<forms:codeTable tableName="SYS_SELECT"
												selectColumn="PARAM_VALUE,PARAM_NAME"
												valueColumn="PARAM_VALUE" textColumn="PARAM_NAME"
												orderColumn="PARAM_VALUE"
												conditionStr="CATEGORY_ID = 'HOUSE_KIND'" orderType="ASC" />
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td class="tdLeft">合同受益终止年月</td>
								<td class="tdRight" colspan="3"><span id = "showFeeEndDate"></span></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class="collspan">
					<td style="padding-left: 5px;" colspan="4" id="TenancyDzTd">
						<!-- <div id="scrollTableDivDz"
							style="width: 1500px; overflow-x: scroll;">
						</div> -->
					</td>
				</tr>
				<tr>
					<td class="tdLeft">备注(<span id="remarkSpan">0/2000</span>)
					</td>
					<td class="tdRight" colspan="3"><textarea
							class="base-textArea"
							onkeyup="$_showWarnWhenOverLen1(this,2000,'remarkSpan')"
							id="remark" name="remark"></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td><input type="button" value="上一页" onclick="pageFourBefore()" />
			<input type="button" value="扫描合同影像" onclick="scan()" /> <input
			type="button" value="保存为草稿" onclick="pageFourSave()" /> <input
			type="button" id="bSubmit" value="提交至待复核" disabled="disabled"
			onclick="pageFourSubmit()" /></td>
	</tr>
</table>
	</form>
</body>
</html>