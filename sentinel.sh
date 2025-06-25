#!/bin/bash
# LeakFinder Sentinel v1 - Ghost Edition
# A Cyber Surveillance & Defense Tool by Mocarlow Cyber Labs
# Version: v1.0
# Author: Mocarlow
# License: MIT

# Load configuration file if it exists
CONFIG_FILE="./config.cfg"
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
fi

# Default encryption password (override in config.cfg if desired)
ENCRYPTION_PASS="${ENCRYPTION_PASS:-mocarlow2025}"

# Colors
RED="\e[31m"
GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
NC="\e[0m"

# Create logs directory
LOG_DIR="logs"
mkdir -p "$LOG_DIR"

# Global report variables
report_ip=""
report_dns=""
report_tor=""
report_risk=""
report_network=""
report_webrtc=""

#######################################
# Banner display
banner() {
  clear
  echo -e "${CYAN}"
  echo "=========================================="
  echo "  LeakFinder Sentinel v1 - Ghost Edition  "
  echo "      by Mocarlow Cyber Labs             "
  echo "=========================================="
  echo -e "${NC}"
}

#######################################
# Function: Check Public IP Leak
check_ip_leak() {
  echo -e "${YELLOW}[*] Checking Public IP Leak...${NC}"
  local ip1=$(curl -s ifconfig.me)
  local ip2=$(curl -s ipinfo.io/ip)
  local local_ip=$(ip addr show | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d/ -f1 | head -n 1)
  
  echo -e "Public IP (ifconfig.me): ${GREEN}$ip1${NC}"
  echo -e "Public IP (ipinfo.io): ${GREEN}$ip2${NC}"
  echo -e "Local IP: ${CYAN}$local_ip${NC}"
  
  if [[ "$ip1" == "$ip2" && "$ip1" != "$local_ip" ]]; then
    echo -e "${GREEN}[✔] No IP leak detected.${NC}"
    leak_status="No leak"
  else
    echo -e "${RED}[⚠] Potential IP leak detected!${NC}"
    leak_status="Potential leak"
  fi
  
  report_ip="Public IPs: $ip1, $ip2; Local IP: $local_ip; Status: $leak_status"
}

#######################################
# Function: Check DNS Leak
check_dns_leak() {
  echo -e "${YELLOW}[*] Checking DNS Leak...${NC}"
  local dns_servers=$(grep -i "nameserver" /etc/resolv.conf | awk '{print $2}' | xargs)
  echo -e "DNS Servers: ${GREEN}$dns_servers${NC}"
  
  # Use dig to query a known domain (whoami.akamai.net)
  local dig_result=$(dig +short whoami.akamai.net)
  echo -e "Dig (whoami.akamai.net): ${CYAN}$dig_result${NC}"
  
  if [[ -z "$dig_result" ]]; then
    echo -e "${RED}[⚠] DNS Leak Test Failed!${NC}"
    dns_status="Failed"
  else
    echo -e "${GREEN}[✔] DNS leak test passed.${NC}"
    dns_status="OK"
  fi
  
  report_dns="DNS Servers: $dns_servers; Dig result: $dig_result; Status: $dns_status"
}

#######################################
# Function: Check Tor Status
check_tor_status() {
  echo -e "${YELLOW}[*] Checking Tor Status...${NC}"
  local tor_ip=$(torsocks curl -s https://check.torproject.org/api/ip 2>/dev/null | grep -oP '(?<="IP":")[^"]+')
  if [[ -z "$tor_ip" ]]; then
    echo -e "${RED}[✘] Tor connection failed or torsocks not installed.${NC}"
    tor_status="Inactive"
  else
    echo -e "${GREEN}[✔] Tor is active. Tor IP: $tor_ip${NC}"
    tor_status="Active"
  fi
  
  report_tor="Tor Status: $tor_status; Tor IP: $tor_ip"
}

#######################################
# Function: Simulated Network Watch
network_watch_simulation() {
  echo -e "${YELLOW}[*] Scanning network for suspicious devices...${NC}"
  local devices=$(netstat -tn 2>/dev/null | awk '{print $5}' | cut -d: -f1 | sort | uniq | grep -v '^0.0.0.0' | grep -v '^127.')
  echo -e "Connected devices (IP addresses): ${GREEN}$devices${NC}"
  
  # Dummy risk points: if more than 3 devices found, add risk points
  local count=$(echo "$devices" | wc -l)
  local risk_points=0
  if [ "$count" -gt 3 ]; then
    risk_points=10
  fi
  
  echo -e "Network risk points: ${CYAN}$risk_points${NC}"
  report_network="Network Devices: $devices; Risk Points: $risk_points"
  echo $risk_points
}

#######################################
# Function: Risk Engine Calculation
risk_engine() {
  echo -e "${YELLOW}[*] Running Risk Engine...${NC}"
  local risk_score=0
  
  # Require that IP leak, DNS, and Tor checks are executed prior to risk evaluation.
  if [[ "$leak_status" == "Potential leak" ]]; then
    risk_score=$((risk_score + 40))
  fi
  if [[ "$dns_status" != "OK" ]]; then
    risk_score=$((risk_score + 30))
  fi
  if [[ "$tor_status" != "Active" ]]; then
    risk_score=$((risk_score + 20))
  fi
  
  # Add network risk from simulation (0-10)
  local net_risk=$(network_watch_simulation)
  risk_score=$((risk_score + net_risk))
  
  # Limit maximum risk score to 100
  if [ $risk_score -gt 100 ]; then
    risk_score=100
  fi
  
  echo -e "Calculated Risk Score: ${CYAN}$risk_score${NC} / 100"
  report_risk="Risk Score: $risk_score / 100"
}

#######################################
# Function: Dummy WebRTC Leak Check
webrtc_check() {
  echo -e "${YELLOW}[*] Checking WebRTC Leak (simulation)...${NC}"
  # WebRTC detection is non-trivial in CLI; we simulate the check.
  local webrtc_status="Not Implemented"
  echo -e "${CYAN}[i] WebRTC check is available only in environments with browser integration.${NC}"
  report_webrtc="WebRTC Leak: $webrtc_status"
}

#######################################
# Function: Save and Encrypt Log Report
save_log() {
  echo -e "${YELLOW}[*] Saving report log...${NC}"
  local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
  local log_file="${LOG_DIR}/sentinel_${timestamp}.log"
  
  {
    echo "LeakFinder Sentinel Report"
    echo "Timestamp: $(date)"
    echo "---------------------------------"
    echo "$report_ip"
    echo "$report_dns"
    echo "$report_tor"
    echo "$report_risk"
    echo "$report_network"
    echo "$report_webrtc"
  } > "$log_file"
  
  echo -e "${GREEN}[✔] Report saved to $log_file${NC}"
  
  # Encrypt the log file using OpenSSL (AES-256-CBC)
  local encrypted_log="${log_file}.enc"
  openssl enc -aes-256-cbc -salt -in "$log_file" -out "$encrypted_log" -k "$ENCRYPTION_PASS" 2>/dev/null
  
  if [ -f "$encrypted_log" ]; then
    echo -e "${GREEN}[✔] Log encrypted and saved as $encrypted_log${NC}"
  else
    echo -e "${RED}[✘] Log encryption failed.${NC}"
  fi
}

#######################################
# Function: Send Report to Webhook
send_webhook() {
  echo -e "${YELLOW}[*] Sending report to webhook...${NC}"
  if [ -z "$WEBHOOK_URL" ]; then
    echo -e "${RED}[✘] WEBHOOK_URL is not set in $CONFIG_FILE.${NC}"
    return
  fi
  
  # Create JSON payload from the reports
  json_payload=$(cat <<EOF
{
  "title": "LeakFinder Sentinel Report",
  "timestamp": "$(date)",
  "report": {
      "IP": "$report_ip",
      "DNS": "$report_dns",
      "Tor": "$report_tor",
      "Risk": "$report_risk",
      "Network": "$report_network",
      "WebRTC": "$report_webrtc"
  }
}
EOF
)
  # Send payload via curl
  curl -H "Content-Type: application/json" -X POST -d "$json_payload" "$WEBHOOK_URL" >/dev/null 2>&1
  echo -e "${GREEN}[✔] Report sent to webhook.${NC}"
}

#######################################
# Function: Launch Flask Local Dashboard
launch_flask_dashboard() {
  echo -e "${YELLOW}[*] Launching local dashboard...${NC}"
  if command -v python3 &>/dev/null; then
    python3 dashboard.py
  else
    echo -e "${RED}[✘] Python3 is not installed. Cannot launch dashboard.${NC}"
  fi
}

#######################################
# Function: Activate Ghost Mode
ghost_mode() {
  echo -e "${YELLOW}[*] Activating Ghost Mode...${NC}"
  # Hide the script by copying it to a hidden directory
  HIDDEN_DIR="$HOME/.mocarlow_hidden"
  mkdir -p "$HIDDEN_DIR"
  cp "$0" "$HIDDEN_DIR/$(basename "$0")"
  echo -e "${GREEN}[✔] Script hidden in $HIDDEN_DIR as $(basename "$0")${NC}"
}

#######################################
# Main Menu Loop
while true; do
  banner
  echo -e "${CYAN}1) Check Public IP Leak${NC}"
  echo -e "${CYAN}2) Check DNS Leak${NC}"
  echo -e "${CYAN}3) Check Tor Status${NC}"
  echo -e "${CYAN}4) Run Risk Engine${NC}"
  echo -e "${CYAN}5) Run Network Watch (Simulation)${NC}"
  echo -e "${CYAN}6) Check WebRTC Leak (Simulation)${NC}"
  echo -e "${CYAN}7) Save and Encrypt Report Log${NC}"
  echo -e "${CYAN}8) Send Report to Webhook${NC}"
  echo -e "${CYAN}9) Launch Local Dashboard${NC}"
  echo -e "${CYAN}10) Activate Ghost Mode${NC}"
  echo -e "${CYAN}11) Exit${NC}"
  echo -ne "${YELLOW}Choose an option [1-11]: ${NC}"
  read choice
  
  case $choice in
    1) check_ip_leak ; read -p "Press Enter to continue..." ;;
    2) check_dns_leak ; read -p "Press Enter to continue..." ;;
    3) check_tor_status ; read -p "Press Enter to continue..." ;;
    4) risk_engine ; read -p "Press Enter to continue..." ;;
    5) network_watch_simulation > /dev/null ; read -p "Press Enter to continue..." ;;
    6) webrtc_check ; read -p "Press Enter to continue..." ;;
    7) save_log ; read -p "Press Enter to continue..." ;;
    8) send_webhook ; read -p "Press Enter to continue..." ;;
    9) launch_flask_dashboard ; read -p "Press Enter to continue..." ;;
    10) ghost_mode ; read -p "Press Enter to continue..." ;;
    11) echo -e "${GREEN}Exiting. Stay safe. - Mocarlow Cyber Labs${NC}" ; exit 0 ;;
    *) echo -e "${RED}Invalid option. Try again.${NC}" ; sleep 1 ;;
  esac
done
