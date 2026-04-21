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
                        <img src="assets/images/Easebuzz_Logo_ White_Text.svg" alt="Easebuzz">
                    </a>
                </div>

                <div class="hedding">
                    <h2><a class="highlight" href="/Easebuzz_javaKit/index.jsp">Back</a></h2>
                </div>
            </header>
        </div>
        
        <div class="form-container">
            <h2>Transaction API (by date range)</h2>
            <hr>
            <form method="POST" action="transaction_date_return.jsp" onsubmit="return validateForm();">
                
                <div class="main-form">
                    <h3>Mandatory Parameters</h3>
                    <hr>
                    <div class="mandatory-data">
                        <div class="form-field">
                            <label for="merchant_email">Merchant Email ID<sup>*</sup></label>
                            <input id="merchant_email" class="merchant_email" name="merchant_email" value="" required placeholder="merchant@easebuzz.in" type="email">
                        </div>
        
                        <div class="form-field">
                            <label for="start_date">Start Date<sup>*</sup></label>
                            <input id="start_date" class="start_date" name="start_date" value="" required type="date" placeholder="dd/mm/yyyy">
                            <input type="hidden" id="start_date_formatted" name="start_date_formatted">
                        </div>
                        
                        <div class="form-field">
                            <label for="end_date">End Date<sup>*</sup></label>
                            <input id="end_date" class="end_date" name="end_date" value="" required type="date" placeholder="dd/mm/yyyy">
                            <input type="hidden" id="end_date_formatted" name="end_date_formatted">
                        </div>         
                    </div>
                    
                    <h3>Optional Parameters</h3>
                    <hr>
                    <div class="optional-data">
                        <div class="form-field">
                            <label for="submerchant_id">Sub Merchant ID</label>
                            <input id="submerchant_id" class="submerchant_id" name="submerchant_id" value="" placeholder="SUB123456">
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
        <script>
            // Convert YYYY-MM-DD to DD-MM-YYYY
            function formatDateToDDMMYYYY(dateString) {
                if (!dateString) return '';
                var parts = dateString.split('-');
                if (parts.length === 3) {
                    return parts[2] + '-' + parts[1] + '-' + parts[0]; // DD-MM-YYYY
                }
                return dateString;
            }
            
            // Update hidden fields when date inputs change
            function setupDateFormatting() {
                var startDateInput = document.getElementById('start_date');
                var endDateInput = document.getElementById('end_date');
                var startDateFormatted = document.getElementById('start_date_formatted');
                var endDateFormatted = document.getElementById('end_date_formatted');
                
                startDateInput.addEventListener('change', function() {
                    startDateFormatted.value = formatDateToDDMMYYYY(this.value);
                });
                
                endDateInput.addEventListener('change', function() {
                    endDateFormatted.value = formatDateToDDMMYYYY(this.value);
                });
            }
            
            // Form validation and submission
            function validateForm() {
                var merchantEmail = document.getElementById('merchant_email').value;
                var startDate = document.getElementById('start_date').value;
                var endDate = document.getElementById('end_date').value;
                var submerchantId = document.getElementById('submerchant_id').value;
                
                // Update formatted dates before submission
                document.getElementById('start_date_formatted').value = formatDateToDDMMYYYY(startDate);
                document.getElementById('end_date_formatted').value = formatDateToDDMMYYYY(endDate);
                
                // Basic validation
                if (!merchantEmail || !startDate || !endDate) {
                    alert('Please fill in all required fields');
                    return false;
                }
                
                // Disable the original date inputs so only formatted dates are sent
                document.getElementById('start_date').disabled = true;
                document.getElementById('end_date').disabled = true;
                
                // Rename hidden fields to match expected parameter names
                document.getElementById('start_date_formatted').name = 'start_date';
                document.getElementById('end_date_formatted').name = 'end_date';
                
                return true;
            }
            
            // Initialize when page loads
            document.addEventListener('DOMContentLoaded', function() {
                setupDateFormatting();
            });
        </script>
    </body>

</html>
