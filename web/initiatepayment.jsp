
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
                        <img src="assets/images/Easebuzz_Logo_ White_Text.svg" alt="Easebuzz">
                    </a>
                </div>

                <div class="hedding">
                    <div style="display:flex; align-items:center; justify-content:flex-end; gap:10px; margin-top:8px;">
                        <span style="color:#07275d; font-size:0.9em;">Fill Dummy Data</span>
                        <label style="position:relative; display:inline-block; width:50px; height:26px; margin:0;">
                            <input type="checkbox" id="dummyToggle" style="opacity:0; width:0; height:0;">
                            <span style="position:absolute; cursor:pointer; top:0; left:0; right:0; bottom:0; background-color:#ccc; border-radius:26px; transition:0.3s;"></span>
                        </label>
                        <a class="highlight" href="/Easebuzz_javaKit/index.jsp">Back</a>
                    </div>
                </div>
            </header>
            
            <div class="form-container">
                <h2>INITIATE PAYMENT API</h2>
                <hr>
                <form method="POST" name="initiatePayment" action="initiate_payment_invoke.jsp" onsubmit="return validateForm()">
                    
                    <div class="main-form">
                        <h3>Mandatory Parameters</h3>
                        <hr>
                        <div class="mandatory-data">
                            <div class="form-field">
                                <label for="txnid">Transaction ID<sup>*</sup></label>
                                <input id="txnid" class="txnid" name="txnid" value="" required placeholder="T31Q6JT8HB" pattern="^[a-zA-Z0-9_|\-/]{1,40}$" title="Only alphanumeric, _, |, -, / allowed. Max 40 chars.">
                            </div>

                            <div class="form-field">
                                <label for="amount">Amount<sup>(should be float)*</sup></label>
                                <input id="amount" class="amount" name="amount" value="" required placeholder="125.25" pattern="^[0-9.]*$" title="Only numbers and decimal point allowed. Max ₹99,99,999.">
                            </div>  

                            <div class="form-field">
                                <label for="firstname">First Name<sup>*</sup></label>
                                <input id="firstname" class="firstname" name="firstname" value="" required placeholder="Easebuzz Pvt. Ltd." pattern="^[a-zA-Z0-9&amp;\-._ ()/,@]{1,150}$" title="Only alphanumeric and &-._()/,@ allowed. Max 150 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="email">Email ID<sup>*</sup></label>
                                <input id="email" class="email" name="email" type="email" value="" required placeholder="initiate.payment@easebuzz.in" title="Enter a valid email address.">
                            </div>
                    
                            <div class="form-field">
                                <label for="phone">Phone<sup>*</sup></label>
                                <input id="phone" class="phone" name="phone" value="" required placeholder="0123456789" pattern="^(\+\d{1,4}[-]?)?\d{5,20}$" title="Valid phone number. 5-20 digits, optional country code.">
                            </div>
                            
                            <div class="form-field">
                                <label for="productinfo">Product Info<sup>*</sup></label>
                                <input id="productinfo" class="productinfo" name="productinfo" value="" required placeholder="Apple Laptop" pattern="^[a-zA-Z0-9\-\s|\-]{1,45}$" title="Only alphanumeric, spaces, - and | allowed. Max 45 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="surl">Success URL<sup>*</sup></label>
                                <input id="surl" class="surl" name="surl" value="http://localhost:8080/Easebuzz_javaKit/response.jsp" required pattern="^https?://.*" title="Enter a valid URL starting with http:// or https://">
                            </div>
                            
                            <div class="form-field">
                                <label for="furl">Failure URL<sup>*</sup></label>
                                <input id="furl" class="furl" name="furl" value="http://localhost:8080/Easebuzz_javaKit/response.jsp" required pattern="^https?://.*" title="Enter a valid URL starting with http:// or https://">
                            </div>

                        </div>

                        <h3>Optional Parameters</h3>
                        <hr>
                        <div class="optional-data">

                            <div class="form-field">
                                <label for="udf1">UDF1</label>
                                <input id="udf1" class="udf1" name="udf1" value="" placeholder="User description1" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>
                        
                            <div class="form-field">
                                <label for="udf2">UDF2</label>
                                <input id="udf2" class="udf2" name="udf2" value="" placeholder="User description2" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf3">UDF3</label>
                                <input id="udf3" class="udf3" name="udf3" value="" placeholder="User description3" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf4">UDF4</label>
                                <input id="udf4" class="udf4" name="udf4" value="" placeholder="User description4" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf5">UDF5</label>
                                <input id="udf5" class="udf5" name="udf5" value="" placeholder="User description5" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>

                            <div class="form-field">
                                <label for="udf6">UDF6</label>
                                <input id="udf6" class="udf6" name="udf6" value="" placeholder="User description6" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>

                            <div class="form-field">
                                <label for="udf7">UDF7</label>
                                <input id="udf7" class="udf7" name="udf7" value="" placeholder="User description7" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>

                            <div class="form-field">
                                <label for="address1">Address 1</label>
                                <input id="address1" class="address1" name="address1" value="" placeholder="123 Main Street" pattern="^[a-zA-Z\.0-9/\,\s_#@()&amp;|:-]{1,100}$" title="Only letters, numbers, comma, space, dot, hash, slash, hyphen, underscore allowed. Max 100 chars.">
                            </div>

                            <div class="form-field">
                                <label for="address2">Address 2</label>
                                <input id="address2" class="address2" name="address2" value="" placeholder="Apt 4B" pattern="^[a-zA-Z\.0-9/\,\s_#@()&amp;|:-]{1,100}$" title="Only letters, numbers, comma, space, dot, hash, slash, hyphen, underscore allowed. Max 100 chars.">
                            </div>

                            <div class="form-field">
                                <label for="city">City</label>
                                <input id="city" class="city" name="city" value="" placeholder="New York" pattern="^[0-9a-zA-Z_.\s-]{1,50}$" title="Only alphanumeric, underscore, dot, space, hyphen allowed. Max 50 chars.">
                            </div>

                            <div class="form-field">
                                <label for="state">State</label>
                                <input id="state" class="state" name="state" value="" placeholder="NY" pattern="^[0-9a-zA-Z_.\s-]{1,50}$" title="Only alphanumeric, underscore, dot, space, hyphen allowed. Max 50 chars.">
                            </div>

                            <div class="form-field">
                                <label for="country">Country</label>
                                <input id="country" class="country" name="country" value="" placeholder="USA" pattern="^[0-9a-zA-Z_.\s-]{1,50}$" title="Only alphanumeric, underscore, dot, space, hyphen allowed. Max 50 chars.">
                            </div>

                            <div class="form-field">
                                <label for="zipcode">Zipcode</label>
                                <input id="zipcode" class="zipcode" name="zipcode" value="" placeholder="123456" pattern="^[0-9]{0,6}$" title="Only numbers allowed. Max 6 digits.">
                            </div>

                            <div class="form-field">
                                <label for="show_payment_mode">Show Payment Mode</label>
                                <input id="show_payment_mode" class="show_payment_mode" name="show_payment_mode" value="" placeholder="NB,DC,CC,MW,UPI,OM,EMI,CBT,BT" title="Comma separated payment modes: NB,DC,CC,MW,UPI,OM,EMI,CBT,BT">
                            </div>

                            <div class="form-field">
                                <label for="split_payments">Split Payments</label>
                                <input id="split_payments" class="split_payments" name="split_payments" value="" placeholder='{"Bank1": 10.0, "Bank2": 5.0}' title="JSON format: {\"label_of_bank1\": amount, \"label_of_bank2\": amount}">
                            </div>

                            <div class="form-field">
                                <label for="sub_merchant_id">Sub Merchant ID</label>
                                <input id="sub_merchant_id" class="sub_merchant_id" name="sub_merchant_id" value="" placeholder="SUB123" pattern="^[a-zA-Z0-9\-]{0,15}$" title="Only alphanumeric and hyphen allowed. Max 15 chars.">
                            </div>

                            <div class="form-field">
                                <label for="unique_id">Unique ID</label>
                                <input id="unique_id" class="unique_id" name="unique_id" value="" placeholder="UNIQUE123" pattern="^[a-zA-Z0-9_]{0,40}$" title="Only alphanumeric and underscore allowed. Max 40 chars.">
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

    <script>
        var toggle = document.getElementById('dummyToggle');
        var slider = toggle.nextElementSibling;

        function generateTxnId() {
            var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
            var id = 'TXN';
            for (var i = 0; i < 8; i++) {
                id += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            return id;
        }

        var dummyData = {
            amount: '125.50',
            firstname: 'John Doe',
            email: 'test@example.com',
            phone: '9876543210',
            productinfo: 'Test Product',
            surl: 'http://localhost:8080/Easebuzz_javaKit/response.jsp',
            furl: 'http://localhost:8080/Easebuzz_javaKit/response.jsp'
        };

        toggle.addEventListener('change', function() {
            if (this.checked) {
                slider.style.backgroundColor = '#4CAF50';
                document.getElementById('txnid').value = generateTxnId();
                for (var key in dummyData) {
                    var el = document.getElementById(key);
                    if (el) el.value = dummyData[key];
                }
            } else {
                slider.style.backgroundColor = '#ccc';
                var inputs = document.querySelectorAll('form[name="initiatePayment"] input');
                for (var i = 0; i < inputs.length; i++) {
                    if (inputs[i].id === 'surl' || inputs[i].id === 'furl') {
                        inputs[i].value = '';
                    } else {
                        inputs[i].value = '';
                    }
                }
            }
        });

        // Real-time validation
        function addValidation(inputId) {
            var input = document.getElementById(inputId);
            if (input) {
                input.addEventListener('input', function() {
                    var pattern = this.getAttribute('pattern');
                    if (!this.value || this.value.trim() === '') {
                        // Field is empty - clear all validation
                        this.setCustomValidity('');
                        this.style.borderColor = '';
                        this.style.backgroundColor = '';
                    } else if (pattern) {
                        var regex = new RegExp(pattern);
                        if (!regex.test(this.value)) {
                            this.setCustomValidity(this.getAttribute('title') || 'Invalid input');
                            this.style.borderColor = '#ff0000';
                            this.style.backgroundColor = '#ffebee';
                        } else {
                            this.setCustomValidity('');
                            this.style.borderColor = '';
                            this.style.backgroundColor = '';
                        }
                    } else {
                        this.setCustomValidity('');
                        this.style.borderColor = '';
                        this.style.backgroundColor = '';
                    }
                });
            }
        }

        // Add validation to all inputs with patterns
        var fieldsToValidate = ['txnid', 'amount', 'firstname', 'phone', 'productinfo', 'surl', 'furl', 'udf1', 'udf2', 'udf3', 'udf4', 'udf5', 'udf6', 'udf7', 'address1', 'address2', 'city', 'state', 'country', 'zipcode', 'sub_merchant_id', 'unique_id'];
        fieldsToValidate.forEach(addValidation);

        // Form validation function
        function validateForm() {
            var requiredFields = [
                { id: 'txnid', name: 'Transaction ID' },
                { id: 'amount', name: 'Amount' },
                { id: 'firstname', name: 'First Name' },
                { id: 'email', name: 'Email' },
                { id: 'phone', name: 'Phone' },
                { id: 'productinfo', name: 'Product Information' },
                { id: 'surl', name: 'Success URL' },
                { id: 'furl', name: 'Failure URL' }
            ];

            var errors = [];
            var firstErrorField = null;

            // Check all required fields
            for (var i = 0; i < requiredFields.length; i++) {
                var field = document.getElementById(requiredFields[i].id);
                if (!field.value || field.value.trim() === '') {
                    errors.push(requiredFields[i].name);
                    field.style.borderColor = '#ff0000';
                    field.style.backgroundColor = '#ffebee';
                    if (!firstErrorField) {
                        firstErrorField = field;
                    }
                } else {
                    field.style.borderColor = '';
                    field.style.backgroundColor = '';
                }
            }

            // Show error message if any required fields are empty
            if (errors.length > 0) {
                var errorMessage = 'Please fill in the following required fields:\n\n';
                for (var j = 0; j < errors.length; j++) {
                    errorMessage += '• ' + errors[j] + '\n';
                }
                alert(errorMessage);
                
                // Focus on first error field
                if (firstErrorField) {
                    firstErrorField.focus();
                }
                return false;
            }

            // Validate patterns for filled fields
            var allValid = true;
            for (var k = 0; k < fieldsToValidate.length; k++) {
                var input = document.getElementById(fieldsToValidate[k]);
                if (input && input.value) {
                    var pattern = input.getAttribute('pattern');
                    if (pattern) {
                        var regex = new RegExp(pattern);
                        if (!regex.test(input.value)) {
                            input.style.borderColor = '#ff0000';
                            input.style.backgroundColor = '#ffebee';
                            allValid = false;
                            if (!firstErrorField) {
                                firstErrorField = input;
                            }
                        }
                    }
                }
            }

            // Additional validation for amount
            var amountField = document.getElementById('amount');
            if (amountField.value) {
                var amount = parseFloat(amountField.value);
                if (isNaN(amount) || amount <= 0 || amount > 9999999) {
                    amountField.style.borderColor = '#ff0000';
                    amountField.style.backgroundColor = '#ffebee';
                    alert('Amount must be a valid number between 0.01 and 9999999');
                    amountField.focus();
                    return false;
                }
            }

            // Additional validation for email
            var emailField = document.getElementById('email');
            if (emailField.value) {
                var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                if (!emailRegex.test(emailField.value)) {
                    emailField.style.borderColor = '#ff0000';
                    emailField.style.backgroundColor = '#ffebee';
                    alert('Please enter a valid email address');
                    emailField.focus();
                    return false;
                }
            }

            // Additional validation for URLs
            var urlFields = ['surl', 'furl'];
            for (var u = 0; u < urlFields.length; u++) {
                var urlField = document.getElementById(urlFields[u]);
                if (urlField.value) {
                    var urlRegex = /^https?:\/\/.+/;
                    if (!urlRegex.test(urlField.value)) {
                        urlField.style.borderColor = '#ff0000';
                        urlField.style.backgroundColor = '#ffebee';
                        alert('Please enter a valid URL starting with http:// or https://');
                        urlField.focus();
                        return false;
                    }
                }
            }

            if (!allValid) {
                alert('Please correct the highlighted fields with invalid format.');
                if (firstErrorField) {
                    firstErrorField.focus();
                }
                return false;
            }

            return true;
        }

        // Clear error styling when user starts typing
        function clearErrorStyling(input) {
            input.addEventListener('focus', function() {
                this.setCustomValidity('');
                this.style.borderColor = '';
                this.style.backgroundColor = '';
            });
        }

        // Apply clear error styling to all inputs
        var allInputs = document.querySelectorAll('input');
        for (var i = 0; i < allInputs.length; i++) {
            clearErrorStyling(allInputs[i]);
        }
    </script>
</html>
