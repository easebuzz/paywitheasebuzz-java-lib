<%-- 
    Document   : transactions
    Created on : 24 May, 2018, 11:18:40 AM
    Author     : Easebuzz
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" href="assets/css/style.css">
        <title>Transactional Date wise Page</title>
        
    </head>
    
    <body>
        <div class="grid-container">
            <header class="wrapper">
                <div class="logo">
                    <a href="#">
                        <img src="assets/images/eb-logo.svg" alt="Easebuzz">
                    </a>
                </div>

                <div class="hedding">
                    <h2><a class="highlight" href="/Easebuzz_javaKit/index.jsp">Back</a></h2>
                </div>
            </header>
        </div>
        
        <div class="form-container">
            <h2>TRANSACTION DATE API</h2>
            <hr>
            <form method="POST" action="transaction_date_return.jsp">
                
                <div class="main-form">
                    <h3>Mandatory Parameters</h3>
                    <hr>
                    <div class="mandatory-data">
                        <div class="form-field">
                            <label for="merchant_email">Merchant Email ID<sup>*</sup></label>
                            <input id="merchant_email" class="merchant_email" name="merchant_email" value="" required placeholder="date.transaction@easebuzz.in">
                        </div>
        
                        <div class="form-field">
                            <label for="transaction_date">Transaction Date<sup>*</sup></label>
                            <input id="transaction_date" class="transaction_date" name="transaction_date" value="" required placeholder="DD-MM-YYYY">
                        </div>         
                        
                      
                    </div>
                    
                    <div class="btn-submit">
                        <button type="submit">Submit</button>  
                    </div> 
                </div>           
            </form>
        </div>

        <!-- import javascript file -->  
        <script src="http://code.jquery.com/jquery-1.10.2.js"></script>
    </body>

</html>
