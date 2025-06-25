
<h1 align="center">🛡️ LeakFinder Sentinel v1 - Ghost Edition</h1>
<p align="center"><i>Cyber Surveillance & Defense Framework by <b>Mocarlow Cyber Labs</b></i></p>

---

🔍 Overview

LeakFinder Sentinel is a modular, stealth-ready, and encrypted CLI tool designed for network leak detection and cyber surveillance. It checks for public IP leaks, DNS misconfigurations, Tor connectivity, and performs network risk analysis via a custom scoring engine. Built for ethical hackers, privacy advocates, and security enthusiasts.

---

🚀 Features

- Multi-Source IP Leak Detection: Verify your public IP via multiple APIs.
- DNS Leak Test: Analyze DNS server settings from resolv.conf (or alternative paths) using dig.
- Tor Status & Anonymity Checker: Confirms your Tor connectivity.
- Risk Engine: Calculates an exposure score ranging from 0 to 100.
- Ghost Mode: Runs the tool discreetly by hiding its files and encrypting logs.
- AES-256 Encryption: Secures generated log reports.
- Webhook Notifications: Send JSON-formatted reports to Discord/Telegram via a webhook.
- Local Flask Dashboard: View logs and reports in real time at http://127.0.0.1:6969.

---

⚙️ Prerequisites

On Linux / Termux:

Ensure you have the following installed:
`
apt update && apt install curl torsocks net-tools openssl dnsutils python3 python3-pip -y
pip3 install flask
`

Optional (for Tor functionality):

- Tor:  
  - On Termux: pkg install tor  
  - On Debian-based systems: sudo apt install tor

- Git & SSH: Set up Git (and an SSH key) if you plan to push your code to GitHub.

---

📦 Installation

Clone the repository and configure the project:
`
git clone https://github.com/mocarlow/leakfinder-sentinel.git
cd leakfinder-sentinel
chmod +x sentinel.sh dashboard.py
`

---

🧪 Usage

Launch the Main Tool:
`
./sentinel.sh
`
Use the on-screen menu to perform checks such as IP leak detection, DNS tests, risk evaluation, and more.

Launch the Flask Dashboard:
`
python3 dashboard.py
`
Then open your browser and navigate to http://127.0.0.1:6969 to view your logs.

---

🧾 Configuration

You can optionally create a config.cfg file in the project root to customize settings:
`
WEBHOOK_URL="https://your-webhook-url.example.com"
ENCRYPTIONPASS="yourcustom_password"
`

---

🕶 Ghost Mode

Activate Ghost Mode from the main menu (option 10) to hide the tool by copying the script to a hidden directory and encrypting log files. This enhances stealth and privacy.

---

⚠️ Legal & Ethical Notice

This tool is provided for educational and ethical purposes only. Unauthorized scanning or monitoring of networks without explicit permission is prohibited.

---

🤝 Contributing

Contributions, bug reports, and feature requests are welcome!  
Feel free to fork the repository and submit pull requests.

---

🇮🇷 نسخه فارسی

LeakFinder Sentinel یک ابزار مدولار، پنهان و رمزگذاری‌شده برای شناسایی نشت‌های شبکه و پایش سایبری است. این ابزار نشت آی‌پی، مشکلات DNS، وضعیت اتصال به تور و سطح ریسک شبکه را با استفاده از سیستم امتیازدهی سفارشی ارزیابی می‌کند. این پروژه برای هکرهای اخلاقی، دوستداران حریم خصوصی و علاقمندان به امنیت طراحی شده است.

---

💡 ارتباط و مشارکت

- GitHub: @mocarlow
- Telegram: @MocarlowHQ
- Website: https://mocarlow.github.io

---

<p align="center"><i>"From Terminal to Truth — Stay Invisible"</i><br><b>Mocarlow Cyber Labs</b></p>
