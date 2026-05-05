<%-- 
    Document   : refund_status_return
    Created on : Refund Status API
    Author     : Easebuzz
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.regex.*" %>

<%@ include file="config.jsp" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/style.css">
    <title>Refund Status Response</title>
</head>
<body>
    <div class="grid-container">
        <header class="wrapper">
            <div class="logo">
                <a href="#">
                    <img src="assets/images/Easebuzz_Logo_ White_Text.svg" alt="Easebuzz">
                </a>
            </div>
            <div class="hedding">
                <h2><a class="highlight" href="/Easebuzz_javaKit/refund_status.jsp">Back</a></h2>
            </div>
        </header>
    </div>

    <div class="form-container">
        <h2>REFUND STATUS API RESPONSE</h2>
        <hr>

    <%
        String merchantKey = getMerchantKey();
        String saltValue = getSalt();
        String apiEndpoint = getRefundStatusUrl();
        
        String easebuzzId = clean(request.getParameter("easebuzz_id"));
        String merchantRefundId = clean(request.getParameter("merchant_refund_id"));
        
        String apiResponse = "";
        String errorMessage = "";
        int httpStatus = 0;
        
        try {
            if (empty(easebuzzId)) throw new Exception("Easebuzz ID is required");

            if (!empty(easebuzzId) && !Pattern.matches("^[a-zA-Z0-9]*$", easebuzzId)) throw new Exception("Invalid Easebuzz ID format");
            if (!empty(merchantRefundId) && !Pattern.matches("^[a-zA-Z0-9_-]*$", merchantRefundId)) throw new Exception("Invalid Merchant Refund ID format");

            Map<String, String> params = new HashMap<String, String>();
            params.put("key", merchantKey);
            params.put("easebuzz_id", easebuzzId);
            params.put("hash", generateHash(merchantKey + "|" + easebuzzId + "|" + saltValue));
            if (!empty(merchantRefundId)) params.put("merchant_refund_id", merchantRefundId);

            String[] result = postFormRequest(apiEndpoint, params);
            httpStatus = Integer.parseInt(result[RESPONSE_CODE]);
            apiResponse = result[RESPONSE_BODY];
            errorMessage = result[RESPONSE_ERROR];
            
        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
        }

        request.setAttribute("easebuzzId", easebuzzId);
        request.setAttribute("merchantRefundId", merchantRefundId);
        setResponseAttributes(request, apiEndpoint, httpStatus, apiResponse, errorMessage);
    %>

        <div class="response-container">
            <h3>Request Details:</h3>
            <p><strong>Easebuzz ID:</strong> <c:out value="${easebuzzId}"/></p>
            <c:if test="${not empty merchantRefundId}">
            <p><strong>Merchant Refund ID:</strong> <c:out value="${merchantRefundId}"/></p>
            </c:if>
            <p><strong>API URL:</strong> <c:out value="${apiUrl}"/></p>
            <p><strong>Response Code:</strong> <c:out value="${responseCode}"/></p>
            
            <c:if test="${not empty errorMessage}">
                <div class="error-message" style="background-color: #ffebee; border: 1px solid #f44336; padding: 15px; margin: 10px 0; border-radius: 4px; color: #c62828;">
                    <h3>Error:</h3>
                    <p><c:out value="${errorMessage}"/></p>
                </div>
            </c:if>
            
            <c:if test="${not empty responseData}">
                <div style="background-color: ${isApiSuccess ? '#e8f5e8' : '#ffebee'}; border: 1px solid ${isApiSuccess ? '#4caf50' : '#f44336'}; padding: 15px; margin: 10px 0; border-radius: 4px; ${isApiSuccess ? '' : 'color: #c62828;'}">
                    <h3>API Response (JSON):</h3>
                    <c:choose>
                        <c:when test="${not empty formattedJson}">
                            <pre style="background-color: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.4; color: #000;"><c:out value="${formattedJson}"/></pre>
                        </c:when>
                        <c:otherwise>
                            <p><em>Raw Response (Not valid JSON):</em></p>
                            <pre style="background-color: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto; font-family: 'Courier New', monospace; color: #000;"><c:out value="${responseData}"/></pre>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
            
            <c:if test="${empty responseData and empty errorMessage}">
                <div class="info-message" style="background-color: #fff3cd; border: 1px solid #ffc107; padding: 15px; margin: 10px 0; border-radius: 4px; color: #856404;">
                    <p>No response received from the API.</p>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
