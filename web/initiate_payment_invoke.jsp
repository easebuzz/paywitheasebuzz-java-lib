<%-- 
    Document   : initiate_payment_invoke
    Created on : 2 Jul, 2018, 2:55:34 PM
    Author     : Dwivedi
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
            s.trim();
            return s;
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

    <%
        String merchant_key = "XXXXXXX";
        String salt = "XXXXX";
        String env ="prod";
        String base_url ="";
        if(env == "prod"){
            base_url = "https://pay.easebuzz.in/";
        }else{
            base_url = "https://testpay.easebuzz.in/";
        }
        
        int error = 0;

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
        String txnid = "";

    %>

    <%  
        // main function to start payment
        String hashString = "";
        String hash = "";
        params.put("key",merchant_key);
        String hashSequence = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10";    
            if (empty(params.get("key"))) {
                error = 1;
            } else {
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

                URL url = new URL(base_url + "payment/initiateLink");
                HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
                con.setRequestMethod("POST");
                con.setDoOutput(true);
                PrintStream ps = new PrintStream(con.getOutputStream());
                ps.println(sb);
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

                Object obj = new JSONParser().parse(res.toString());
                JSONObject jo = (JSONObject) obj;

                if (jo.get("status").toString().equals("1")) {
                    response.sendRedirect(base_url + "pay/" + jo.get("data").toString());
                } else {
                    out.print(jo.get("data").toString());
                }

            }
        

    %>
    
