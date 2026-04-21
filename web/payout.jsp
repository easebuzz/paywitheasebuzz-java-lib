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
        <title>Payout API V2</title>
        
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
            <h2>PAYOUT API V2</h2>
            <hr>
            <form method="POST" action="payout_return.jsp">
                
                <div class="main-form">
                    <h3>Mandatory Parameters</h3>
                    <hr>
                    <div class="mandatory-data">
                        <div class="form-field">
                            <label for="start_date">Start Date<sup>*</sup></label>
                            <input id="start_date" class="start_date" name="start_date" type="date" value="" required title="Select start date" placeholder="dd/mm/yyyy">
                        </div>
        
                        <div class="form-field">
                            <label for="end_date">End Date<sup>*</sup></label>
                            <input id="end_date" class="end_date" name="end_date" type="date" value="" required title="Select end date" placeholder="dd/mm/yyyy">
                        </div>
                    </div>

                    <h3>Optional Parameters</h3>
                    <hr>
                    <div class="optional-data">
                        <div class="form-field">
                            <label for="merchant_email">Merchant Email ID</label>
                            <input id="merchant_email" class="merchant_email" name="merchant_email" value="" placeholder="payout@easebuzz.in" pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" title="Enter a valid email address">
                        </div>
        
                        <div class="form-field">
                            <label for="submerchant_id">Submerchant ID</label>
                            <input id="submerchant_id" class="submerchant_id" name="submerchant_id" value="" placeholder="SUB123">
                        </div>
        
                        <div class="form-field">
                            <label for="token">Token</label>
                            <input id="token" class="token" name="token" value="" placeholder="TOKEN123">
                        </div>
                    </div>
                
                    <div class="btn-submit">
                        <button type="submit">Submit</button>
                    </div> 
                </div>
            </form>
        </div>

        <script>
            // Convert date from YYYY-MM-DD to DD-MM-YYYY format before form submission
            document.querySelector('form').addEventListener('submit', function(e) {
                const startDateInput = document.getElementById('start_date');
                const endDateInput = document.getElementById('end_date');
                
                if (startDateInput.value) {
                    const startDate = new Date(startDateInput.value);
                    const formattedStartDate = String(startDate.getDate()).padStart(2, '0') + '-' + 
                                             String(startDate.getMonth() + 1).padStart(2, '0') + '-' + 
                                             startDate.getFullYear();
                    
                    // Create hidden input with formatted date
                    const hiddenStartInput = document.createElement('input');
                    hiddenStartInput.type = 'hidden';
                    hiddenStartInput.name = 'start_date';
                    hiddenStartInput.value = formattedStartDate;
                    this.appendChild(hiddenStartInput);
                    
                    // Disable original input to prevent duplicate submission
                    startDateInput.disabled = true;
                }
                
                if (endDateInput.value) {
                    const endDate = new Date(endDateInput.value);
                    const formattedEndDate = String(endDate.getDate()).padStart(2, '0') + '-' + 
                                           String(endDate.getMonth() + 1).padStart(2, '0') + '-' + 
                                           endDate.getFullYear();
                    
                    // Create hidden input with formatted date
                    const hiddenEndInput = document.createElement('input');
                    hiddenEndInput.type = 'hidden';
                    hiddenEndInput.name = 'end_date';
                    hiddenEndInput.value = formattedEndDate;
                    this.appendChild(hiddenEndInput);
                    
                    // Disable original input to prevent duplicate submission
                    endDateInput.disabled = true;
                }
            });
        </script>

        
        
        
        
    </body>

</html>
