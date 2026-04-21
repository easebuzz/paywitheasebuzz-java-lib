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
<%@ page import="java.util.regex.*" %>
<%@page import="javax.net.ssl.X509TrustManager"%>
<%@page import="javax.net.ssl.TrustManager" %>
<%@page import="javax.net.*" %>
<%@page import ="org.json.simple.JSONObject" %>
<%@page import ="org.json.simple.parser.*" %>
<%@page import ="java.io.FileReader" %>
<%@page import="javax.net.ssl.*" %>
<%@page import="java.security.cert.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8" buffer="64kb" autoFlush="false"%>

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
        public static void disableSSLVerification() {
            try {
                TrustManager[] trustAllCerts = new TrustManager[] {
                    new X509TrustManager() {
                        public X509Certificate[] getAcceptedIssuers() { return null; }
                        public void checkClientTrusted(X509Certificate[] certs, String authType) {}
                        public void checkServerTrusted(X509Certificate[] certs, String authType) {}
                    }
                };
                SSLContext sc = SSLContext.getInstance("SSL");
                sc.init(null, trustAllCerts, new java.security.SecureRandom());
                HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
                HostnameVerifier allHostsValid = new HostnameVerifier() {
                    public boolean verify(String hostname, SSLSession session) { return true; }
                };
                HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
            } catch (Exception e) {
                e.printStackTrace();
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
        String merchant_key = getMerchantKey();
        String salt = getSalt();
        String base_url = getPaymentBaseUrl();
        String env = getEnvironment();
        String apiUrl = getInitiatePaymentUrl();
        
        disableSSLVerification();

        // Collect non-empty params from form
        Enumeration paramNames = request.getParameterNames();
        Map<String, String> params = new HashMap<String, String>();
        while (paramNames.hasMoreElements()) {
            String paramName = (String) paramNames.nextElement();
            String paramValue = ((String) request.getParameter(paramName)).trim();
            if (paramValue != null && !paramValue.isEmpty()) {
                params.put(paramName, paramValue);
            }
        }

        params.put("key", merchant_key);

        String responseData = "";
        String errorMessage = "";
        int responseCode = 0;
        
        String validationError = validateParams(params);
        if (validationError != null) {
            errorMessage = "Validation Error: " + validationError;
        } else {
            try {
                // Validate amount is in decimal/float format
                String amountVal = params.get("amount");
                if (amountVal != null && !amountVal.isEmpty() && !amountVal.contains(".")) {
                    errorMessage = "Validation Error: Amount must be in decimal format (e.g., 125.00)";
                    throw new Exception(errorMessage);
                }
                // Fixed hash sequence: key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10|salt
                String[] hashParts = {"key", "txnid", "amount", "productinfo", "firstname", "email",
                                      "udf1", "udf2", "udf3", "udf4", "udf5", "udf6", "udf7", "udf8", "udf9", "udf10"};
                
                StringBuilder hashBuilder = new StringBuilder();
                for (String part : hashParts) {
                    String value = params.get(part);
                    if (value != null && !value.isEmpty()) {
                        hashBuilder.append(value);
                    }
                    hashBuilder.append("|");
                }
                hashBuilder.append(salt);
                String hash = Easebuzz_Generatehash512("SHA-512", hashBuilder.toString());
                params.put("hash", hash);

                // Never send udf8, udf9, udf10
                params.remove("udf8");
                params.remove("udf9");
                params.remove("udf10");
                
                // Build POST body with non-empty params only
                StringBuilder sb = new StringBuilder();
                for (Map.Entry<String, String> e : params.entrySet()) {
                    if (e.getValue() != null && !e.getValue().trim().isEmpty()) {
                        if (sb.length() > 0) {
                            sb.append('&');
                        }
                        sb.append(URLEncoder.encode(e.getKey().trim(), "UTF-8")).append('=').append(URLEncoder.encode(e.getValue().trim(), "UTF-8"));
                    }
                }

                URL url = new URL(apiUrl);
                HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
                con.setRequestMethod("POST");
                con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                con.setDoOutput(true);
                PrintStream ps = new PrintStream(con.getOutputStream());
                ps.print(sb.toString());
                ps.close();
                
                responseCode = con.getResponseCode();
                
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
                    BufferedReader br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
                    String line;
                    while ((line = br.readLine()) != null) {
                        res.append(line);
                    }
                    br.close();
                    errorMessage = "HTTP Error " + responseCode + ": " + res.toString();
                }
                con.disconnect();

                // On success, redirect to payment page
                if (!empty(responseData)) {
                    Object obj = new JSONParser().parse(responseData);
                    JSONObject jo = (JSONObject) obj;
                    if (jo.get("status").toString().equals("1")) {
                        out.clearBuffer();
                        response.sendRedirect(base_url + "pay/" + jo.get("data").toString());
                        return;
                    } else {
                        errorMessage = "Payment initiation failed: " + jo.get("data").toString();
                        responseData = "";
                    }
                }
            } catch (Exception e) {
                errorMessage = "Error: " + e.getMessage();
                e.printStackTrace();
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
            <p><strong>Transaction ID:</strong> <%= params.get("txnid") != null ? params.get("txnid") : "" %></p>
            <p><strong>Amount:</strong> <%= params.get("amount") != null ? params.get("amount") : "" %></p>
            <p><strong>Customer Name:</strong> <%= params.get("firstname") != null ? params.get("firstname") : "" %></p>
            <p><strong>Email:</strong> <%= params.get("email") != null ? params.get("email") : "" %></p>
            <p><strong>Phone:</strong> <%= params.get("phone") != null ? params.get("phone") : "" %></p>
            <p><strong>Product Info:</strong> <%= params.get("productinfo") != null ? params.get("productinfo") : "" %></p>
            <p><strong>API URL:</strong> <%= apiUrl %></p>
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
