<%-- 
    Document   : transaction_date_return
    Created on : 29 Jun, 2018, 1:54:25 PM
    Author     : Easebuzz
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ include file="config.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/style.css">
    <title>Transaction Date Response</title>
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
                <h2><a class="highlight" href="/Easebuzz_javaKit/transactionDate.jsp">Back</a></h2>
            </div>
        </header>
    </div>

    <div class="form-container">
        <h2>TRANSACTION DATE RESPONSE</h2>
        <hr>

    <%
        String merchantKey = getMerchantKey();
        String saltValue = getSalt();
        String apiEndpoint = getTransactionDateUrl();
        
        String merchantEmail = clean(request.getParameter("merchant_email"));
        String startDate = clean(request.getParameter("start_date"));
        String endDate = clean(request.getParameter("end_date"));
        String submerchantId = clean(request.getParameter("submerchant_id"));
        
        String apiResponse = "";
        String errorMessage = "";
        int httpStatus = 0;
        
        try {
            if (empty(merchantEmail)) throw new Exception("Merchant email is required");
            if (empty(startDate)) throw new Exception("Start date is required");
            if (empty(endDate)) throw new Exception("End date is required");

            String hash = generateHash(merchantKey + "|" + merchantEmail + "|" + startDate + "|" + endDate + "|" + saltValue);
            
            JSONObject dateRange = new JSONObject();
            dateRange.put("start_date", startDate);
            dateRange.put("end_date", endDate);

            JSONObject payload = new JSONObject();
            payload.put("key", merchantKey);
            payload.put("merchant_email", merchantEmail);
            payload.put("hash", hash);
            payload.put("date_range", dateRange);
            if (!empty(submerchantId)) payload.put("submerchant_id", submerchantId);
            
            String[] result = postJsonRequest(apiEndpoint, payload.toJSONString());
            httpStatus = Integer.parseInt(result[RESPONSE_CODE]);
            apiResponse = result[RESPONSE_BODY];
            errorMessage = result[RESPONSE_ERROR];
            
        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
        }

        request.setAttribute("merchantEmail", merchantEmail);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("submerchantId", submerchantId);
        setResponseAttributes(request, apiEndpoint, httpStatus, apiResponse, errorMessage);
    %>

        <div class="response-container">
            <h3>Request Details:</h3>
            <p><strong>Merchant Email:</strong> <c:out value="${merchantEmail}"/></p>
            <p><strong>Start Date:</strong> <c:out value="${startDate}"/></p>
            <p><strong>End Date:</strong> <c:out value="${endDate}"/></p>
            <c:if test="${not empty submerchantId}">
                <p><strong>Sub Merchant ID:</strong> <c:out value="${submerchantId}"/></p>
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
