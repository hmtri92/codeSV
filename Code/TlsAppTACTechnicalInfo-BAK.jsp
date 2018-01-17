<%--
/*
 *  @(#)TlsAppTACEquipInfo.jsp  1.0 11/08/2004
 *
 *  Copyright (c) 2001 Singapore Computer Systems
 *  7 Bedok South Road, Singapore.
 *
 *  All rights reserved.
 *
 *  This software is the confidential and proprietary information of
 *  SCS. ( "Confidential Information" ). You shall not
 *  disclose such Confidential Information and shall use it only in
 *  accordance with the terms of the license agreement you entered
 *  into with SCS.
 */

/**
 * Modifications Log
 * S.No  Date        Modified By       PR/CR No                   Remarks
 * 1  01/06/2005  pkarthi@scs.com.sg   CR-TLS-2005018     Line / Radio Validation.
 * 2  20/06/2005  pkarthi@scs.com.sg   CR-TLS-2005018     New field added - Applied for and new validation to warn form data entry.
 * 3  25/10/2005  selvaran@scs.com.sg  CR-TLS-2005039	  To allow save button for TAC pages only to users with Function id - 'AMEND_EQP_REGDETAIL'
 *														  and for those applications whose status changed to N/L or R/R
 * 4  06/11/2007  ksubramania3@csc.com TLS06-12-007	 	  CB Module - CB Fields made mandatory, Width alignment, CB Related info display.
 *														   
 */

/**
 *
 * @author    pillai@scs.com.sg
 * @version   1.0 11 Augest 2004
 */
 --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="struts/bean" prefix="bean"%>
<%@ taglib uri="struts/html" prefix="html"%>
<%@ taglib uri="struts/logic" prefix="logic"%>
<%@ taglib uri="tls/common" prefix="tls"%>
<%@ page import="tls.ida.TlsGlobals"%>
<%@ page errorPage="/tls/ida/common/TlsCommonError.jsp" %>
<%@ page import="tls.ida.mgr.TlsConfigMgr"%>
<%@ page import="tls.ida.bean.util.TlsConfig"%>
<%@ page import="tls.ida.bean.applications.applicationdetails.TlsAppTACEquipInfoHdrDTO"%>
<html:html locale="true">
<head>
<title>TLS - Application Details - Technical Info</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="<%=TlsConfigMgr.strCSS%>" type="text/css"/>
<SCRIPT language="JavaScript" src="<%=TlsConfigMgr.strJS%>TlsCalendar.js"></SCRIPT>
<script language="JavaScript" src="<%=TlsConfigMgr.strJS%>TlsCommon.js"></script>
<script language="JavaScript" src="<%=TlsConfigMgr.strJS%>TlsAppTACEquipInfo.js"></script>
<SCRIPT language="JavaScript1.2">
//Set all the javascript alert message from bean.
var MSG_CONFIRMADD		= '<bean:message key="msg.add.confirm" arg0="record(s)"/>';
var MSG_CONFIRMUPDATE	= '<bean:message key="msg.update.confirm" arg0="record(s)"/>';
var MSG_CONFIRMDELETE	= '<bean:message key="msg.delete.confirm" arg0="record(s)"/>';
var MSG_IS_DELETE		= '<bean:message key="msg.delete.select" arg0="record(s)"/>';
var MSG_IS_MAXI			= '<bean:message key="errors.maximum.char" />';
var MSG_NO_INVCHN		= '<bean:message key="errors.invalid" arg0="No. of Channels"/>';
var MSG_INVPRODDATE		= '<bean:message key="errors.invalid" arg0="Date of Product Cert issued by CB"/>';
var MSG_EMPTY_CBNAME	= '<bean:message arg0="Name of Certificate Body " key="errors.mandatory"/>';
var MSG_EMPTY_CBNO	    = '<bean:message arg0="CB Certificate No." key="errors.mandatory"/>';
var MSG_EMPTY_EQUIP_RADIO = '<bean:message arg0="TX Freq Range or RX Freq Range" key="errors.mandatory"/>';
var MSG_EMPTY_OUTPUT_RADIO = '<bean:message arg0="RF Power Output" key="errors.mandatory"/>';
var MSG_EMPTY_EQUIP_CMTRANGFLAG = '<bean:message arg0="please select the relevant frequency bands checkbox" key="errors.mobile"/>';
var MSG_EMPTY_AUTODIAL = '<bean:message arg0="Auto-dial Feature" key="errors.select"/>';
var MSG_EMPTY_EQUIP_TYPE = '<bean:message arg0="Technical data for" key="errors.select"/>'; 
var MSG_WARN_RDLN_IND_RD = "<bean:message bundle="<%=TlsGlobals.MOD_APPLICATION%>" arg0="Equipment Technical Data - Line" arg1="Radiocom" key="msg.warn.radioline.selection"/>"; 
var MSG_WARN_RDLN_IND_LN = "<bean:message bundle="<%=TlsGlobals.MOD_APPLICATION%>" arg0="Equipment Technical Data - Radiocom" arg1="Line" key="msg.warn.radioline.selection"/>"; 

var MSG_MAND_CB_CERT_DATE	= '<bean:message key="errors.mandatory" arg0="Date of Product Cert Issued by CB"/>';
var MSG_MAND_CB_ID_NO	= '<bean:message key="errors.mandatory" arg0="CB Identification No."/>';
var MSG_MAND_CB_PROD_CERT_NO	= '<bean:message key="errors.mandatory" arg0="Product Cert No."/>';

 // 20/06/2005  pkarthi@scs.com.sg  CR-TLS-2005018  New field added - Applied for and new validation to warn wrong form data entry.

// auto dial radio button special push button style
var autoDialBuffer = '<bean:write name="viewAppTACEquipData" property="strLnAutoDial"/>';
function clickedAutoDial(){
 var frmObj = document.forms[0];

  var selectedInd = getSelectedRadioValue(frmObj.strLnAutoDial);
  var buttonPos = getSelectedRadio(frmObj.strLnAutoDial);
 // alert('selected: '+selectedInd+' button position: '+buttonPos);
  if(selectedInd==autoDialBuffer){
    if(buttonPos!= -1){
	  frmObj.strLnAutoDial[buttonPos].checked=false;
	  autoDialBuffer='';
	}
  }else{
    autoDialBuffer=selectedInd;
  }

}

// check line part of the form for non empty field
function isLineFormEmpty(){
  var frmObj = document.forms[0];
  var result=true;
  //alert("validating in line");
  if(!isFieldBlank(frmObj.strLnPowSrc) || !isFieldBlank(frmObj.strLnDataUpStr) || !isFieldBlank(frmObj.strLnDataDownStr) 
   || !isFieldBlank(frmObj.strLnCustIntType)  || !isFieldBlank(frmObj.strLnLinePorts) || !isFieldBlank(frmObj.strLnDIDTrunk) 
   || !isFieldBlank(frmObj.strLnProType) || !isFieldBlank(frmObj.strLnSoftVer) || !isFieldBlank(frmObj.strLnCusTerUsed) 
   || !isFieldBlank(frmObj.strLnNetIntUsed) ){
     result=false;
  }
  return result;
}

// check radiocom part of the form for non empty field
function isRadioFormEmpty(){
  var frmObj = document.forms[0];
  var result=true;
    //alert("validating in radio");
    if( !isFieldBlank(frmObj.strRdTxFreq1) ||
		!isFieldBlank(frmObj.strRdRxFreq1) || 
		!isFieldBlank(frmObj.strRdRfOutputPow1) 
   || !isFieldBlank(frmObj.strRdTxFreq2) 
   || !isFieldBlank(frmObj.strRdRxFreq2) 
   || !isFieldBlank(frmObj.strRdRfOutputPow2)
   || !isFieldBlank(frmObj.strRdTxFreq3) || !isFieldBlank(frmObj.strRdRxFreq3) || !isFieldBlank(frmObj.strRdRfOutputPow3)
   || !isFieldBlank(frmObj.strRdTxFreq4) || !isFieldBlank(frmObj.strRdRxFreq4) || !isFieldBlank(frmObj.strRdRfOutputPow4)	
   || !isFieldBlank(frmObj.strRdTxFreq5) || !isFieldBlank(frmObj.strRdRxFreq5) || !isFieldBlank(frmObj.strRdRfOutputPow5)	
   || !isFieldBlank(frmObj.strRdTxFreq6) || !isFieldBlank(frmObj.strRdRxFreq6) || !isFieldBlank(frmObj.strRdRfOutputPow6)
   //20090611 William TLS08-08-003: aditional fields
   || !isFieldBlank(frmObj.strRdTxFreq7) || !isFieldBlank(frmObj.strRdRxFreq7) || !isFieldBlank(frmObj.strRdRfOutputPow7)
   //20090611 William TLS08-08-003: aditional fields - end						
   || !isFieldBlank(frmObj.strRdCnlSpa)  || !isFieldBlank(frmObj.strRdNoCnl) || !isFieldBlank(frmObj.strModType) 
   || !isFieldBlank(frmObj.strTACNoGSMEquip) || !isFieldBlank(frmObj.strSARValue)){
     result=false;
  }
  return result; 
}

//clickBack method for Back button.
function clickBack(){
	submitPage(TlsAppTACEquipAddEdit,'viewAppEdit','TlsAppLicenceParticularAction.do');
	return true;
}
//clickLink method for hyperlink. Check for at least one record(s) selected.
function clickLink(frmDispatch,frmAction){
	submitForm(frmDispatch,frmAction);
	return true;
}

// function to check equip radio tech info required fields
function validateEquipTechLineRadio(){
  formObj = document.forms[0];

  <logic:notEqual name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_RADIO_IND%>"> 
	 <logic:notEqual name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_LINE_IND%>"> 
	    if( getSelectedRadio(formObj.strRdLnInd) < 0){
           alert(MSG_EMPTY_EQUIP_TYPE);
	       return false;
        }
        var appliedInd = getSelectedRadioValue(formObj.strRdLnInd);
        if(appliedInd!='R'){
			 if(getSelectedRadioValue(formObj.strLnAutoDial)==''){
   			    alert(MSG_EMPTY_AUTODIAL);
				return false;
			  }
		}

		 if(appliedInd!='R' && appliedInd!='B'){
			 if(!isRadioFormEmpty()){
				alert(MSG_WARN_RDLN_IND_LN);
				return false;
			  }
		 }
		 var idaflag = formObj.idaflag.value;
		 if(idaflag != 'true'){
	      if(appliedInd!='L'){
			  if((formObj.strRdTxFreq1==null||formObj.strRdTxFreq1.value=='')&&(formObj.strRdRxFreq1==null||formObj.strRdRxFreq1.value=='')){
				  alert(MSG_EMPTY_EQUIP_RADIO);
				formObj.strRdTxFreq1.focus();     
				return false;
			  }

			 if((formObj.strRdRfOutputPow1==null||formObj.strRdRfOutputPow1.value=='')){
				  alert(MSG_EMPTY_OUTPUT_RADIO);
				formObj.strRdRfOutputPow1.focus();     
				return false;
			  }
            }
		 }
		 if(idaflag == 'true'){
			 var vstrCMTRangflg1 = formObj.strCMTRangflg1.checked;
		     var vstrCMTRangflg2 = formObj.strCMTRangflg2.checked;
		     var vstrCMTRangflg3 = formObj.strCMTRangflg3.checked;
		     var vstrCMTRangflg4 = formObj.strCMTRangflg4.checked;
				if(!(vstrCMTRangflg1)&&!(vstrCMTRangflg2)&&!(vstrCMTRangflg3)&&!(vstrCMTRangflg4)){
					 alert(MSG_EMPTY_EQUIP_CMTRANGFLAG);
					 return false;
				}
			}
        if(appliedInd!='L' && appliedInd!='B'){
			 if(!isLineFormEmpty()){
    		    alert(MSG_WARN_RDLN_IND_RD);
				return false;
			  }
		 }
     </logic:notEqual> 
     <logic:equal name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_LINE_IND%>"> 
		 if(getSelectedRadioValue(formObj.strLnAutoDial)==''){
			  alert(MSG_EMPTY_AUTODIAL);
	//    	formObj.strRdRfOutputPow1.focus();     
			return false;
		  }
     </logic:equal>
  </logic:notEqual> 

  <logic:equal name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_RADIO_IND%>"> 
		  if((formObj.strRdTxFreq1==null||formObj.strRdTxFreq1.value=='')&&(formObj.strRdRxFreq1==null||formObj.strRdRxFreq1.value=='')){
			  alert(MSG_EMPTY_EQUIP_RADIO);
			formObj.strRdTxFreq1.focus();     
			return false;
		  }

		 if((formObj.strRdRfOutputPow1==null||formObj.strRdRfOutputPow1.value=='')){
			  alert(MSG_EMPTY_OUTPUT_RADIO);
			formObj.strRdRfOutputPow1.focus();     
			return false;
		  }
  </logic:equal> 
   return true;
}

//clickSave method for Save button. Dispatch will assign based on the action.
function clickSave(){
	var varSlNo = document.TlsAppTACEquipAddEdit.strSlNo.value;
	var VARDISPATCH;
	var CONFIRMMSG;
	if(varSlNo==''){
		CONFIRMMSG = MSG_CONFIRMADD;
		VARDISPATCH = "saveAppTACEquip";
	}else if(varSlNo !=''){
		CONFIRMMSG = MSG_CONFIRMUPDATE;
		VARDISPATCH = "updateAppTACEquip";
	}
		<logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
			if(validateTACTechSaveForCB())
		</logic:equal>
		<logic:notEqual name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
			if(validateTACTechSave())
		</logic:notEqual>		
		{
          if(validateEquipTechLineRadio()){
			if(confirm(CONFIRMMSG)){
				submitPage(TlsAppTACEquipAddEdit,VARDISPATCH,'TlsAppTACEquipAction.do');
				return true;
			}
		  }
		}
}
</script>
</head>
<body bgcolor="21469f" background="<%=TlsConfigMgr.strAppBg%>" text="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<html:form action="TlsAppTACEquipAction.do" >
  <table border="0" cellspacing="0" cellpadding="5" width="779" >
    <tr>
	  <td width="20">&nbsp;</td>
	  <td width="736" class="moduleName">
		<bean:message bundle="<%=TlsGlobals.MOD_APPLICATION%>" key="msg.application.module"/>
	  </td>
   </tr>
   <tr>
	  <td>&nbsp;</td>
	  <td class="functionName">
		<bean:message bundle="<%=TlsGlobals.MOD_APPLICATION%>" key="msg.addedit.addAppTACTech"/>
	  </td>
	</tr>
    <tr> 
	  <td valign="top" width="20">&nbsp;</td>
      <td valign="top" width="745"> 
        <table border="0" cellspacing="0" cellpadding="2" width="100%">
          <tr> 
            <td width="15%" valign="top" class="h3"> Client ID</td>
            <td width="30%" valign="top" class="bodyText">
				<bean:write name="headerStationDetails" property="strClientID"/>
			</td>
            <td width="15%" valign="top" class="h3">Licence Type </td>
            <td width="40%" valign="top" class="bodyText">
				<bean:write name="headerStationDetails" property="strLicTypeCd"/> - 
				<bean:write name="headerStationDetails" property="strLicDesc"/>
			</td>
          </tr>
          <tr> 
            <td width="15%" valign="top" class="h3">Company Name </td>
            <td width="30%" valign="top" class="bodyText">
				<bean:write name="headerStationDetails" property="strCompName"/>
			</td>
            <td width="15%" valign="top" class="h3">Application No. </td>
            <td width="40%" valign="top" class="bodyText">
				<bean:write name="headerStationDetails" property="strAppNo"/>
			</td>
          </tr>
          <tr> 
            <td width="15%" valign="top" height="15" class="h3"> Licence No. </td>
            <td width="30%" valign="top" height="15" class="bodyText">
				<bean:write name="headerStationDetails" property="strLicNo"/>
            </td>
            <td width="15%" valign="top" height="15" class="h3">Licence Status</td>
            <td width="40%" valign="top" height="15" class="bodyText">
				<bean:write name="headerStationDetails" property="strLicStsCd"/> - 
				<bean:write name="headerStationDetails" property="strLicStsDesc"/>
			</td>
          </tr>
          <tr> 
			<%-- SK - Show the CB Identification No. instead of the Dealer Licence Info. for the CB Users --%>
            <logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
				<td width="19%" valign="top" class="h3">CB Identification No.</td>
				<td width="26%" valign="top" class="bodyText" colspan="3">
					<logic:notEmpty name="headerStationDetails" property="strCBIdentificationNo">
						<bean:write name="headerStationDetails" property="strCBIdentificationNo"/>
					</logic:notEmpty>					
				</td>					
			</logic:equal>
			<logic:notEqual name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">          
	            <td width="15%" valign="top" class="h3">Dealer Licence No. </td>
	            <td width="30%" valign="top" class="bodyText">
					<bean:write name="headerStationDetails" property="strDealLicNo"/>
				</td>
	            <td width="15%" valign="top" class="h3">Dealer Licence Status</td>
	            <td width="40" valign="top" class="bodyText">
					<bean:write name="headerStationDetails" property="strDealLicSts"/>
				</td>
			</logic:notEqual>
			<%-- Display of the Dealer Licence Info or CB Identification Done appropriately based on the Licence Type --%>				
          </tr>
           <tr>
            <td width="15%" valign="top" class="h3">Scheme</td>
            <td width="85%" valign="top" class="bodyText" colspan="3">
				<bean:write name="headerStationDetails" property="strScheme"/>
			</td>
          </tr>
			<html:hidden name="headerStationDetails" property="strClientID"/>
			<html:hidden name="headerStationDetails" property="strLicTypeCd"/>
			<%-- 20100716 Rey: added strSchemeTypeCd --%>
			<html:hidden name="headerStationDetails" property="strSchemeTypeCd"/>
			<html:hidden name="headerStationDetails" property="strAppNo"/>
			<html:hidden name="headerStationDetails" property="strLicNo"/>
			<html:hidden name="headerStationDetails" property="strTransID"/>
			<html:hidden name="headerStationDetails" property="strLicStsCd"/>
			<html:hidden name="headerStationDetails" property="strLicenceGroup"/>
			<input type="hidden" name="strCategory" value='<bean:write name="headerStationDetails" property="strCategory"/>' >
        </table>
      </td>
    </tr>
    
    <tr> 
      <td valign="top" width="20" >&nbsp;</td>
      <td valign="top" width="745" > 
        <table border="0" cellspacing="0" width="100%" cellpadding="1">
          <%@include file="/tls/ida/applications/applicationdetails/TlsAppLicenceHeader.jsp"%>
          <tr> 
            <td colspan="4" height="16" valign="middle" class="heading" class="h2">Technical 
              Data Info
			</td>
          </tr>
          <tr> 
            <td width="26%" height="16" valign="middle" class="h3">Test Lab Name</td>
            <td width="29%" class="bodyText">
              <html:text name="viewAppTACEquipData" property="strTestLabName" size="20" maxlength="100" />
             </td>
            <td width="20%" height="16" valign="middle" class="h3">Test Report 
              No.</td>
            <td width="25%" class="bodyText">
              <html:text name="viewAppTACEquipData" property="strTestRepNo" size="20" maxlength="20" />
            </td>
          </tr>
          <tr> 
            <td width="26%" class="h3">Country of Lab</td>
            <td colspan="3">
              <html:select name="viewAppTACEquipData" property="strLabCountry">
				<html:option value="0">-SELECT-</html:option>
				<html:options collection="CountryList" property="strItemCd" labelProperty="strItemDesc"/>
			  </html:select>
            </td>
          </tr>
          <%-- Following Fields become mandatory based on the CB or Non-CB Applicant status --%>
          <tr> 
            <td width="26%" height="16" valign="middle" class="h3"> Name of Certificate 
              Body (CB)
              <logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
              	<tls:asterisk/>
              </logic:equal>
              </td>
				<logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
					<logic:notEmpty name="viewAppTACEquipData" property="strCBName">
						<td width="29%" valign="top" class="bodyText">
							<bean:write name="viewAppTACEquipData" property="strCBName"/>
							<input type="hidden" name="strCBName" value="<bean:write name="viewAppTACEquipData" property="strCBName"/>">
						</td>
					</logic:notEmpty>
					<logic:empty name="viewAppTACEquipData" property="strCBName">
						<td width="29%" >
							<html:text name="viewAppTACEquipData" property="strCBName" size="20" maxlength="66"/>
						</td>
					</logic:empty>
				</logic:equal>
				<logic:notEqual name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
					<td width="29%">
						<html:text name="viewAppTACEquipData" property="strCBName" size="20" maxlength="66" />
					</td>
				</logic:notEqual>
            <td width="20%" height="16" valign="middle" class="h3"> CB Certificate 
              No.
              <logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
              	<tls:asterisk/>
              </logic:equal>
              </td>
				<logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
					<logic:notEmpty name="viewAppTACEquipData" property="strCBCertNo">						
						<td width="25%" valign="top" class="bodyText">
							<bean:write name="viewAppTACEquipData" property="strCBCertNo"/>
							<input type="hidden" name="strCBCertNo" value="<bean:write name="viewAppTACEquipData" property="strCBCertNo"/>">
						</td>
					</logic:notEmpty>
					<logic:empty name="viewAppTACEquipData" property="strCBCertNo">
						<td width="25%" >
							<html:text name="viewAppTACEquipData" property="strCBCertNo" size="20" maxlength="66"/>
						</td>
					</logic:empty>
				</logic:equal>
				<logic:notEqual name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
					<td width="25%">
						<html:text name="viewAppTACEquipData" property="strCBCertNo" size="20" maxlength="66" />
					</td>
				</logic:notEqual>
          </tr>
          <tr> 
            <td width="26%" height="11" valign="middle" class="h3">CB Identification 
              No.
              <logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
              	<tls:asterisk/>
              </logic:equal>
              </td>
				<logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
					<logic:notEmpty name="viewAppTACEquipData" property="strCBIdenNo">						
						<td width="29%" height="11" valign="top" class="bodyText">
							<bean:write name="viewAppTACEquipData" property="strCBIdenNo"/>
							<input type="hidden" name="strCBIdenNo" value="<bean:write name="viewAppTACEquipData" property="strCBIdenNo"/>">
						</td>
					</logic:notEmpty>
					<logic:empty name="viewAppTACEquipData" property="strCBIdenNo">
						<td width="29%" height="11" >
							<html:text name="viewAppTACEquipData" property="strCBIdenNo" size="20" maxlength="66"/>
						</td>
					</logic:empty>
				</logic:equal>
				<logic:notEqual name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
					<td width="29%" height="11">
						<html:text name="viewAppTACEquipData" property="strCBIdenNo" size="20" maxlength="66" />
					</td>
				</logic:notEqual>
            <td width="20%" height="11" valign="middle" class="h3">Date of Product 
              Cert Issued by CB
              <logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
              	<tls:asterisk/>
              </logic:equal>
			</td>
            <td width="25%" height="11">
              <html:text name="viewAppTACEquipData" property="strProdDate" size="10" maxlength="10" />
			   <html:link href="javascript:show_calendar('TlsAppTACEquipAddEdit.strProdDate',null,null,'DD/MM/YYYY')"> 
				<img width="26" height="18" align="absMiddle" src="<%=TlsConfigMgr.strIMG%>calendar.gif" border="0" name="calendar">
			  </html:link>
            </td>
          </tr>
          <tr> 
            <td width="26%" height="16" valign="middle" class="h3">Product Cert 
              No.
              <logic:equal name="headerStationDetails" property="strLicTypeCd" value="<%=TlsGlobals.LICENCE_TYPE_CBEQR%>">
              	<tls:asterisk/>
              </logic:equal>
              </td>
            <td width="29%">
             <html:text name="viewAppTACEquipData" property="strProdNo" size="20" maxlength="20" />
            </td>
            <td width="20%" height="16" valign="middle" class="h3">Applied For<tls:asterisk/></td>
            <td width="25%">
			  <logic:notEqual name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_LINE_IND%>"> 
				<logic:notEqual name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_RADIO_IND%>">
				  <html:radio name="viewAppTACEquipData" property="strRdLnInd" value="L">Line</html:radio>&nbsp;
				  <html:radio name="viewAppTACEquipData" property="strRdLnInd" value="R">Radiocom</html:radio>&nbsp;
				  <html:radio name="viewAppTACEquipData" property="strRdLnInd" value="B">Both</html:radio>
				</logic:notEqual>
				<logic:equal name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_RADIO_IND%>">
				  Radiocom <input type="hidden" name="viewAppTACEquipData" property="strRdLnInd" value="R">
				</logic:equal>
			  </logic:notEqual>
			  <logic:equal name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_LINE_IND%>">
			     Line <input type="hidden" name="viewAppTACEquipData" property="strRdLnInd" value="L">
			  </logic:equal>
		  </td>
          </tr>
		  <logic:notEqual name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_RADIO_IND%>">
          <tr> 
            <td colspan="4" height="16" valign="middle" class="heading" class="h2">Equipment Technical Data - Line
			</td>
          </tr>
          <tr> 
            <td width="26%" height="16" valign="middle" class="h3">Power Source 
              (built-in / external / from network) </td>
            <td width="29%">
              <html:text name="viewAppTACEquipData" property="strLnPowSrc" size="20" maxlength="20" />
            </td>
            <td width="20%" height="16" valign="middle" class="h3">Auto-Dial Feature 
            </td>
            <td width="25%">
              <html:radio name="viewAppTACEquipData" property="strLnAutoDial" value="Y" onclick="clickedAutoDial();"/>
              Yes 
              <html:radio name="viewAppTACEquipData" property="strLnAutoDial" value="N" onclick="clickedAutoDial();"/>
              No
			</td>
          </tr>
          <tr> 
            <td width="26%" height="16" valign="middle" class="h3">Data Speed 
              Upstream Rates</td>
            <td width="29%"> 
             <html:text name="viewAppTACEquipData" property="strLnDataUpStr" size="20" maxlength="20" />
            </td>
            <td width="20%" height="16" valign="middle" class="h3">Data Speed 
              Downstream Rates</td>
            <td width="25%"> 
              <html:text name="viewAppTACEquipData" property="strLnDataDownStr" size="20" maxlength="20" />
            </td>
          </tr>
          <tr> 
            <td width="26%" height="16" valign="middle" class="h3">Type of Customer 
              Interface (eg 10BaseT, USB, ATM End-Point, ATM switch)</td>
            <td width="29%"> 
              <html:text name="viewAppTACEquipData" property="strLnCustIntType" size="20" maxlength="20" />
            </td>
            <td width="20%" height="16" valign="middle" class="h3">Line Ports 
              (eg no. of trunk ports, CO trunks & extensions) </td>
            <td width="25%"> 
              <html:text name="viewAppTACEquipData" property="strLnLinePorts" size="20" maxlength="20" />
            </td>
          </tr>
          <tr> 
            <td width="26%" height="16" valign="middle" class="h3">&nbsp; </td>
            <td width="29%">&nbsp;</td>
            <td width="20%" height="16" valign="middle" class="h3">No. of DID 
              Trunks</td>
            <td width="25%"> 
              <html:text name="viewAppTACEquipData" property="strLnDIDTrunk" size="20" maxlength="20" />
            </td>
          </tr>
          <tr> 
            <td width="26%" height="16" valign="middle" class="h3">Protocol Type 
            </td>
            <td width="29%" class="txtLabel"> 
              <html:text name="viewAppTACEquipData" property="strLnProType" size="20" maxlength="20" />
            </td>
            <td width="20%" height="16" valign="middle" class="h3">Software Version</td>
            <td width="25%"> 
              <html:text name="viewAppTACEquipData" property="strLnSoftVer" size="20" maxlength="20" />
            </td>
          </tr>
          <tr> 
            <td colspan="2" height="2" valign="middle" class="txtLabel">&nbsp;</td>
            <td colspan="2" height="2" valign="middle" class="txtLabel">&nbsp;</td>
          </tr>
          <tr class="h3"> 
            <td colspan="2" height="2" valign="middle" class="h3">List of Customised 
              Terminals Used</td>
            <td colspan="2" height="2" valign="middle" class="h3">List of Network 
              Interface Cards </td>
          </tr>
          <tr> 
            <td colspan="2" height="59" valign="middle" class="txtLabel"> 
              <html:textarea cols="34" rows="4" name="viewAppTACEquipData" property="strLnCusTerUsed" 
			  onkeyup="checkLength(this,100)" ></html:textarea>
            </td>
            <td colspan="2" height="59" valign="middle" class="txtLabel"> 
			  <textarea  name="strLnNetIntUsed" cols="34" rows="4" wrap="hard" onkeyup="checkLength(this,500)"><bean:write name="viewAppTACEquipData" property="strLnNetIntUsed" /></textarea>

            </td>
          </tr>
		  </logic:notEqual> 
      <logic:notEqual name="headerStationDetails"  property="strRdLnInd" value="<%=TlsGlobals.LICENCE_TAC_TYPE_LINE_IND%>">
          <tr> 
            <td colspan="4" height="4" valign="middle" class="txtLabel">
              <table border="0" cellspacing="0" width="100%" cellpadding="1">
                <tr> 
                  <td colspan="5" height="16" valign="middle" class="heading">Equipment Technical Data - Radiocom</td>
                </tr>
                <tr> 
                  <td width="22%" height="9" valign="middle" class="h2">&nbsp;</td>
                  <td width="27%" height="9" valign="middle" class="h2">TX Freq 
                    Range</td>
                  <td width="25%" class="h2" height="9">RX Freq Range</td>
                  <td colspan="2" height="9" valign="middle" class="h2" width="26%">RF 
                    Power Output</td>
                </tr>
                <!-- 20090109 Jack: add 3 more for 3G bands -->
                <!-- 20110628 Syam_CSC: added pre populated freq band for SER  -->
               <% String idaflag = "false";
               if(idaflag == ""){
                	idaflag = "false";
                }%>
                <logic:equal name="headerStationDetails" property="strSchemeTypeCd" value="<%=TlsGlobals.SCHEME_TYP_SER%>">
                <% 
                //String idaflag1 = (String)session.getAttribute("IDAFlag");
                idaflag= request.getAttribute("IDAFlag")==null?"false":(String)request.getAttribute("IDAFlag");
                System.out.println("idaflage is " +idaflag);
                if(idaflag == ""){
                	idaflag = "false";
                }
                %>
                 </logic:equal>
                 <%-- YW 20160624 Family Series --%>
                <logic:equal name="headerStationDetails" property="strSchemeTypeCd" value="<%=TlsGlobals.SCHEME_TYP_SER_FS%>">
                <% 
                //String idaflag1 = (String)session.getAttribute("IDAFlag");
                idaflag= request.getAttribute("IDAFlag")==null?"false":(String)request.getAttribute("IDAFlag");
                System.out.println("idaflage is " +idaflag);
                if(idaflag == ""){
                	idaflag = "false";
                }
                %>
                 </logic:equal>
                 <%-- YW 20160624 Family Series --%>
                 <input type='hidden' name='idaflag' value="<%=idaflag%>" />
                 <%if(idaflag.equalsIgnoreCase("true")){ %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">1.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq1" size="20" maxlength="30" readonly ='true' />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq1" size="20" maxlength="30" readonly ='true' />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow1" size="20" maxlength="20" readonly ='true' />
                    <html:checkbox name="viewAppTACEquipData" property="strCMTRangflg1"/>
                  </td>
                </tr>
                <%} if(idaflag.equalsIgnoreCase("false")){ %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">1.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq1" size="20" maxlength="30" />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq1" size="20" maxlength="30" />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow1" size="20" maxlength="20" />
                  </td>
                  </tr>
                <%} %>
                <%if(idaflag.equalsIgnoreCase("true")){ %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">2.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq2" size="20" maxlength="30" readonly = 'true' />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq2" size="20" maxlength="30" readonly = 'true' />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow2" size="20" maxlength="20" readonly = 'true' />
                    <html:checkbox name="viewAppTACEquipData" property="strCMTRangflg2" />
                  </td>
                </tr>
                <%} if(idaflag.equalsIgnoreCase("false")){ %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">2.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq2" size="20" maxlength="30" />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq2" size="20" maxlength="30" />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow2" size="20" maxlength="20" />
                  </td>
                </tr>
                 <%} %>
                <!-- 20090109 ends here -->
                <!--20090611 William TLS08-08-003: aditional fields -->
                <%if(idaflag.equalsIgnoreCase("true")){ %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">3.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq3" size="20" maxlength="30" readonly = 'true' />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq3" size="20" maxlength="30" readonly = 'true' />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow3" size="20" maxlength="20" readonly = 'true' />
                    <html:checkbox name="viewAppTACEquipData" property="strCMTRangflg3" />
                  </td>
                </tr>
                <%} if(idaflag.equalsIgnoreCase("false")){ %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">3.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq3" size="20" maxlength="30" />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq3" size="20" maxlength="30" />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow3" size="20" maxlength="20" />
                  </td>
                </tr>
                <%} %>
                <%if(idaflag.equalsIgnoreCase("true")){ %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">4.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq4" size="20" maxlength="30" readonly = 'true'/>
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq4" size="20" maxlength="30" readonly = 'true'/>
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow4" size="20" maxlength="20" readonly = 'true'/>
                    <html:checkbox name="viewAppTACEquipData" property="strCMTRangflg4" />
                  </td>
                </tr>
                <%} if(idaflag.equalsIgnoreCase("false")){ %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">4.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq4" size="20" maxlength="30" />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq4" size="20" maxlength="30" />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow4" size="20" maxlength="20" />
                  </td>
                </tr>
                <%} %>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">5.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                    <html:text name="viewAppTACEquipData" property="strRdTxFreq5" size="20" maxlength="30" />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq5" size="20" maxlength="30" />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow5" size="20" maxlength="20" />
                  </td>
                </tr>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">6.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                    <html:text name="viewAppTACEquipData" property="strRdTxFreq6" size="20" maxlength="30" />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq6" size="20" maxlength="30" />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow6" size="20" maxlength="20" />
                  </td>
                </tr>
                <tr> 
                  <td width="22%" height="16" valign="middle" class="h3"> 
                    <div align="right">7.&nbsp;</div>
                  </td>
                  <td width="27%" height="16" valign="middle" class="h3"> 
                   <html:text name="viewAppTACEquipData" property="strRdTxFreq7" size="20" maxlength="30" />
                  </td>
                  <td width="25%" class="txtLabel"> 
                    <html:text name="viewAppTACEquipData" property="strRdRxFreq7" size="20" maxlength="30" />
                  </td>
                  <td colspan="2" height="16" valign="middle" class="h3" width="26%"> 
                    <html:text name="viewAppTACEquipData" property="strRdRfOutputPow7" size="20" maxlength="20" />
                  </td>
                </tr>
                <!--20090611 William TLS08-08-003: aditional fields - end -->
                <!-- 20170821 Add more fields for Equipment Technical data -->
                <tr> 
                  <td width="20%"   valign="middle" class="h3"> 
                    <div align="right">8.&nbsp;</div>
                  </td>
                  <td width="25%"   valign="middle" class="h3"> 
			        <html:text name="equipmentInfo" property="strRdTxFreq8" size="20" maxlength="30"/>
                  </td>
                  <td width="25%" class="txtLabel"> 
			        <html:text name="equipmentInfo" property="strRdRxFreq8" size="20" maxlength="30"/>
                  </td>
                  <td colspan="2"   valign="middle" class="h3" width="26%"> 
      			    <html:text name="equipmentInfo" property="strRdRfOutputPow8" size="20" maxlength="20"/>
                  </td>
                </tr>
                <tr> 
                  <td width="20%"   valign="middle" class="h3"> 
                    <div align="right">9.&nbsp;</div>
                  </td>
                  <td width="25%"   valign="middle" class="h3"> 
			        <html:text name="equipmentInfo" property="strRdTxFreq9" size="20" maxlength="30"/>
                  </td>
                  <td width="25%" class="txtLabel"> 
			        <html:text name="equipmentInfo" property="strRdRxFreq9" size="20" maxlength="30"/>
                  </td>
                  <td colspan="2"   valign="middle" class="h3" width="26%"> 
      			    <html:text name="equipmentInfo" property="strRdRfOutputPow9" size="20" maxlength="20"/>
                  </td>
                </tr>
                <tr> 
                  <td width="20%"   valign="middle" class="h3"> 
                    <div align="right">10.&nbsp;</div>
                  </td>
                  <td width="25%"   valign="middle" class="h3"> 
			        <html:text name="equipmentInfo" property="strRdTxFreq10" size="20" maxlength="30"/>
                  </td>
                  <td width="25%" class="txtLabel"> 
			        <html:text name="equipmentInfo" property="strRdRxFreq10" size="20" maxlength="30"/>
                  </td>
                  <td colspan="2"   valign="middle" class="h3" width="26%"> 
      			    <html:text name="equipmentInfo" property="strRdRfOutputPow10" size="20" maxlength="20"/>
                  </td>
                </tr>
                <tr> 
                  <td width="20%"   valign="middle" class="h3"> 
                    <div align="right">11.&nbsp;</div>
                  </td>
                  <td width="25%"   valign="middle" class="h3"> 
			        <html:text name="equipmentInfo" property="strRdTxFreq11" size="20" maxlength="30"/>
                  </td>
                  <td width="25%" class="txtLabel"> 
			        <html:text name="equipmentInfo" property="strRdRxFreq11" size="20" maxlength="30"/>
                  </td>
                  <td colspan="2"   valign="middle" class="h3" width="26%"> 
      			    <html:text name="equipmentInfo" property="strRdRfOutputPow11" size="20" maxlength="20"/>
                  </td>
                </tr>
                <tr> 
                  <td width="20%"   valign="middle" class="h3"> 
                    <div align="right">12.&nbsp;</div>
                  </td>
                  <td width="25%"   valign="middle" class="h3"> 
			        <html:text name="equipmentInfo" property="strRdTxFreq12" size="20" maxlength="30"/>
                  </td>
                  <td width="25%" class="txtLabel"> 
			        <html:text name="equipmentInfo" property="strRdRxFreq12" size="20" maxlength="30"/>
                  </td>
                  <td colspan="2"   valign="middle" class="h3" width="26%"> 
      			    <html:text name="equipmentInfo" property="strRdRfOutputPow12" size="20" maxlength="20"/>
                  </td>
                </tr>
                <tr> 
                  <td width="20%"   valign="middle" class="h3"> 
                    <div align="right">13.&nbsp;</div>
                  </td>
                  <td width="25%"   valign="middle" class="h3"> 
			        <html:text name="equipmentInfo" property="strRdTxFreq13" size="20" maxlength="30"/>
                  </td>
                  <td width="25%" class="txtLabel"> 
			        <html:text name="equipmentInfo" property="strRdRxFreq13" size="20" maxlength="30"/>
                  </td>
                  <td colspan="2"   valign="middle" class="h3" width="26%"> 
      			    <html:text name="equipmentInfo" property="strRdRfOutputPow13" size="20" maxlength="20"/>
                  </td>
                </tr>
                <tr> 
                  <td width="20%"   valign="middle" class="h3"> 
                    <div align="right">14.&nbsp;</div>
                  </td>
                  <td width="25%"   valign="middle" class="h3"> 
			        <html:text name="equipmentInfo" property="strRdTxFreq14" size="20" maxlength="30"/>
                  </td>
                  <td width="25%" class="txtLabel"> 
			        <html:text name="equipmentInfo" property="strRdRxFreq14" size="20" maxlength="30"/>
                  </td>
                  <td colspan="2"   valign="middle" class="h3" width="26%"> 
      			    <html:text name="equipmentInfo" property="strRdRfOutputPow14" size="20" maxlength="20"/>
                  </td>
                </tr>
                <tr> 
                  <td width="20%"   valign="middle" class="h3"> 
                    <div align="right">15.&nbsp;</div>
                  </td>
                  <td width="25%"   valign="middle" class="h3"> 
			        <html:text name="equipmentInfo" property="strRdTxFreq15" size="20" maxlength="30"/>
                  </td>
                  <td width="25%" class="txtLabel"> 
			        <html:text name="equipmentInfo" property="strRdRxFreq15" size="20" maxlength="30"/>
                  </td>
                  <td colspan="2"   valign="middle" class="h3" width="26%"> 
      			    <html:text name="equipmentInfo" property="strRdRfOutputPow15" size="20" maxlength="20"/>
                  </td>
                </tr>
                <!-- 20170821 End -->
                <tr> 
                  <td colspan="5" height="16" valign="middle" class="h3"> 
                    <table border="0" cellspacing="0" width="100%" cellpadding="1">
                      <tr> 
                        <td width="22%" height="16" valign="middle" class="h3">Channel 
                          Spacing</td>
                        <td width="27%" class="txtLabel"> 
                          <html:text name="viewAppTACEquipData" property="strRdCnlSpa" size="20" maxlength="50" />
                        </td>
                        <td width="25%" height="16" valign="middle" class="h3">No. 
                          of Channels</td>
                        <td width="26%"> 
                          <html:text name="viewAppTACEquipData" property="strRdNoCnl" size="20" maxlength="5" />
                        </td>
                      </tr>
                      <tr> 
                        <td width="22%" height="16" valign="middle" class="h3">Modulation 
                          Type</td>
                        <td width="27%" class="txtLabel"> 
                          <html:text name="viewAppTACEquipData" property="strModType" size="20" maxlength="50" />
                        </td>
                        <td width="25%" height="16" valign="middle" class="h3">TAC 
                          No. (GSM eqpt)</td>
                        <td width="26%"> 
                          <html:text name="viewAppTACEquipData" property="strTACNoGSMEquip" size="20" maxlength="50" />
                        </td>
                      </tr>
                      <tr> 
                        <td width="22%" height="16" valign="middle" class="h3">SAR 
                          Value W/kg @ 10g</td>
                        <td width="27%" class="txtLabel"> 
							<html:text name="viewAppTACEquipData" property="strSARValue" size="20" maxlength="50" />
                        </td>
                        <td width="25%" height="16" valign="middle" class="h3">&nbsp;</td>
                        <td width="26%">&nbsp; </td>
                      </tr>
                      <!--20090625 William TLS08-08-003: aditional fields -->
                      <tr>
                          <td width="22%" height="16" valign="middle" class="h3"> 
                              Remarks
                          </td>
                          <!-- 20100409 Kanaga: Extend the Remarks entry textarea to copy & paste Freq & Power. -->
                          <td colspan="3" height="59" valign="middle" class="txtLabel"> 
				              <html:textarea cols="60" rows="4" name="viewAppTACEquipData" property="strRdFreqRemarks" 
							      onkeyup="checkLength(this,200)" >
							  </html:textarea>
				          </td>
                      </tr> 
                      <!--20090625 William TLS08-08-003: aditional fields -->
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
		  </logic:notEqual> 
        </table>
        <div align="center"> 
          <table border="0" cellspacing="0" cellpadding="5">
            <tr> 
              <td width="76" height="34">
				<img width="78" height="20" border="0" src="<%=TlsConfigMgr.strIMG%>btn_back.jpg" onclick="return clickBack();"/>
			  </td>
			  <logic:notEqual name="headerStationDetails" property="strHidButton" value="Y">
			   <%
                  String strAmendEqptRegnAuthAccessFlagSet = (String)request.getAttribute("setAmendEqptRegnAuthAccessFlag");
  				  String strStsCd = ((TlsAppTACEquipInfoHdrDTO)request.getAttribute("headerStationDetails")).getStrLicStsCd();
				  System.out.println("\n\n ####### strAmendEqptRegnAuthAccessFlagSet: "+strAmendEqptRegnAuthAccessFlagSet+" strStsCd: "+strStsCd);
			   %>
			    <% if ( strStsCd.equals("NL") || strStsCd.equals("RR")){ 
                    if("Y".equals(strAmendEqptRegnAuthAccessFlagSet)){%>
					  <td width="78" height="34">
						<img width="78" height="20" border="0" src="<%=TlsConfigMgr.strIMG%>btn_save.jpg" name="save" onclick="return clickSave();"/>
					  </td>
					  <td width="78" height="34">
						<img width="78" height="20" border="0" src="<%=TlsConfigMgr.strIMG%>btn_clear.jpg" onClick="return reset();"/>
					  </td>
				  <%}
				 }else{%>
				  <td width="78" height="34">
					<img width="78" height="20" border="0" src="<%=TlsConfigMgr.strIMG%>btn_save.jpg" name="save" onclick="return clickSave();"/>
				  </td>
				  <td width="78" height="34">
					<img width="78" height="20" border="0" src="<%=TlsConfigMgr.strIMG%>btn_clear.jpg" onClick="return reset();"/>
				  </td>
			  <%}%>
			  </logic:notEqual>
            </tr>
          </table>
        </div>
      </td>
    </tr>
  </table>
<input type="hidden" name="<%=TlsGlobals.PARAM_LIC_TYPE_ACCESS%>" value='<bean:write name="headerStationDetails" property="strLicTypeCd"/>'/>
<input type="hidden" name="strCreBy"  value="<%=session.getAttribute(TlsConfig.USERID)%>"/>
<input type="hidden" name="strUpdBy"  value="<%=session.getAttribute(TlsConfig.USERID)%>"/>
<html:hidden property="dispatch"/>
<html:hidden name="viewAppTACEquipData" property="strSlNo"/>
<html:hidden property="pgfwd" />
<html:hidden property="strProgUnderCd" />
    
</html:form>
</body>
</html:html>
