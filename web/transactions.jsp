
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" href="assets/css/style.css">
        <title>Transaction API V2</title>

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
            <h2>TRANSACTION API V2</h2>
            <hr>
            <form method="POST" action="transaction_status_response.jsp">
                
                <div class="main-form">
                    <h3>Mandatory Parameters</h3>
                    <hr>
                    <div class="mandatory-data">
                        <div class="form-field">
                            <label for="txnid">Transaction ID<sup>*</sup></label>
                            <input id="txnid" class="txnid" name="txnid" value="" required placeholder="ASD12345">
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
