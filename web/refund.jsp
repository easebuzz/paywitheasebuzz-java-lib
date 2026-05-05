

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" href="assets/css/style.css">
        <title>Initiate Refund Page</title>
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
                    <h2><a class="highlight" href="/Easebuzz_javaKit/index.jsp">Back</a></h2>
                </div>
            </header>

            <div class="form-container">
                <h2>REFUND API</h2>
                <hr>
                <form action="refund_response.jsp" method="post" name="RefundForm" onsubmit="return validateRefundForm()">
                    <div class="main-form">
                        <h3>Mandatory Parameters</h3>
                        <hr>
                        <div class="mandatory-data">

                            <div class="form-field">
                                <label for="merchant_refund_id">Merchant Refund ID<sup>*</sup></label>
                                <input id="merchant_refund_id" class="merchant_refund_id" name="merchant_refund_id" value="" required placeholder="REF123" pattern="^[a-zA-Z0-9_-]*$" title="Only alphanumeric characters, underscores, and hyphens allowed">
                            </div>
            
                            <div class="form-field">
                                <label for="easebuzz_id">Easebuzz Transaction ID<sup>*</sup></label>
                                <input id="easebuzz_id" class="easebuzz_id" name="easebuzz_id" value="" required placeholder="SBD12345" pattern="^[a-zA-Z0-9]*$" title="Only alphanumeric characters allowed">
                            </div>
            
                            <div class="form-field">
                                <label for="refund_amount">Refund Amount<sup>(should be float)*</sup></label>
                                <input id="refund_amount" class="refund_amount" name="refund_amount" value="" required placeholder="125.25" pattern="^[0-9]+(\.[0-9]+)?$" title="Enter a valid amount (e.g., 125.25)">
                            </div>
                        </div>

                        <h3>Optional Parameters</h3>
                        <hr>
                        <div class="optional-data">
                            <div class="form-field">
                                <label for="udf1">UDF1</label>
                                <input id="udf1" class="udf1" name="udf1" value="" placeholder="Additional data" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&]*$" title="Alphanumeric characters and special symbols allowed">
                            </div>
            
                            <div class="form-field">
                                <label for="udf2">UDF2</label>
                                <input id="udf2" class="udf2" name="udf2" value="" placeholder="Additional data" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&]*$" title="Alphanumeric characters and special symbols allowed">
                            </div>
            
                            <div class="form-field">
                                <label for="udf3">UDF3</label>
                                <input id="udf3" class="udf3" name="udf3" value="" placeholder="Additional data" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&]*$" title="Alphanumeric characters and special symbols allowed">
                            </div>
            
                            <div class="form-field">
                                <label for="udf4">UDF4</label>
                                <input id="udf4" class="udf4" name="udf4" value="" placeholder="Additional data" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&]*$" title="Alphanumeric characters and special symbols allowed">
                            </div>
            
                            <div class="form-field">
                                <label for="udf5">UDF5</label>
                                <input id="udf5" class="udf5" name="udf5" value="" placeholder="Additional data" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&]*$" title="Alphanumeric characters and special symbols allowed">
                            </div>
            
                            <div class="form-field">
                                <label for="udf6">UDF6</label>
                                <input id="udf6" class="udf6" name="udf6" value="" placeholder="Additional data" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&]*$" title="Alphanumeric characters and special symbols allowed">
                            </div>
            
                            <div class="form-field">
                                <label for="udf7">UDF7</label>
                                <input id="udf7" class="udf7" name="udf7" value="" placeholder="Additional data" pattern="^[a-zA-Z\.0-9/\\,\s_#@\-=+&]*$" title="Alphanumeric characters and special symbols allowed">
                            </div>
                            
                            <div class="form-field">
                                <label for="split_labels">Split Labels</label>
                                <input id="split_labels" class="split_labels" name="split_labels" value="" placeholder='{"test account 1": 60.0, "test account 2": 40.0}' title="JSON format: {\"label1\": amount1, \"label2\": amount2}">
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
        // Form validation function
        function validateRefundForm() {
            var requiredFields = [
                { id: 'merchant_refund_id', name: 'Merchant Refund ID' },
                { id: 'easebuzz_id', name: 'Easebuzz Transaction ID' },
                { id: 'refund_amount', name: 'Refund Amount' }
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

            // Validate patterns for all fields (required and optional)
            var fieldsToValidate = ['merchant_refund_id', 'easebuzz_id', 'refund_amount', 'udf1', 'udf2', 'udf3', 'udf4', 'udf5', 'udf6', 'udf7'];
            var allValid = true;
            var patternErrors = [];

            for (var k = 0; k < fieldsToValidate.length; k++) {
                var input = document.getElementById(fieldsToValidate[k]);
                if (input && input.value && input.value.trim() !== '') {
                    var pattern = input.getAttribute('pattern');
                    if (pattern) {
                        var regex = new RegExp(pattern);
                        if (!regex.test(input.value)) {
                            input.style.borderColor = '#ff0000';
                            input.style.backgroundColor = '#ffebee';
                            var fieldLabel = input.previousElementSibling.textContent.replace('*', '').replace('(should be float)', '');
                            patternErrors.push(fieldLabel);
                            allValid = false;
                            if (!firstErrorField) {
                                firstErrorField = input;
                            }
                        }
                    }
                }
            }
            
            // Special validation for split_labels JSON format
            var splitLabelsInput = document.getElementById('split_labels');
            if (splitLabelsInput && splitLabelsInput.value && splitLabelsInput.value.trim() !== '') {
                try {
                    var splitLabelsJson = JSON.parse(splitLabelsInput.value);
                    // Check if all values are numbers
                    for (var key in splitLabelsJson) {
                        if (isNaN(splitLabelsJson[key])) {
                            throw new Error('All values must be numbers');
                        }
                    }
                    splitLabelsInput.style.borderColor = '';
                    splitLabelsInput.style.backgroundColor = '';
                } catch (e) {
                    splitLabelsInput.style.borderColor = '#ff0000';
                    splitLabelsInput.style.backgroundColor = '#ffebee';
                    patternErrors.push('Split Labels (must be valid JSON with numeric values)');
                    allValid = false;
                    if (!firstErrorField) {
                        firstErrorField = splitLabelsInput;
                    }
                }
            }

            if (!allValid) {
                var patternErrorMessage = 'Please correct the format for the following fields:\n\n';
                for (var l = 0; l < patternErrors.length; l++) {
                    patternErrorMessage += '• ' + patternErrors[l] + '\n';
                }
                alert(patternErrorMessage);
                if (firstErrorField) {
                    firstErrorField.focus();
                }
                return false;
            }

            return true;
        }

        // Clear error styling when user starts typing
        function clearErrorStyling(input) {
            input.addEventListener('input', function() {
                this.style.borderColor = '';
                this.style.backgroundColor = '';
            });
        }

        // Apply clear error styling to all inputs
        document.addEventListener('DOMContentLoaded', function() {
            var allInputs = document.querySelectorAll('input');
            for (var i = 0; i < allInputs.length; i++) {
                clearErrorStyling(allInputs[i]);
            }
        });
    </script>

</html>
