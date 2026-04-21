<%-- 
    Document   : config
    Created on : Configuration for Easebuzz Payment Gateway
    Author     : Easebuzz
--%>

<%!
    // Merchant Configuration
    private static final String MERCHANT_KEY = "E1FF1YEHYI";
    private static final String SALT = "2LTR0WO628";
    private static final String ENVIRONMENT = "prod"; // "test" or "prod"
    
    // API Base URLs
    private static final String TEST_BASE_URL = "https://testpay.easebuzz.in/";
    private static final String PROD_BASE_URL = "https://pay.easebuzz.in/";
    
    private static final String TEST_DASHBOARD_URL = "https://testdashboard.easebuzz.in/";
    private static final String PROD_DASHBOARD_URL = "https://dashboard.easebuzz.in/";
    
    // Helper methods
    public String getMerchantKey() {
        return MERCHANT_KEY;
    }
    
    public String getSalt() {
        return SALT;
    }
    
    public String getEnvironment() {
        return ENVIRONMENT;
    }
    
    public boolean isProduction() {
        return "prod".equals(ENVIRONMENT);
    }
    
    public String getPaymentBaseUrl() {
        return isProduction() ? PROD_BASE_URL : TEST_BASE_URL;
    }
    
    public String getDashboardBaseUrl() {
        return isProduction() ? PROD_DASHBOARD_URL : TEST_DASHBOARD_URL;
    }
    
    public String getInitiatePaymentUrl() {
        return getPaymentBaseUrl() + "payment/initiateLink";
    }
    
    public String getTransactionUrl() {
        return getDashboardBaseUrl() + "transaction/v2.1/retrieve";
    }
    
    public String getTransactionDateUrl() {
        return getDashboardBaseUrl() + "transaction/v1/retrieve";
    }
    
    public String getRefundUrl() {
        return getDashboardBaseUrl() + "transaction/v2/refund";
    }
    
    public String getRefundStatusUrl() {
        return getDashboardBaseUrl() + "refund/v1/retrieve";
    }
    
    public String getPayoutUrl() {
        return getDashboardBaseUrl() + "settlements/v1/retrieve";
    }
%>