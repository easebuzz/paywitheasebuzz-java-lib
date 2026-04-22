<%-- 
    Document   : return
    Created on : 29 Jun, 2018, 1:54:25 PM
    Author     : Easebuzz
--%>
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
<%@page import="javax.net.*" %>
<%@page import ="org.json.simple.JSONObject" %>
<%@page import ="org.json.simple.parser.*" %>
<%@page import ="java.io.FileReader" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
        String key = "XXXXXXX";
        String salt = "XXXXXX";
        String base_url = "https://dashboard.easebuzz.in/transaction/v1/retrieve/date";
        int error = 0;
        String merchant_email = request.getParameter("merchant_email");
        String transaction_date = request.getParameter("transaction_date");

    %>
    
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

<%        Enumeration paramNames = request.getParameterNames();
        Map<String, String> params = new HashMap<String, String>();
        while (paramNames.hasMoreElements()) {
            String paramName = (String) paramNames.nextElement();

            String paramValue = ((String) request.getParameter(paramName)).trim();
            params.put(paramName, paramValue);
        }
    %>
    
<%
            //main function to start transaction records date wise
            String hashString = "";
            String hash = "";
            String hashSequence = "merchant_key|merchant_email|transaction_date";
            params.put("merchant_email", merchant_email);
            params.put("transaction_date", transaction_date);
            params.put("merchant_key", key);
            String[] hashVarSeq = hashSequence.split("\\|");

            for (String part : hashVarSeq) {
                hashString = (empty(params.get(part))) ? hashString.concat("") : hashString.concat(params.get(part));
                hashString = hashString.concat("|");
            }
            hashString = hashString.concat(salt);

            hash = Easebuzz_Generatehash512("SHA-512", hashString);
            params.put("hash", hash);

            StringBuilder sb = new StringBuilder();
            for (Map.Entry<String, String> e : params.entrySet()) {
                if (sb.length() > 0) {
                    sb.append('&');
                }
                sb.append(URLEncoder.encode(e.getKey().trim(), "UTF-8")).append('=').append(URLEncoder.encode(e.getValue().trim(), "UTF-8"));
            }

            URL url = new URL(base_url);
            HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setDoOutput(true);
            PrintStream ps = new PrintStream(con.getOutputStream());
            ps.print(sb);
            ps.close();
            con.connect();
            
            StringBuilder res = new StringBuilder();
            if (con.getResponseCode() == HttpsURLConnection.HTTP_OK) {
                BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
                String line;
                
                while ((line = br.readLine()) != null) {
                    res.append(line);
                }
                br.close();
            }
            
            con.disconnect(); 
            out.print(res);
        
        %>


