
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" href="assets/css/style.css">
        <title>Transaction API</title>

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
            <h2>TRANSACTION API</h2>
            <hr>
            <form method="POST" action="transactions_return.jsp">
                
                <div class="main-form">
                    <h3>Mandatory Parameters</h3>
                    <hr>
                    <div class="mandatory-data">
                        <div class="form-field">
                            <label for="txnid">Merchant Transaction ID<sup>*</sup></label>
                            <input id="txnid" class="txnid" name="txnid" value="" required placeholder="ASD12345">
                        </div>
        
                        <div class="form-field">
                            <label for="amount">Transaction Amount<sup>(should be float)*</sup></label>
                            <input id="amount" class="amount" name="amount" value="" required placeholder="125.25">
                        </div>
        
                        <div class="form-field">
                            <label for="email">Customer Email ID<sup>*</sup></label>
                            <input id="email" class="email" name="email" value="" required placeholder="trasaction@easebuzz.in">
                        </div>
        
                        <div class="form-field">
                            <label for="phone">Customer Phone Number<sup>*</sup></label>
                            <input id="phone" class="phone" name="phone" value="" required placeholder="0123456789">
                        </div>
        
                                           
                    </div>
                    
                    <div class="btn-submit">
                        <button type="submit">Submit</button>  
                    </div> 
                </div>
            </form>

        </div>
    </body>

</html>
