<%-- 
    Document   : response
    Created on : 18 Feb, 2016, 5:42:32 PM
    Author     : work
--%>

<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Response</title>
    </head>
    <body>
        <%
            Map<String, String[]> parameters = request.getParameterMap();
            for(String parameter : parameters.keySet()) {
                out.print(parameter+" : "+parameters.get(parameter)[0].toString()+"<br/>");
            }
        %>
    </body>
</html>
