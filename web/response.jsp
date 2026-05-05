<%-- 
    Document   : response
    Created on : 23 May, 2018, 6:41:07 PM
    Author     : Easebuzz
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ include file="config.jsp" %>

    <%
        String saltValue = getSalt();
        String errorMessage = "";
        boolean hashValid = false;

        Map<String, String> params = new HashMap<String, String>();
        Map<String, String[]> parameterMap = request.getParameterMap();
        for (String key : parameterMap.keySet()) {
            params.put(key, parameterMap.get(key)[0].trim());
        }

        try {
            params.put("salt", saltValue);
            params.put("status", request.getParameter("status"));

            // Reverse hash sequence
            String[] hashSequence = {"salt","status","udf10","udf9","udf8","udf7","udf6","udf5","udf4","udf3","udf2","udf1","email","firstname","productinfo","amount","txnid"};
            StringBuilder hashInput = new StringBuilder();
            for (String part : hashSequence) {
                String val = params.get(part);
                if (!empty(val)) hashInput.append(val);
                hashInput.append("|");
            }
            hashInput.append(request.getParameter("key"));

            String computedHash = generateHash(hashInput.toString());
            String responseHash = request.getParameter("hash");

            if (computedHash.equals(responseHash != null ? responseHash.trim() : "")) {
                hashValid = true;
            } else {
                errorMessage = "Hash verification failed. Response may have been tampered.";
            }
        } catch (Exception e) {
            errorMessage = "Error processing response: " + e.getMessage();
        }

        // Build JSON from response params for display
        JSONObject responseJson = new JSONObject();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (!"salt".equals(entry.getKey())) {
                responseJson.put(entry.getKey(), entry.getValue());
            }
        }

        request.setAttribute("params", params);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("hashValid", hashValid);

        if (hashValid) {
            try {
                request.setAttribute("formattedJson", formatJson(responseJson.toJSONString()).replace("\\/", "/"));
            } catch (Exception ex) {
                request.setAttribute("formattedJson", null);
                request.setAttribute("rawJson", responseJson.toJSONString());
            }
        }
    %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/style.css">
    <title>Payment Response</title>
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
                <h2><a class="highlight" href="/Easebuzz_javaKit/index.jsp">Back</a></h2>
            </div>
        </header>
    </div>

    <div class="form-container">
        <h2>PAYMENT RESPONSE</h2>
        <hr>

        <div class="response-container">
            <h3>Request Details:</h3>
            <p><strong>Transaction ID:</strong> <c:out value="${params.txnid}" default=""/></p>
            <p><strong>Amount:</strong> <c:out value="${params.amount}" default=""/></p>
            <p><strong>Status:</strong> <c:out value="${params.status}" default=""/></p>
            <p><strong>Payment Mode:</strong> <c:out value="${params.mode}" default=""/></p>
            <p><strong>Easebuzz ID:</strong> <c:out value="${params.easepayid}" default=""/></p>
            <p><strong>Hash Valid:</strong> <c:out value="${hashValid ? 'Yes' : 'No'}"/></p>
            
            <c:if test="${not empty errorMessage}">
                <div class="error-message" style="background-color: #ffebee; border: 1px solid #f44336; padding: 15px; margin: 10px 0; border-radius: 4px; color: #c62828;">
                    <h3>Error:</h3>
                    <p><c:out value="${errorMessage}"/></p>
                </div>
            </c:if>
            
            <c:if test="${hashValid}">
                <div class="success-message" style="background-color: #e8f5e8; border: 1px solid #4caf50; padding: 15px; margin: 10px 0; border-radius: 4px;">
                    <h3>API Response (JSON):</h3>
                    <c:choose>
                        <c:when test="${not empty formattedJson}">
                            <pre style="background-color: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.4;"><c:out value="${formattedJson}"/></pre>
                        </c:when>
                        <c:otherwise>
                            <p><em>Raw Response:</em></p>
                            <pre style="background-color: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto; font-family: 'Courier New', monospace;"><c:out value="${rawJson}"/></pre>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
            
            <c:if test="${not hashValid and empty errorMessage}">
                <div class="info-message" style="background-color: #fff3cd; border: 1px solid #ffc107; padding: 15px; margin: 10px 0; border-radius: 4px; color: #856404;">
                    <p>No response received from the API.</p>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
