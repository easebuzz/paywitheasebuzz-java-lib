<%-- 
    Document   : response
    Created on : 23 May, 2018, 6:41:07 PM
    Author     : Easebuzz
--%>
<%@page import="java.util.Map"%>
<%@page import="org.json.*"%>
<%@page import="java.io.PrintStream"%>
<%@page import="javax.net.ssl.SSLContext"%>
<%@page import="java.io.InputStream"%>
<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@ page import="java.util.*" %>
<%@ page import="java.security.*" %>
<%@page import="javax.net.ssl.X509TrustManager"%>
<%@page import="javax.net.ssl.TrustManager" %>
<%@page import="javax.net.*" %>
<%@page import ="org.json.simple.JSONObject" %>
<%@page import ="org.json.simple.parser.*" %>
<%@page import ="java.io.FileReader" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ include file="config.jsp" %>

    <%!
        public boolean empty(String s) {
            if (s == null || s.trim().equals("")) {
                return true;
            } else {
                return false;
            }
        }
    %>

    <%!
        public String Easebuzz_Generatehash512(String type, String str) {
            byte[] hashseq = str.getBytes();
            StringBuffer hexString = new StringBuffer();
            try {
                MessageDigest algorithm = MessageDigest.getInstance(type);
                algorithm.reset();
                algorithm.update(hashseq);
                byte messageDigest[] = algorithm.digest();

                for (int i = 0; i < messageDigest.length; i++) {
                    String hex = Integer.toHexString(0xFF & messageDigest[i]);
                    if (hex.length() == 1) {
                        hexString.append("0");
                    }
                    hexString.append(hex);
                }

            } catch (NoSuchAlgorithmException nsae) {
            }
            return hexString.toString();
        }
    %>

    <%!
        public String formatJson(String json, int indent) {
            StringBuilder formatted = new StringBuilder();
            int indentLevel = 0;
            boolean inQuotes = false;
            
            for (int i = 0; i < json.length(); i++) {
                char ch = json.charAt(i);
                
                switch (ch) {
                    case '"':
                        formatted.append(ch);
                        if (i > 0 && json.charAt(i - 1) != '\\') {
                            inQuotes = !inQuotes;
                        }
                        break;
                    case '{':
                    case '[':
                        formatted.append(ch);
                        if (!inQuotes) {
                            formatted.append('\n');
                            indentLevel++;
                            addIndent(formatted, indentLevel);
                        }
                        break;
                    case '}':
                    case ']':
                        if (!inQuotes) {
                            formatted.append('\n');
                            indentLevel--;
                            addIndent(formatted, indentLevel);
                        }
                        formatted.append(ch);
                        break;
                    case ',':
                        formatted.append(ch);
                        if (!inQuotes) {
                            formatted.append('\n');
                            addIndent(formatted, indentLevel);
                        }
                        break;
                    case ':':
                        formatted.append(ch);
                        if (!inQuotes) {
                            formatted.append(' ');
                        }
                        break;
                    default:
                        formatted.append(ch);
                        break;
                }
            }
            return formatted.toString();
        }
        
        private void addIndent(StringBuilder sb, int indentLevel) {
            for (int i = 0; i < indentLevel * 2; i++) {
                sb.append(' ');
            }
        }
    %>

    <%
        String salt = getSalt();
        String errorMessage = "";
        boolean hashValid = false;

        Enumeration paramNames = request.getParameterNames();
        Map<String, String> params = new HashMap<String, String>();
        while (paramNames.hasMoreElements()) {
            String paramName = (String) paramNames.nextElement();
            String paramValue = ((String) request.getParameter(paramName)).trim();
            params.put(paramName, paramValue);
        }

        Map<String, String[]> parameters = request.getParameterMap();
        for (String parameter : parameters.keySet()) {
            params.put(parameter, parameters.get(parameter)[0].toString());
        }

        try {
            params.put("salt", salt);
            params.put("status", request.getParameter("status"));

            // Reverse hash sequence
            String hashSequence = "salt|status|udf10|udf9|udf8|udf7|udf6|udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid";
            String hashString = "";
            String[] hashVarSeq = hashSequence.split("\\|");

            for (String part : hashVarSeq) {
                hashString = (empty(params.get(part))) ? hashString.concat("") : hashString.concat(params.get(part));
                hashString = hashString.concat("|");
            }
            hashString = hashString.concat(request.getParameter("key"));
            String hash = Easebuzz_Generatehash512("SHA-512", hashString);

            String responseHash = request.getParameter("hash");
            if (hash.trim().equals(responseHash.trim())) {
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
            if (!entry.getKey().equals("salt")) {
                responseJson.put(entry.getKey(), entry.getValue());
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
            <p><strong>Transaction ID:</strong> <%= params.get("txnid") != null ? params.get("txnid") : "" %></p>
            <p><strong>Amount:</strong> <%= params.get("amount") != null ? params.get("amount") : "" %></p>
            <p><strong>Status:</strong> <%= params.get("status") != null ? params.get("status") : "" %></p>
            <p><strong>Payment Mode:</strong> <%= params.get("mode") != null ? params.get("mode") : "" %></p>
            <p><strong>Easebuzz ID:</strong> <%= params.get("easepayid") != null ? params.get("easepayid") : "" %></p>
            <p><strong>Hash Valid:</strong> <%= hashValid ? "Yes" : "No" %></p>
            
            <% if (!empty(errorMessage)) { %>
                <div class="error-message" style="background-color: #ffebee; border: 1px solid #f44336; padding: 15px; margin: 10px 0; border-radius: 4px; color: #c62828;">
                    <h3>Error:</h3>
                    <p><%= errorMessage %></p>
                </div>
            <% } %>
            
            <% if (hashValid) { %>
                <div class="success-message" style="background-color: #e8f5e8; border: 1px solid #4caf50; padding: 15px; margin: 10px 0; border-radius: 4px;">
                    <h3>API Response (JSON):</h3>
                    <%
                        try {
                            String formattedJson = formatJson(responseJson.toJSONString(), 0).replace("\\/", "/");
                    %>
                        <pre style="background-color: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.4;"><%= formattedJson %></pre>
                    <%
                        } catch (Exception jsonEx) {
                    %>
                        <p><em>Raw Response:</em></p>
                        <pre style="background-color: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto; font-family: 'Courier New', monospace;"><%= responseJson.toJSONString() %></pre>
                    <%
                        }
                    %>
                </div>
            <% } %>
            
            <% if (!hashValid && empty(errorMessage)) { %>
                <div class="info-message" style="background-color: #fff3cd; border: 1px solid #ffc107; padding: 15px; margin: 10px 0; border-radius: 4px; color: #856404;">
                    <p>No response received from the API.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
