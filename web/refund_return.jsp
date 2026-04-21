<%-- 
    Document   : refund_return
    Created on : Refund API V2 Response
    Author     : Easebuzz
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.*"%>
<%@page import="java.io.PrintStream"%>
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
<%@ page import="java.util.regex.*" %>
<%@page import="javax.net.*" %>
<%@page import ="org.json.simple.JSONObject" %>
<%@page import ="org.json.simple.parser.*" %>
<%@page import ="java.io.FileReader" %>

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
    <title>Refund Response</title>
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
                <h2><a class="highlight" href="/Easebuzz_javaKit/refund.jsp">Back</a></h2>
            </div>
        </header>
    </div>

    <div class="form-container">
        <h2>REFUND API V2 RESPONSE</h2>
        <hr>

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
        public String clean(String s) {
            if (s == null) return "";
            return s.trim();
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

    <%!
        public boolean validateParams(String merchantRefundId, String easebuzzId, String refundAmount, String udf1, String udf2, String udf3, String udf4, String udf5, String udf6, String udf7, String splitLabels) {
            Pattern merchantRefundIdPattern = Pattern.compile("^[a-zA-Z0-9_-]*$");
            Pattern easebuzzIdPattern = Pattern.compile("^[a-zA-Z0-9]*$");
            Pattern amountPattern = Pattern.compile("^[0-9]+(\\.[0-9]+)?$");
            Pattern udfPattern = Pattern.compile("^[a-zA-Z\\.0-9/\\\\,\\s_#@\\-=+&]*$");
            
            if (merchantRefundId != null && !merchantRefundId.trim().isEmpty() && !merchantRefundIdPattern.matcher(merchantRefundId).matches()) return false;
            if (easebuzzId != null && !easebuzzId.trim().isEmpty() && !easebuzzIdPattern.matcher(easebuzzId).matches()) return false;
            if (refundAmount != null && !refundAmount.trim().isEmpty() && !amountPattern.matcher(refundAmount).matches()) return false;
            if (udf1 != null && !udf1.trim().isEmpty() && !udfPattern.matcher(udf1).matches()) return false;
            if (udf2 != null && !udf2.trim().isEmpty() && !udfPattern.matcher(udf2).matches()) return false;
            if (udf3 != null && !udf3.trim().isEmpty() && !udfPattern.matcher(udf3).matches()) return false;
            if (udf4 != null && !udf4.trim().isEmpty() && !udfPattern.matcher(udf4).matches()) return false;
            if (udf5 != null && !udf5.trim().isEmpty() && !udfPattern.matcher(udf5).matches()) return false;
            if (udf6 != null && !udf6.trim().isEmpty() && !udfPattern.matcher(udf6).matches()) return false;
            if (udf7 != null && !udf7.trim().isEmpty() && !udfPattern.matcher(udf7).matches()) return false;
            
            // Validate split_labels as JSON if provided
            if (splitLabels != null && !splitLabels.trim().isEmpty()) {
                try {
                    JSONParser parser = new JSONParser();
                    Object obj = parser.parse(splitLabels);
                    if (!(obj instanceof JSONObject)) {
                        return false;
                    }
                    JSONObject jsonObj = (JSONObject) obj;
                    // Validate that all values are numbers
                    for (Object key : jsonObj.keySet()) {
                        Object value = jsonObj.get(key);
                        if (!(value instanceof Number)) {
                            try {
                                Double.parseDouble(value.toString());
                            } catch (NumberFormatException e) {
                                return false;
                            }
                        }
                    }
                } catch (Exception e) {
                    return false;
                }
            }
            
            return true;
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
                return "Error generating hash: " + nsae.getMessage();
            }
            return hexString.toString();
        }
    %>

    <%
        String key = getMerchantKey();
        String salt = getSalt();
        String base_url = getRefundUrl();
        
        String merchant_refund_id = clean(request.getParameter("merchant_refund_id"));
        String easebuzz_id = clean(request.getParameter("easebuzz_id"));
        String refund_amount = clean(request.getParameter("refund_amount"));
        String udf1 = clean(request.getParameter("udf1"));
        String udf2 = clean(request.getParameter("udf2"));
        String udf3 = clean(request.getParameter("udf3"));
        String udf4 = clean(request.getParameter("udf4"));
        String udf5 = clean(request.getParameter("udf5"));
        String udf6 = clean(request.getParameter("udf6"));
        String udf7 = clean(request.getParameter("udf7"));
        String split_labels = clean(request.getParameter("split_labels"));
        
        String responseData = "";
        String errorMessage = "";
        int responseCode = 0;
        
        try {
            if (empty(merchant_refund_id) || empty(easebuzz_id) || empty(refund_amount)) {
                throw new Exception("Merchant Refund ID, Easebuzz Transaction ID, and Refund Amount are required");
            }

            // Validate refund_amount is in decimal/float format
            if (!refund_amount.contains(".")) {
                throw new Exception("Refund Amount must be in decimal format (e.g., 125.00)");
            }

            if (!validateParams(merchant_refund_id, easebuzz_id, refund_amount, udf1, udf2, udf3, udf4, udf5, udf6, udf7, split_labels)) {
                throw new Exception("Invalid parameter format");
            }

            // Build parameters
            Map<String, String> params = new HashMap<String, String>();
            params.put("key", key);
            params.put("merchant_refund_id", merchant_refund_id);
            params.put("easebuzz_id", easebuzz_id);
            params.put("refund_amount", refund_amount);
            
            if (!empty(udf1)) params.put("udf1", udf1);
            if (!empty(udf2)) params.put("udf2", udf2);
            if (!empty(udf3)) params.put("udf3", udf3);
            if (!empty(udf4)) params.put("udf4", udf4);
            if (!empty(udf5)) params.put("udf5", udf5);
            if (!empty(udf6)) params.put("udf6", udf6);
            if (!empty(udf7)) params.put("udf7", udf7);
            if (!empty(split_labels)) params.put("split_labels", split_labels);
            
            // Generate hash: key|merchant_refund_id|easebuzz_id|refund_amount|salt
            String hashString = key + "|" + merchant_refund_id + "|" + easebuzz_id + "|" + refund_amount + "|" + salt;
            String hash = Easebuzz_Generatehash512("SHA-512", hashString);
            params.put("hash", hash);

            // Build POST data
            StringBuilder sb = new StringBuilder();
            for (Map.Entry<String, String> e : params.entrySet()) {
                if (sb.length() > 0) {
                    sb.append('&');
                }
                sb.append(URLEncoder.encode(e.getKey().trim(), "UTF-8")).append('=').append(URLEncoder.encode(e.getValue().trim(), "UTF-8"));
            }
            
            // Make API call
            URL url = new URL(base_url);
            HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            con.setDoOutput(true);
            
            PrintStream ps = new PrintStream(con.getOutputStream());
            ps.print(sb.toString());
            ps.close();
            
            responseCode = con.getResponseCode();
            
            // Read response
            StringBuilder res = new StringBuilder();
            if (responseCode == HttpsURLConnection.HTTP_OK) {
                BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
                String line;
                while ((line = br.readLine()) != null) {
                    res.append(line);
                }
                br.close();
                responseData = res.toString();
            } else {
                // Read error response
                BufferedReader br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
                String line;
                while ((line = br.readLine()) != null) {
                    res.append(line);
                }
                br.close();
                errorMessage = "HTTP Error " + responseCode + ": " + res.toString();
            }
            con.disconnect();
            
        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
            e.printStackTrace();
        }
    %>

        <div class="response-container">
            <h3>Request Details:</h3>
            <p><strong>Merchant Refund ID:</strong> <%= merchant_refund_id %></p>
            <p><strong>Easebuzz Transaction ID:</strong> <%= easebuzz_id %></p>
            <p><strong>Refund Amount:</strong> <%= refund_amount %></p>
            <% if (!empty(split_labels)) { %>
            <p><strong>Split Labels:</strong> <%= split_labels %></p>
            <% } %>
            <p><strong>API URL:</strong> <%= base_url %></p>
            <p><strong>Response Code:</strong> <%= responseCode %></p>
            
            <% if (!empty(errorMessage)) { %>
                <div class="error-message" style="background-color: #ffebee; border: 1px solid #f44336; padding: 15px; margin: 10px 0; border-radius: 4px; color: #c62828;">
                    <h3>Error:</h3>
                    <p><%= errorMessage %></p>
                </div>
            <% } %>
            
            <% if (!empty(responseData)) { 
                boolean isApiSuccess = false;
                try {
                    JSONParser statusParser = new JSONParser();
                    JSONObject statusObj = (JSONObject) statusParser.parse(responseData);
                    Object statusVal = statusObj.get("status");
                    if (statusVal != null) {
                        isApiSuccess = statusVal.toString().equals("1") || statusVal.toString().equalsIgnoreCase("true");
                    }
                } catch (Exception ex) {}
            %>
                <div style="background-color: <%= isApiSuccess ? "#e8f5e8" : "#ffebee" %>; border: 1px solid <%= isApiSuccess ? "#4caf50" : "#f44336" %>; padding: 15px; margin: 10px 0; border-radius: 4px; <%= isApiSuccess ? "" : "color: #c62828;" %>">
                    <h3>API Response (JSON):</h3>
                    <%
                        try {
                            JSONParser parser = new JSONParser();
                            Object obj = parser.parse(responseData);
                            JSONObject jsonObject = (JSONObject) obj;
                            String formattedJson = formatJson(jsonObject.toJSONString(), 0).replace("\\/", "/");
                    %>
                        <pre style="background-color: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.4; color: #000;"><%= formattedJson %></pre>
                    <%
                        } catch (Exception jsonEx) {
                    %>
                        <p><em>Raw Response (Not valid JSON):</em></p>
                        <pre style="background-color: #f5f5f5; padding: 15px; border-radius: 4px; overflow-x: auto; font-family: 'Courier New', monospace; color: #000;"><%= responseData %></pre>
                    <%
                        }
                    %>
                </div>
            <% } %>
            
            <% if (empty(responseData) && empty(errorMessage)) { %>
                <div class="info-message" style="background-color: #fff3cd; border: 1px solid #ffc107; padding: 15px; margin: 10px 0; border-radius: 4px; color: #856404;">
                    <p>No response received from the API.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>