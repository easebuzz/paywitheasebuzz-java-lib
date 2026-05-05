<%@page import="java.util.regex.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8" buffer="64kb" autoFlush="false"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ include file="config.jsp" %>

    <%!
        public String validateParams(Map<String, String> params) {
            String[][] rules = {
                {"txnid", "^[a-zA-Z0-9_|\\-/]{1,40}$", "Invalid Transaction ID"},
                {"amount", "^[0-9.]*$", "Invalid Amount"},
                {"productinfo", "^[a-zA-Z0-9\\-\\s|\\-]{1,45}$", "Invalid Product Info"},
                {"firstname", "^[a-zA-Z0-9&\\-._ ()/,@]{1,150}$", "Invalid First Name"},
                {"phone", "^(\\+\\d{1,4}[-]?)?\\d{5,20}$", "Invalid Phone"},
                {"email", "^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$", "Invalid Email"}
            };
            for (String[] rule : rules) {
                String val = params.get(rule[0]);
                if (val != null && !val.isEmpty() && !Pattern.matches(rule[1], val)) {
                    return rule[2] + ": " + rule[0];
                }
            }
            String udfPattern = "^[a-zA-Z.0-9/\\\\,\\s_#@\\-=+&]{1,300}$";
            for (int i = 1; i <= 7; i++) {
                String val = params.get("udf" + i);
                if (val != null && !val.isEmpty() && !Pattern.matches(udfPattern, val)) {
                    return "Invalid UDF" + i;
                }
            }
            return null;
        }
    %>

    <%
        String merchantKey = getMerchantKey();
        String saltValue = getSalt();
        String paymentBaseUrl = getPaymentBaseUrl();
        String apiEndpoint = getInitiatePaymentUrl();
        
        // Collect non-empty params from form
        Enumeration paramNames = request.getParameterNames();
        Map<String, String> params = new HashMap<String, String>();
        while (paramNames.hasMoreElements()) {
            String paramName = (String) paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            if (paramValue != null && !paramValue.trim().isEmpty()) {
                params.put(paramName.trim(), paramValue.trim());
            }
        }
        params.put("key", merchantKey);

        String apiResponse = "";
        String errorMessage = "";
        int httpStatus = 0;
        
        String validationError = validateParams(params);
        if (validationError != null) {
            errorMessage = "Validation Error: " + validationError;
        } else {
            try {
                String amountVal = params.get("amount");
                if (amountVal != null && !amountVal.isEmpty() && !amountVal.contains(".")) {
                    throw new Exception("Validation Error: Amount must be in decimal format (e.g., 125.00)");
                }

                // Hash sequence: key|txnid|amount|productinfo|firstname|email|udf1..udf10|salt
                String[] hashParts = {"key", "txnid", "amount", "productinfo", "firstname", "email",
                                      "udf1", "udf2", "udf3", "udf4", "udf5", "udf6", "udf7", "udf8", "udf9", "udf10"};
                StringBuilder hashInput = new StringBuilder();
                for (String part : hashParts) {
                    String value = params.get(part);
                    if (value != null && !value.isEmpty()) hashInput.append(value);
                    hashInput.append("|");
                }
                hashInput.append(saltValue);
                params.put("hash", generateHash(hashInput.toString()));
                
                String[] result = postFormRequest(apiEndpoint, params);
                httpStatus = Integer.parseInt(result[RESPONSE_CODE]);
                apiResponse = result[RESPONSE_BODY];
                errorMessage = result[RESPONSE_ERROR];

                // On success, redirect to payment page
                if (!empty(apiResponse)) {
                    JSONObject responseJson = (JSONObject) new JSONParser().parse(apiResponse);
                    if (responseJson.get("status").toString().equals("1")) {
                        String accessKey = responseJson.get("data").toString();
                        String redirectUrl = paymentBaseUrl + "pay/" + accessKey;
                        if (!isValidRedirectUrl(redirectUrl)) {
                            throw new Exception("Invalid redirect URL");
                        }
                        out.clearBuffer();
                        response.sendRedirect(redirectUrl);
                        return;
                    } else {
                        errorMessage = "Payment initiation failed: " + responseJson.get("data").toString();
                        apiResponse = "";
                    }
                }
            } catch (Exception e) {
                errorMessage = "Error: " + e.getMessage();
            }
        }

        request.setAttribute("params", params);
        request.setAttribute("apiUrl", apiEndpoint);
        setResponseAttributes(request, apiEndpoint, httpStatus, apiResponse, errorMessage);
    %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/style.css">
    <title>Payment Initiation Response</title>
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
                <h2><a class="highlight" href="/Easebuzz_javaKit/initiatepayment.jsp">Back</a></h2>
            </div>
        </header>
    </div>

    <div class="form-container">
        <h2>PAYMENT INITIATION RESPONSE</h2>
        <hr>

        <div class="response-container">
            <h3>Request Details:</h3>
            <p><strong>Transaction ID:</strong> <c:out value="${params.txnid}" default=""/></p>
            <p><strong>Amount:</strong> <c:out value="${params.amount}" default=""/></p>
            <p><strong>Customer Name:</strong> <c:out value="${params.firstname}" default=""/></p>
            <p><strong>Email:</strong> <c:out value="${params.email}" default=""/></p>
            <p><strong>Phone:</strong> <c:out value="${params.phone}" default=""/></p>
            <p><strong>Product Info:</strong> <c:out value="${params.productinfo}" default=""/></p>
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
