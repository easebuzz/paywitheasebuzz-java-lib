# paywitheasebuzz-lib
JSP integration kit for pay with easebuzz pay.easebuzz.in

# Requirement Software
*setup JSP kits on test/devlopement/production enviroment install below software*

1. Apache tomacat
2. Java EE plugin
3. json-simple-1.1.1.jar and jstl-1.2.jar

# easebuzz Documentation for kit integration
https://docs.easebuzz.in/


### Run the kit on your machine
1. clone the repository on your's system.
2. unzip it
3. import the project to netbeans or eclipse
4. run the projct


# Process for integrate jsp kit in <Your Project>

1. import json-simple-1.1.1.jar and jstl-1.2.jar to your project.
2.  Setup initiate payment 
	2.1 copy paste all the jsp part from initate_payment_invoke.jsp to file
	2.2 change the merchant_key, salt, and env values accordingly.
	```
		String merchant_key = "XXXXXX";
        String salt = "XXXXXX";
        String env ="prod"; // test for testing environment and prod for production environment
        String base_url ="";
        if(env == "prod"){
            base_url = "https://pay.easebuzz.in/";
        }else{
            base_url = "https://testpay.easebuzz.in/";
        }
	```
	2.3 import files
	```
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
		<%@page import="java.util.*" %>
		<%@page import="java.security.*" %>
		<%@page import="javax.net.*" %>
		<%@page import ="org.json.simple.JSONObject" %>
		<%@page import ="org.json.simple.parser.*" %>
		<%@page import ="java.io.FileReader" %>
	```
	2.4 required fields in main function
	
	```
		String txn_id = "";	// transaction id
        String amount = "";	// amount should be float
        String email = "";	//customer's email
        String phone = "";	//customer's phone number
        String productinfo = "";	//product information
        String firstname = "";	//customer's first name
        String udf1 = "";	//optional param for other datas like address,category etc
        String udf2 = "";	//optional param for other datas like address,category etc
        String udf3 = "";	//optional param for other datas like address,category etc
        String udf4 = "";	//optional param for other datas like address,category etc
        String udf5 = "";	//optional param for other datas like address,category etc
    ```


	2.5 ready to start receiving payment online.

3. setup transaction api in your system
	3.1 copy paste all the jsp part from transaction_return.jsp to file.
	3.2 change the values accordingly.
	```
		String key = "XXXXXX";
        String salt = "XXXXXX";
    ```
    3.3 import files.
    ```
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
	```
	3.4 required fields in main function
	```
		String txn_id = "";	// transaction id
        String amount = "";	// amount should be float
        String email = "";	//customer's email
        String phone = "";	//customer's phone number
    ```
	3.5 ready to start  transactional information real time.
	
4. setup transactional records date wise.
	4.1  copy paste all the jsp part from transaction_date_return.jsp to file.
	4.2  change the values accordingly.
	```
		String key = "XXXXXX";
        String salt = "XXXXXXX";
    ```
    4.3 import files.
    ```
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
	```
	4.4 Required parameters in main function
	```
	    String merchant_email = "";	//merchant email address 
        String transaction_date = "";	//transaction date format (DD-MM-YYYY)
    ```
	4.5 ready to start  transactional information date wise.

5. setup payout information date wise.
	5.1  copy paste all the jsp part from payout_return.jsp to file.
	5.2  change the values accordingly.
	```
		String key = "XXXXXX";
        String salt = "XXXXXX";
    ```
    5.3 import files.
    ```
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
		<%@page import="java.util.*" %>
		<%@page import="java.security.*" %>
		<%@page import="javax.net.*" %>
		<%@page import ="org.json.simple.JSONObject" %>
		<%@page import ="org.json.simple.parser.*" %>
		<%@page import ="java.io.FileReader" %>
		<%@page contentType="text/html" pageEncoding="UTF-8"%>

		<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
	```
	5.4 Required parameters in main function
	```
	    String merchant_email = "";	//merchant email address 
        String transaction_date = "";	//trnsaction date format (DD-MM-YYYY)
    ```
	5.4 ready to start receiving payout information date wise.

6. setup Refund api so that you can start refunding your customers as you needed.
	6.1  copy paste all the jsp part from refund_return.jsp to file.
	6.2  change the values accordingly.
	```
		String key = "XXXXXX";
        String salt = "XXXXXXX";
    ```
    6.3 import files.
    ```
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
	```
	6.4 Required paramaters in main function
	```
		String txnid = "";	// easebuzz transaction id
        String amount = ""; // amount value without addition of tdr and taxes and it should be float
        String refund_amount = ""; // refund amount should be float
        String email = "";	//customer's email address
        String phone = "";	// customer's phone number
    ```
	6.5 ready to start invoking refunds from your system.