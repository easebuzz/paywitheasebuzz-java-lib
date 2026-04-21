<%@ include file="config.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Config Test</title>
</head>
<body>
    <h1>Configuration Test</h1>
    <p>Merchant Key: <%= EasebuzzConfig.getMerchantKey() %></p>
    <p>Salt: <%= EasebuzzConfig.getSalt() %></p>
    <p>Environment: <%= EasebuzzConfig.getEnvironment() %></p>
    <p>Payment Base URL: <%= EasebuzzConfig.getPaymentBaseUrl() %></p>
    <p>Initiate Payment URL: <%= EasebuzzConfig.getInitiatePaymentUrl() %></p>
</body>
</html>