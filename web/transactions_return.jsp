<%-- 
    Document   : transactions
    Created on : 24 May, 2018, 11:18:40 AM
    Author     : Easebuzz
--%>
<%@page import="org.json.*"%>
<%@page import="java.io.PrintStream"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="javax.net.ssl.X509TrustManager"%>
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

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/style.css">
    <title>Transaction Status Response</title>
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
                <h2><a class="highlight" href="/Easebuzz_javaKit/transactions.jsp">Back</a></h2>
            </div>
        </header>
    </div>

    <div class="form-container">
        <h2>TRANSACTION STATUS RESPONSE</h2>
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

<%@ include file="config.jsp" %>

    <%
        String merchant_key = getMerchantKey();
        String salt = getSalt();
        String env = getEnvironment();
        String base_url = "";
        if (env.equals("prod")) {
            base_url = "https://dashboard.easebuzz.in/transaction/v2.1/retrieve";
        } else {
            base_url = "https://testdashboard.easebuzz.in/transaction/v2.1/retrieve";
        }
        
        String txn_id = clean(request.getParameter("txnid"));    
        String responseData = "";
        String errorMessage = "";
        int responseCode = 0;
        
        try {
            if (empty(txn_id)) {
                throw new Exception("Transaction ID is required");
            }

            // Build parameters
            Map<String, String> params = new HashMap<String, String>();
            params.put("key", merchant_key);
            params.put("txnid", txn_id);
            
            // Generate hash: key|txnid|salt
            String hashString = merchant_key + "|" + txn_id + "|" + salt;
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
            <p><strong>Transaction ID:</strong> <%= txn_id %></p>
            <p><strong>API URL:</strong> <%= base_url %></p>
            <p><strong>Environment:</strong> <%= env %></p>
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

