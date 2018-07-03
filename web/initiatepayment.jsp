
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
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" href="assets/css/style.css">
        <title>Initiate Payment API</title>
        
    </head>    
    
    <body>
        <div class="grid-container">
            <header class="wrapper">
                <div class="logo">
                    <a>
                        <img src="assets/images/eb-logo.svg" alt="Easebuzz">
                    </a>
                </div>

                <div class="hedding">
                    <h2><a class="highlight" href="/Easebuzz_javaKit/index.jsp">Back</a></h2>
                </div>
            </header>
            
            <div class="form-container">
                <h2>INITIATE PAYMENT API</h2>
                <hr>
                <form method="POST" name="initiatePayment" action="initiate_payment_invoke.jsp">
                    
                    <div class="main-form">
                        <h3>Mandatory Parameters</h3>
                        <hr>
                        <div class="mandatory-data">
                            <div class="form-field">
                                <label for="txnid">Transaction ID<sup>*</sup></label>
                                <input id="txnid" class="txnid" name="txnid" value="" required placeholder="T31Q6JT8HB">
                            </div>

                            <div class="form-field">
                                <label for="amount">Amount<sup>(should be float)*</sup></label>
                                <input id="amount" class="amount" name="amount" value="" required placeholder="125.25">
                            </div>  

                            <div class="form-field">
                                <label for="firstname">First Name<sup>*</sup></label>
                                <input id="firstname" class="firstname" name="firstname" value="" required placeholder="Easebuzz Pvt. Ltd.">
                            </div>
                    
                            <div class="form-field">
                                <label for="email">Email ID<sup>*</sup></label>
                                <input id="email" class="email" name="email" value="" required placeholder="initiate.payment@easebuzz.in">
                            </div>
                    
                            <div class="form-field">
                                <label for="phone">Phone<sup>*</sup></label>
                                <input id="phone" class="phone" name="phone" value=""  required placeholder="0123456789">
                            </div>
                            
                            <div class="form-field">
                                <label for="productinfo">Product Information<sup>*</sup></label>
                                <input id="productinfo" class="productinfo" name="productinfo" value="" required placeholder="Apple Laptop">
                            </div>
                    
                            <div class="form-field">
                                <label for="surl">Success URL<sup>*</sup></label>
                                <input id="surl" class="surl" name="surl" value="http://localhost:8080/Easebuzz_javaKit/response.jsp" required>
                            </div>
                            
                            <div class="form-field">
                                <label for="furl">Failure URL<sup>*</sup></label>
                                <input id="furl" class="furl" name="furl" value="http://localhost:8080/Easebuzz_javaKit/response.jsp" required>
                            </div>

                        </div>

                        <h3>Optional Parameters</h3>
                        <hr>
                        <div class="optional-data">

                            <div class="form-field">
                                <label for="udf1">UDF1</label>
                                <input id="udf1" class="udf1" name="udf1" value="" placeholder="User description1">
                            </div>
                        
                            <div class="form-field">
                                <label for="udf2">UDF2</label>
                                <input id="udf2" class="udf2" name="udf2" value="" placeholder="User description2">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf3">UDF3</label>
                                <input id="udf3" class="udf3" name="udf3" value="" placeholder="User description3">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf4">UDF4</label>
                                <input id="udf4" class="udf4" name="udf4" value="" placeholder="User description4">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf5">UDF5</label>
                                <input id="udf5" class="udf5" name="udf5" value="" placeholder="User description5">
                            </div>
                           

                        </div>
                
                        
                        <div class="btn-submit">
                            <button type="submit">SUBMIT</button>
                        </div>
                    </div>
                </form>
            </div>
            
        </div>
    </body>

</html>
