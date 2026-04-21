# Easebuzz Payment Gateway - Java Integration Kit

A JSP-based integration kit for [Easebuzz Payment Gateway](https://easebuzz.in/) supporting payments, transaction lookup, refunds, and payouts.

---

## Prerequisites

- **Java JDK 8+** — [Download](https://adoptium.net/)
- **Apache Tomcat 8.5+** — [Download](https://tomcat.apache.org/download-90.cgi)

Verify Java is installed:
```bash
java -version
```

---

## Setup (3 Steps)

### Step 1: Add Your Credentials

Open `web/config.jsp` and replace with your Easebuzz credentials:

```jsp
private static final String MERCHANT_KEY = "YOUR_KEY";
private static final String SALT = "YOUR_SALT";
private static final String ENVIRONMENT = "test"; // use "prod" for live
```

### Step 2: Build the WAR File

```bash
cd paywitheasebuzz-java-lib/web
jar cf ../Easebuzz_javaKit.war .
```

This creates `Easebuzz_javaKit.war` in the project root.

### Step 3: Deploy to Tomcat

Copy the WAR file to Tomcat's `webapps` folder:

**Linux/macOS:**
```bash
cp Easebuzz_javaKit.war /path/to/tomcat/webapps/
```

**Windows:**
```cmd
copy Easebuzz_javaKit.war "C:\path\to\tomcat\webapps\"
```

Start (or restart) Tomcat, then open:

```
http://localhost:8080/Easebuzz_javaKit/
```

---

## Available APIs

| API | Page | Description |
|-----|------|-------------|
| Initiate Payment | `/initiatepayment.jsp` | Start a new payment transaction |
| Transaction Status | `/transactions.jsp` | Check status of a transaction by ID |
| Transaction by Date | `/transactionDate.jsp` | Get transactions for a date range |
| Refund | `/refund.jsp` | Initiate a refund |
| Refund Status | `/refund_status.jsp` | Check refund status |
| Payout | `/payout.jsp` | Get settlement/payout details |

---

## Project Structure

```
web/
├── config.jsp              ← Your credentials go here
├── index.jsp               ← Homepage
├── initiatepayment.jsp     ← Payment form
├── transactions.jsp        ← Transaction status form
├── transactionDate.jsp     ← Date-wise transaction form
├── refund.jsp              ← Refund form
├── refund_status.jsp       ← Refund status form
├── payout.jsp              ← Payout form
├── response.jsp            ← Payment response handler
├── assets/css/style.css    ← Styles
└── WEB-INF/lib/            ← Required JARs (included)
```

---

## Environments

| Setting | Test | Production |
|---------|------|------------|
| `ENVIRONMENT` | `"test"` | `"prod"` |
| Payment URL | `testpay.easebuzz.in` | `pay.easebuzz.in` |
| Dashboard URL | `testdashboard.easebuzz.in` | `dashboard.easebuzz.in` |

> **Note:** Use `"test"` while developing. No real money is charged in test mode.

---

## Troubleshooting

**Page not loading?**
- Check if Tomcat is running: `http://localhost:8080`
- Check Tomcat logs: `<tomcat>/logs/catalina.out`

**Hash errors?**
- Verify your `MERCHANT_KEY` and `SALT` in `config.jsp`
- Make sure `ENVIRONMENT` matches your credentials (test key → `"test"`)

**Port 8080 already in use?**
```bash
# Find what's using port 8080
lsof -i :8080

# Or change Tomcat port in <tomcat>/conf/server.xml
```

---

## Support

- **Docs:** https://docs.easebuzz.in/
- **Email:** pgsupport@easebuzz.in
- **Website:** https://easebuzz.in/
