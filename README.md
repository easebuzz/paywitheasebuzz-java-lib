# Easebuzz Payment Gateway - Java Integration Kit

A JSP-based integration kit for [Easebuzz Payment Gateway](https://easebuzz.in/) supporting payments, transaction lookup, refunds, and payouts.

---

## Prerequisites

- **Java JDK 8+** — [Download](https://adoptium.net/)
- **Apache Tomcat 9** — [Download](https://tomcat.apache.org/download-90.cgi)

Verify installations:
```bash
java -version
jar --version
```

Make sure Tomcat 9 is installed and enabled:
```bash
# Check if Tomcat is running
sudo systemctl status tomcat9

# If not running, enable and start it
sudo systemctl enable tomcat9
sudo systemctl start tomcat9
```

> **Note:** If your system does not have `systemctl` (e.g. older Linux, WSL, or Docker), use the Tomcat scripts directly:
> ```bash
> <tomcat-install-dir>/bin/startup.sh    # Start
> <tomcat-install-dir>/bin/shutdown.sh   # Stop
> ```

---

## Getting Started

### Clone or Download

```bash
git clone https://github.com/<your-org>/paywitheasebuzz-java-lib.git
cd paywitheasebuzz-java-lib
```

Or download the ZIP from GitHub and extract it.

### Option A: Using Eclipse

1. Open Eclipse → **File** → **Import** → **General** → **Existing Projects into Workspace**
2. Click **Browse**, select the `paywitheasebuzz-java-lib` folder, and click **Finish**
   - Eclipse will auto-detect it as a Dynamic Web Module project (Java 1.8, Servlet 4.0)
3. Edit `web/config.jsp` with your credentials (see [Step 1](#step-1-add-your-credentials) below)
4. Right-click the project → **Export** → **Web** → **WAR file**
5. Set the destination path and click **Finish**
6. Copy the exported WAR to Tomcat's `webapps/` folder (see [Step 4](#step-4-deploy-the-war-file))
7. Restart Tomcat (see [Step 5](#step-5-restart-tomcat))

### Option B: Using VS Code / Terminal

No IDE setup needed — just use the terminal:

1. Edit `web/config.jsp` with your credentials (see [Step 1](#step-1-add-your-credentials) below)
2. Build the WAR, deploy, and restart Tomcat by following [Step 2](#step-2-build-the-war-file) through [Step 5](#step-5-restart-tomcat)

> **Recommended VS Code extensions:** [JSP Language Support](https://marketplace.visualstudio.com/items?itemName=nicklasringqvist.jsp-lang-support) for syntax highlighting.

---

## Setup

### Step 1: Add Your Credentials

Open `web/config.jsp` and replace the placeholder values:

```jsp
private static final String MERCHANT_KEY = "YOUR_KEY";
private static final String SALT = "YOUR_SALT";
private static final String ENVIRONMENT = "YOUR_ENV"; // "test" or "prod"
```

### Step 2: Build the WAR File

You must `cd` into the `web/` directory first, then create the WAR:

```bash
cd paywitheasebuzz-java-lib/web
jar cf ../Easebuzz_javaKit.war .
```

This creates `Easebuzz_javaKit.war` in the project root.

### Step 3: Find Your Tomcat Webapps Path

The `webapps` directory location depends on how Tomcat was installed:

| Installation Method | Typical Path |
|---------------------|-------------|
| apt/yum (Linux) | `/var/lib/tomcat9/webapps/` |
| Manual download | `<tomcat-install-dir>/webapps/` |
| macOS (Homebrew) | `/usr/local/opt/tomcat/libexec/webapps/` |
| Windows | `C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\` |

### Step 4: Deploy the WAR File

Copy the WAR file to Tomcat's `webapps` directory:

**Linux (package install):**
```bash
sudo cp Easebuzz_javaKit.war /var/lib/tomcat9/webapps/
```

**Linux/macOS (manual install):**
```bash
cp Easebuzz_javaKit.war <tomcat-install-dir>/webapps/
```

**Windows:**
```cmd
copy Easebuzz_javaKit.war "C:\path\to\tomcat\webapps\"
```

### Step 5: Restart Tomcat

Restart Tomcat so it picks up the new WAR file:

**Linux (systemd — most common):**
```bash
sudo systemctl restart tomcat9
```

**Linux/macOS (if `systemctl` is not available — manual install, WSL, or Docker):**
```bash
<tomcat-install-dir>/bin/shutdown.sh
<tomcat-install-dir>/bin/startup.sh
```

**Linux (using service command):**
```bash
sudo service tomcat9 restart
```

**Windows:**
```cmd
<tomcat-install-dir>\bin\shutdown.bat
<tomcat-install-dir>\bin\startup.bat
```

Then open: `http://localhost:8080/Easebuzz_javaKit/`

---

## Redeploying After Changes

If you modify any file inside the `web/` directory (e.g. `config.jsp`, any JSP, CSS, or JARs), you must rebuild and redeploy:

```bash
# 1. Rebuild the WAR
cd paywitheasebuzz-java-lib/web
jar cf ../Easebuzz_javaKit.war .

# 2. Copy to Tomcat (use sudo if needed)
sudo cp ../Easebuzz_javaKit.war /var/lib/tomcat9/webapps/

# 3. Restart Tomcat (use whichever command works on your system)
sudo systemctl restart tomcat9
# OR
sudo service tomcat9 restart
# OR (manual install)
<tomcat-install-dir>/bin/shutdown.sh && <tomcat-install-dir>/bin/startup.sh
```

> **Note:** All three steps are required. Just copying the WAR without restarting may not pick up your changes.


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
paywitheasebuzz-java-lib/
├── web/                              ← Web application root (WAR content)
│   ├── config.jsp                    ← ⚙️ Your credentials go here
│   ├── index.jsp                     ← Homepage
│   ├── initiatepayment.jsp           ← Payment form
│   ├── initiate_payment_invoke.jsp   ← Payment processing
│   ├── transactions.jsp              ← Transaction status form
│   ├── transaction_status_return.jsp   ← Transaction response handler
│   ├── transactionDate.jsp           ← Date-wise transaction form
│   ├── transaction_date_return.jsp   ← Date transaction response handler
│   ├── refund.jsp                    ← Refund form
│   ├── refund_return.jsp             ← Refund response handler
│   ├── refund_status.jsp             ← Refund status form
│   ├── refund_status_return.jsp      ← Refund status response handler
│   ├── payout.jsp                    ← Payout form
│   ├── payout_return.jsp             ← Payout response handler
│   ├── response.jsp                  ← Payment response handler
│   ├── test_config.jsp               ← Test configuration
│   ├── assets/
│   │   ├── css/style.css             ← Styles
│   │   └── images/                   ← Logo images
│   ├── META-INF/
│   │   └── context.xml               ← Tomcat context config
│   └── WEB-INF/
│       ├── web.xml                   ← Deployment descriptor
│       ├── functions.tld             ← Tag library descriptor
│       └── lib/                      ← Required JARs (included)
│           ├── json-simple-1.1.1.jar
│           └── jstl-1.2.jar
├── src/                              ← Source root
│   ├── java/                         ← Java source files (if any)
│   └── conf/
│       └── MANIFEST.MF
├── .project                          ← Eclipse project config
├── .classpath                        ← Eclipse classpath config
├── .gitignore                        ← Git ignore rules
├── build.xml                         ← Ant build file (NetBeans)
├── server.xml                        ← Reference Tomcat server config (not used at runtime)
├── web.xml                           ← Reference Tomcat global web.xml (not used at runtime)
└── README.md
```

> **Note:** The `server.xml` and `web.xml` in the project root are Tomcat reference files for documentation purposes only. The actual deployment descriptor used by the app is `web/WEB-INF/web.xml`.

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
- Check Tomcat logs: `sudo tail -f /var/lib/tomcat9/logs/catalina.out`
- Verify the WAR was extracted: check for `Easebuzz_javaKit/` folder inside `webapps/`

**Hash errors?**
- Verify your `MERCHANT_KEY` and `SALT` in `config.jsp`
- Make sure `ENVIRONMENT` matches your credentials (test key → `"test"`)

**Changes not reflecting after redeploy?**
- Make sure you rebuilt the WAR (`jar cf`) after making changes
- Make sure you copied the new WAR to `webapps/`
- Restart Tomcat — a restart is required for changes to take effect

**Port 8080 already in use?**
```bash
# Find what's using port 8080
lsof -i :8080

# Or change Tomcat port in <tomcat>/conf/server.xml
```

**Permission denied when copying WAR?**
```bash
# Use sudo for package-installed Tomcat
sudo cp Easebuzz_javaKit.war /var/lib/tomcat9/webapps/
```

---

## Support

- **Docs:** https://docs.easebuzz.in/
- **Email:** pgsupport@easebuzz.in
- **Website:** https://easebuzz.in/
