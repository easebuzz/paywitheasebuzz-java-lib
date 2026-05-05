<%-- 
    Document   : config
    Created on : Configuration for Easebuzz Payment Gateway
    Author     : Easebuzz
--%>
<%@ page import="java.io.PrintStream" %>
<%@ page import="javax.net.ssl.HttpsURLConnection" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.*" %>

<%!
    // ─── Merchant Configuration ───
    private static final String MERCHANT_KEY = "XXXXXXX";
    private static final String SALT = "XXXXXXX";
    private static final String ENVIRONMENT = "YOUR_ENV"; // "test" or "prod"
    
    // ─── Base URLs ───
    private static final String TEST_PAYMENT_BASE_URL = "https://testpay.easebuzz.in/";
    private static final String PROD_PAYMENT_BASE_URL = "https://pay.easebuzz.in/";
    private static final String TEST_DASHBOARD_BASE_URL = "https://testdashboard.easebuzz.in/";
    private static final String PROD_DASHBOARD_BASE_URL = "https://dashboard.easebuzz.in/";
    
    // ─── Getters ───
    public String getMerchantKey() { return MERCHANT_KEY; }
    public String getSalt() { return SALT; }
    public String getEnvironment() { return ENVIRONMENT; }
    public boolean isProduction() { return "prod".equals(ENVIRONMENT); }
    
    public String getPaymentBaseUrl() {
        return isProduction() ? PROD_PAYMENT_BASE_URL : TEST_PAYMENT_BASE_URL;
    }
    
    public String getDashboardBaseUrl() {
        return isProduction() ? PROD_DASHBOARD_BASE_URL : TEST_DASHBOARD_BASE_URL;
    }
    
    // ─── API Endpoints ───
    public String getInitiatePaymentUrl() { return getPaymentBaseUrl() + "payment/initiateLink"; }
    public String getTransactionUrl() { return getDashboardBaseUrl() + "transaction/v2.1/retrieve"; }
    public String getTransactionDateUrl() { return getDashboardBaseUrl() + "transaction/v2/retrieve/date"; }
    public String getRefundUrl() { return getDashboardBaseUrl() + "transaction/v2/refund"; }
    public String getRefundStatusUrl() { return getDashboardBaseUrl() + "refund/v1/retrieve"; }
    public String getPayoutUrl() { return getDashboardBaseUrl() + "settlements/v1/retrieve"; }

    // ─── Hash Generation ───
    public String generateHash(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(input.getBytes());
            byte[] digest = md.digest();
            StringBuilder hex = new StringBuilder();
            for (byte b : digest) {
                hex.append(String.format("%02x", 0xFF & b));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            return "";
        }
    }

    // ─── String Utilities ───
    public boolean empty(String s) {
        return s == null || s.trim().isEmpty();
    }

    public String clean(String s) {
        return s == null ? "" : s.trim();
    }

    // ─── API Call: Form-Encoded POST ───
    public String[] postFormRequest(String apiUrl, Map<String, String> params) throws Exception {
        StringBuilder body = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (body.length() > 0) body.append('&');
            body.append(URLEncoder.encode(entry.getKey(), "UTF-8"))
                .append('=')
                .append(URLEncoder.encode(entry.getValue(), "UTF-8"));
        }

        URL url = new URL(apiUrl);
        HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        con.setDoOutput(true);

        PrintStream ps = new PrintStream(con.getOutputStream());
        ps.print(body.toString());
        ps.close();

        return readApiResponse(con);
    }

    // ─── API Call: JSON POST ───
    public String[] postJsonRequest(String apiUrl, String jsonBody) throws Exception {
        URL url = new URL(apiUrl);
        HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setRequestProperty("Accept", "application/json");
        con.setDoOutput(true);

        PrintStream ps = new PrintStream(con.getOutputStream());
        ps.print(jsonBody);
        ps.close();

        return readApiResponse(con);
    }

    // ─── Read API Response (returns [responseCode, responseBody, errorMessage]) ───
    private String[] readApiResponse(HttpsURLConnection con) throws Exception {
        int code = con.getResponseCode();
        BufferedReader br = new BufferedReader(new InputStreamReader(
            code == HttpsURLConnection.HTTP_OK ? con.getInputStream() : con.getErrorStream()));
        StringBuilder res = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) res.append(line);
        br.close();
        con.disconnect();

        String responseBody = "";
        String errorMsg = "";
        if (code == HttpsURLConnection.HTTP_OK) {
            responseBody = res.toString();
        } else {
            errorMsg = "HTTP Error " + code + ": " + res.toString();
        }
        return new String[]{ String.valueOf(code), responseBody, errorMsg };
    }

    // ─── Parse JSON Response & Set JSTL Attributes ───
    public void parseAndSetResponse(HttpServletRequest req, String responseData) {
        if (empty(responseData)) return;
        try {
            JSONObject parsed = (JSONObject) new JSONParser().parse(responseData);
            req.setAttribute("formattedJson", formatJson(parsed.toJSONString()).replace("\\/", "/"));
            Object status = parsed.get("status");
            req.setAttribute("isApiSuccess", status != null &&
                (status.toString().equals("1") || status.toString().equalsIgnoreCase("true")));
        } catch (Exception e) {
            req.setAttribute("formattedJson", null);
            req.setAttribute("isApiSuccess", false);
        }
    }

    // ─── API Response Keys ───
    public static final int RESPONSE_CODE = 0;
    public static final int RESPONSE_BODY = 1;
    public static final int RESPONSE_ERROR = 2;

    // ─── Redirect URL Validation ───
    public boolean isValidRedirectUrl(String url) {
        return url.startsWith(getPaymentBaseUrl() + "pay/");
    }

    // ─── Set Common Response Attributes ───
    public void setResponseAttributes(HttpServletRequest req, String apiUrl, int httpStatus, String apiResponse, String errorMessage) {
        req.setAttribute("apiUrl", apiUrl);
        req.setAttribute("responseCode", httpStatus);
        req.setAttribute("errorMessage", errorMessage);
        req.setAttribute("responseData", apiResponse);
        parseAndSetResponse(req, apiResponse);
    }

    // ─── JSON Formatter ───
    public String formatJson(String json) {
        StringBuilder out = new StringBuilder();
        int indent = 0;
        boolean inQuotes = false;
        for (int i = 0; i < json.length(); i++) {
            char ch = json.charAt(i);
            switch (ch) {
                case '"':
                    out.append(ch);
                    if (i > 0 && json.charAt(i - 1) != '\\') inQuotes = !inQuotes;
                    break;
                case '{': case '[':
                    out.append(ch);
                    if (!inQuotes) { out.append('\n'); indent++; appendIndent(out, indent); }
                    break;
                case '}': case ']':
                    if (!inQuotes) { out.append('\n'); indent--; appendIndent(out, indent); }
                    out.append(ch);
                    break;
                case ',':
                    out.append(ch);
                    if (!inQuotes) { out.append('\n'); appendIndent(out, indent); }
                    break;
                case ':':
                    out.append(ch);
                    if (!inQuotes) out.append(' ');
                    break;
                default:
                    out.append(ch);
            }
        }
        return out.toString();
    }

    private void appendIndent(StringBuilder sb, int level) {
        for (int i = 0; i < level * 2; i++) sb.append(' ');
    }
%>
