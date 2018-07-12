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
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Response Page</title>
    </head>
    <body>

        <%! // validations check
            public boolean empty(String s) {
                if (s == null || s.trim().equals("")) {
                    return true;
                } else {
                    return false;
                }
            }
        %>

        <%! //hashcode generation method
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
        <%  //reverse hash matching while response
            String salt = "XXXXXXXXXXX";
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
            params.put("salt", salt);
            params.put("status", request.getParameter("status"));
            String hashString = "";
            String hash = "";

            String hashSequence = "salt|status|udf10|udf9|udf8|udf7|udf6|udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid";

            String[] hashVarSeq = hashSequence.split("\\|");

            for (String part : hashVarSeq) {
                hashString = (empty(params.get(part))) ? hashString.concat("") : hashString.concat(params.get(part));
                hashString = hashString.concat("|");
            }
            hashString = hashString.concat(request.getParameter("key"));
            hash = Easebuzz_Generatehash512("SHA-512", hashString);

            String responseHash = request.getParameter("hash");
            if (hash.trim().equals(responseHash.trim())) {
                Map<String, String[]> parameters1 = request.getParameterMap();
                for (String parameter : parameters1.keySet()) {
                    out.print(parameter + " : " + parameters1.get(parameter)[0].toString() + "<br/>");

                }
            } else {
                out.print("something wrong happend");

            }


        %>


    </body>
</html>
