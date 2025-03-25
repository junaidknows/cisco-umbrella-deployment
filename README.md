# 🚀 Cisco Secure Client Deployment Script (v5.1.8.122)

This batch script is built to cleanly uninstall any existing versions of Cisco Secure Client and install the latest version (5.1.8.122) — including VPN, Umbrella, and DART modules. It's intended to run silently in the background using a GPO Startup Script for scalable enterprise-wide deployment.

---

## ✅ What This Script Does

- Detects if **version 5.1.8.122** *or any previous version* is already installed
- If not, silently:
  - Uninstalls any older Cisco Secure Client components
  - Installs:
    - Core VPN module
    - Umbrella module
    - Diagnostics and Reporting Tool (DART)
  - Copies the `OrgInfo.json` for Umbrella registration
  - Creates a marker file to **prevent reinstallation on future boots**
---

## 🛠️ Usage Guide

### 📂 1. Required Files

Place the following in a **shared folder accessible by all domain machines**, e.g., `\\srv-dc01\NETLOGON\Software`:

- `cisco-secure-client-win-5.1.8.122-core-vpn-predeploy-k9.msi`
- `cisco-secure-client-win-5.1.8.122-umbrella-predeploy-k9.msi`
- `cisco-secure-client-win-5.1.8.122-dart-predeploy-k9.msi`
- `OrgInfo.json`
- `deploy_cisco_secure_client.bat` (this script is available in this repository in .bat format)

> 📌 Ensure `Domain Computers` have **read access** to this share.

---

### 🧠 2. What the Script Checks

On every reboot, the script:

- Checks if the machine already has version **5.1.8.122** installed
- If not, it:
  - Uninstalls older Secure Client components (VPN, Umbrella, DART)
  - Installs the correct version
  - Copies OrgInfo.json
  - Creates a marker at:  
    `C:\ProgramData\Cisco\CiscoClient_Deployed.txt`

If the correct version is already installed, the script silently exits.

---

### 🪪 3. Deploy via GPO (Startup Script)

1. Open **Group Policy Management Console** (`gpmc.msc`)
2. Create or edit an existing GPO
3. Navigate to:  
   `Computer Configuration → Windows Settings → Scripts (Startup)`
4. Add the script:  
   `deploy_cisco_secure_client.bat`
5. Link the GPO to the OU containing your target computers
6. Force Group Policy update or wait for natural cycle:
   ```powershell
   gpupdate /force


