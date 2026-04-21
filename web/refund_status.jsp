<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" href="assets/css/style.css">
        <title>Refund Status Check</title>
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
                <h2>REFUND STATUS API</h2>
                <hr>
                <form action="refund_status_return.jsp" method="post" name="RefundStatusForm" onsubmit="return validateRefundStatusForm()">
                    <div class="main-form">
                        <h3>Mandatory Parameters</h3>
                        <hr>
                        <div class="mandatory-data">

                            <div class="form-field">
                                <label for="easebuzz_id">Easebuzz Transaction ID<sup>*</sup></label>
                                <input id="easebuzz_id" class="easebuzz_id" name="easebuzz_id" value="" required placeholder="SBD12345" pattern="^[a-zA-Z0-9]*$" title="Only alphanumeric characters allowed">
                            </div>
                        </div>

                        <h3>Optional Parameters</h3>
                        <hr>
                        <div class="optional-data">
                            <div class="form-field">
                                <label for="merchant_refund_id">Merchant Refund ID</label>
                                <input id="merchant_refund_id" class="merchant_refund_id" name="merchant_refund_id" value="" placeholder="REF123" pattern="^[a-zA-Z0-9_-]*$" title="Only alphanumeric characters, underscores, and hyphens allowed">
                            </div>
                        </div>

                        <div class="btn-submit">
                            <button type="submit">CHECK STATUS</button>
                        </div>

                    </div>
                </form>
            </div>

        </div>
    </body>

    <script>
        function validateRefundStatusForm() {
            return true;
        }
    </script>
</html>