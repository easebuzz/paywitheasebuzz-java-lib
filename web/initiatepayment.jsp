
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
                        <span style="color:#07275d; font-size:0.9em;">Auto Fill Data</span>
                        <label style="position:relative; display:inline-block; width:50px; height:26px; margin:0;">
                            <input type="checkbox" id="autoFillToggle" style="opacity:0; width:0; height:0;">
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
                                <input id="txnid" name="txnid" value="" required placeholder="T31Q6JT8HB" pattern="^[a-zA-Z0-9_|\-/]{1,40}$" title="Only alphanumeric, _, |, -, / allowed. Max 40 chars.">
                            </div>

                            <div class="form-field">
                                <label for="amount">Amount<sup>(should be float)*</sup></label>
                                <input id="amount" name="amount" value="" required placeholder="125.25" pattern="^[0-9.]*$" title="Only numbers and decimal point allowed. Max 99,99,999.">
                            </div>  

                            <div class="form-field">
                                <label for="firstname">First Name<sup>*</sup></label>
                                <input id="firstname" name="firstname" value="" required placeholder="Easebuzz Pvt. Ltd." pattern="^[a-zA-Z0-9&amp;\-._ ()/,@]{1,150}$" title="Only alphanumeric and &-._()/,@ allowed. Max 150 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="email">Email ID<sup>*</sup></label>
                                <input id="email" name="email" type="email" value="" required placeholder="initiate.payment@easebuzz.in" title="Enter a valid email address.">
                            </div>
                    
                            <div class="form-field">
                                <label for="phone">Phone<sup>*</sup></label>
                                <input id="phone" name="phone" value="" required placeholder="0123456789" pattern="^(\+\d{1,4}[-]?)?\d{5,20}$" title="Valid phone number. 5-20 digits, optional country code.">
                            </div>
                            
                            <div class="form-field">
                                <label for="productinfo">Product Info<sup>*</sup></label>
                                <input id="productinfo" name="productinfo" value="" required placeholder="Apple Laptop" pattern="^[a-zA-Z0-9\-\s|\-]{1,45}$" title="Only alphanumeric, spaces, - and | allowed. Max 45 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="surl">Success URL<sup>*</sup></label>
                                <input id="surl" name="surl" value="" required placeholder="http://localhost:8080/Easebuzz_javaKit/response.jsp" pattern="^https?://.*" title="Enter a valid URL starting with http:// or https://">
                            </div>
                            
                            <div class="form-field">
                                <label for="furl">Failure URL<sup>*</sup></label>
                                <input id="furl" name="furl" value="" required placeholder="http://localhost:8080/Easebuzz_javaKit/response.jsp" pattern="^https?://.*" title="Enter a valid URL starting with http:// or https://">
                            </div>

                        </div>

                        <h3>Optional Parameters</h3>
                        <hr>
                        <div class="optional-data">

                            <div class="form-field">
                                <label for="udf1">UDF1</label>
                                <input id="udf1" name="udf1" value="" placeholder="User description1" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>
                        
                            <div class="form-field">
                                <label for="udf2">UDF2</label>
                                <input id="udf2" name="udf2" value="" placeholder="User description2" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf3">UDF3</label>
                                <input id="udf3" name="udf3" value="" placeholder="User description3" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf4">UDF4</label>
                                <input id="udf4" name="udf4" value="" placeholder="User description4" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>
                    
                            <div class="form-field">
                                <label for="udf5">UDF5</label>
                                <input id="udf5" name="udf5" value="" placeholder="User description5" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>

                            <div class="form-field">
                                <label for="udf6">UDF6</label>
                                <input id="udf6" name="udf6" value="" placeholder="User description6" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>

                            <div class="form-field">
                                <label for="udf7">UDF7</label>
                                <input id="udf7" name="udf7" value="" placeholder="User description7" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&amp;]{1,300}$" title="Only alphanumeric and ./ ,_#@-=+& allowed. Max 300 chars.">
                            </div>

                            <div class="form-field">
                                <label for="address1">Address 1</label>
                                <input id="address1" name="address1" value="" placeholder="123 Main Street" pattern="^[a-zA-Z\.0-9/\,\s_#@()&amp;|:-]{1,100}$" title="Only letters, numbers, comma, space, dot, hash, slash, hyphen, underscore allowed. Max 100 chars.">
                            </div>

                            <div class="form-field">
                                <label for="address2">Address 2</label>
                                <input id="address2" name="address2" value="" placeholder="Apt 4B" pattern="^[a-zA-Z\.0-9/\,\s_#@()&amp;|:-]{1,100}$" title="Only letters, numbers, comma, space, dot, hash, slash, hyphen, underscore allowed. Max 100 chars.">
                            </div>

                            <div class="form-field">
                                <label for="city">City</label>
                                <input id="city" name="city" value="" placeholder="New York" pattern="^[0-9a-zA-Z_.\s-]{1,50}$" title="Only alphanumeric, underscore, dot, space, hyphen allowed. Max 50 chars.">
                            </div>

                            <div class="form-field">
                                <label for="state">State</label>
                                <input id="state" name="state" value="" placeholder="NY" pattern="^[0-9a-zA-Z_.\s-]{1,50}$" title="Only alphanumeric, underscore, dot, space, hyphen allowed. Max 50 chars.">
                            </div>

                            <div class="form-field">
                                <label for="country">Country</label>
                                <input id="country" name="country" value="" placeholder="USA" pattern="^[0-9a-zA-Z_.\s-]{1,50}$" title="Only alphanumeric, underscore, dot, space, hyphen allowed. Max 50 chars.">
                            </div>

                            <div class="form-field">
                                <label for="zipcode">Zipcode</label>
                                <input id="zipcode" name="zipcode" value="" placeholder="123456" pattern="^[0-9]{0,6}$" title="Only numbers allowed. Max 6 digits.">
                            </div>

                            <div class="form-field">
                                <label for="show_payment_mode">Show Payment Mode</label>
                                <input id="show_payment_mode" name="show_payment_mode" value="" placeholder="NB,DC,CC,MW,UPI,OM,EMI,CBT,BT" title="Comma separated payment modes: NB,DC,CC,MW,UPI,OM,EMI,CBT,BT">
                            </div>

                            <div class="form-field">
                                <label for="split_payments">Split Payments</label>
                                <input id="split_payments" name="split_payments" value="" placeholder='{"Bank1": 10.0, "Bank2": 5.0}' title="JSON format: {\"label_of_bank1\": amount, \"label_of_bank2\": amount}">
                            </div>

                            <div class="form-field">
                                <label for="sub_merchant_id">Sub Merchant ID</label>
                                <input id="sub_merchant_id" name="sub_merchant_id" value="" placeholder="SUB123" pattern="^[a-zA-Z0-9\-]{0,15}$" title="Only alphanumeric and hyphen allowed. Max 15 chars.">
                            </div>

                            <div class="form-field">
                                <label for="unique_id">Unique ID</label>
                                <input id="unique_id" name="unique_id" value="" placeholder="UNIQUE123" pattern="^[a-zA-Z0-9_]{0,40}$" title="Only alphanumeric and underscore allowed. Max 40 chars.">
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
        // ─── Common field style helpers ───
        function resetFieldStyle(field) {
            field.setCustomValidity('');
            field.style.borderColor = '';
            field.style.backgroundColor = '';
        }

        function highlightFieldError(field) {
            field.style.borderColor = '#ff0000';
            field.style.backgroundColor = '#ffebee';
        }

        // ─── Auto-fill toggle ───
        var autoFillToggle = document.getElementById('autoFillToggle');
        var autoFillSlider = autoFillToggle.nextElementSibling;

        autoFillToggle.addEventListener('change', function() {
            var form = document.forms['initiatePayment'];
            if (this.checked) {
                autoFillSlider.style.backgroundColor = '#4CAF50';
                form.txnid.value = 'TXN' + Math.random().toString(36).substring(2, 10).toUpperCase();
                form.amount.value = '125.50';
                form.firstname.value = 'John Doe';
                form.email.value = 'test@example.com';
                form.phone.value = '9876543210';
                form.productinfo.value = 'Test Product';
                form.surl.value = 'http://localhost:8080/Easebuzz_javaKit/response.jsp';
                form.furl.value = 'http://localhost:8080/Easebuzz_javaKit/response.jsp';
            } else {
                autoFillSlider.style.backgroundColor = '#ccc';
                var inputs = form.querySelectorAll('input');
                for (var i = 0; i < inputs.length; i++) inputs[i].value = '';
            }
        });

        // ─── Live pattern validation on all inputs with pattern attribute ───
        var patternInputs = document.querySelectorAll('form[name="initiatePayment"] input[pattern]');
        patternInputs.forEach(function(input) {
            input.addEventListener('input', function() {
                var pattern = this.getAttribute('pattern');
                if (!this.value || this.value.trim() === '') {
                    resetFieldStyle(this);
                } else if (pattern && !new RegExp(pattern).test(this.value)) {
                    this.setCustomValidity(this.getAttribute('title') || 'Invalid input');
                    highlightFieldError(this);
                } else {
                    resetFieldStyle(this);
                }
            });
        });

        // ─── Form validation ───
        function validateForm() {
            // Auto-detect all required fields from the form
            var requiredInputs = document.querySelectorAll('form[name="initiatePayment"] input[required]');
            var emptyFieldLabels = [];
            var firstInvalidField = '';

            for (var i = 0; i < requiredInputs.length; i++) {
                var field = requiredInputs[i];
                if (!field.value || field.value.trim() === '') {
                    var label = field.closest('.form-field').querySelector('label');
                    emptyFieldLabels.push(label ? label.textContent.replace('*', '').trim() : field.name);
                    highlightFieldError(field);
                    if (!firstInvalidField) firstInvalidField = field;
                } else {
                    resetFieldStyle(field);
                }
            }

            if (emptyFieldLabels.length > 0) {
                alert('Please fill in the following required fields:\n\n' + emptyFieldLabels.map(function(n) { return '\u2022 ' + n; }).join('\n'));
                if (firstInvalidField) firstInvalidField.focus();
                return false;
            }

            // Validate patterns for all filled inputs
            var allValid = true;
            patternInputs.forEach(function(input) {
                if (input.value) {
                    var pattern = input.getAttribute('pattern');
                    if (pattern && !new RegExp(pattern).test(input.value)) {
                        highlightFieldError(input);
                        allValid = false;
                        if (!firstInvalidField) firstInvalidField = input;
                    }
                }
            });

            // Amount range check
            var amountField = document.getElementById('amount');
            if (amountField.value) {
                var amount = parseFloat(amountField.value);
                if (isNaN(amount) || amount <= 0 || amount > 9999999) {
                    highlightFieldError(amountField);
                    alert('Amount must be a valid number between 0.01 and 9999999');
                    amountField.focus();
                    return false;
                }
            }

            if (!allValid) {
                alert('Please correct the highlighted fields with invalid format.');
                if (firstInvalidField) firstInvalidField.focus();
                return false;
            }

            return true;
        }

        // Clear error styling on focus for all inputs
        var allInputs = document.querySelectorAll('form[name="initiatePayment"] input');
        for (var i = 0; i < allInputs.length; i++) {
            allInputs[i].addEventListener('focus', function() {
                resetFieldStyle(this);
            });
        }
    </script>
</html>
