# Day#29: EDR Basics - Detecting Suspicious Network Traffic using Suricata

---

## 🎯 Objective

To understand how an Endpoint Detection and Response (EDR) solution can detect suspicious network traffic using Suricata IDS and visualize alerts on Wazuh.

---

## 📚 What is Suspicious Network Traffic?

Suspicious network traffic refers to abnormal or unexpected activities on a network that may indicate malicious intent or an ongoing attack.

### 🔍 Examples:
- A machine scanning multiple ports on the network (e.g., Nmap Scan).
- Traffic to known malicious IPs (Command & Control).
- FTP uploads on non-standard ports.
- HTTP connections to rare domains or IPs.

---

## 🔐 How are IDSs Helpful?

Intrusion Detection Systems (IDS) provide the following benefits:

- Monitor and inspect network traffic in real time.
- Trigger alerts when known attack patterns are detected.
- Help detect reconnaissance, malware communication, and lateral movement.
- Provide visibility to SOC teams for early-stage attacks.

---

## ⚙️ How Does IDS Work?

1. **Packet Capture**: Captures and inspects each packet.
2. **Rule Matching**: Matches traffic patterns against rule sets.
3. **Alerting**: Triggers alerts when rules are matched.
4. **Integration**: Sends logs/alerts to SIEM platforms like Wazuh.

---

## 🐍 What is Suricata?

Suricata is an open-source, high-performance network IDS, IPS, and network monitoring engine.

### Features:
- Deep packet inspection
- Multi-threaded architecture
- Protocol identification (HTTP, TLS, DNS, etc.)
- JSON log output for easy integration
- Community rules for threat detection

---

## 🖥️ Lab Setup

| Component            | Description                                  |
|---------------------|----------------------------------------------|
| **Wazuh Server**     | Ubuntu Server with Wazuh Manager & Dashboard |
| **Wazuh Agent**      | Ubuntu with Suricata installed               |
| **Attacker Machine** | Kali Linux (for simulating attacks)          |

---

## 📌 Task: Detecting Port Scanning using Suricata + Wazuh

---


### Step 1: Installing Suricata and Rules

1. Install Suricata on the Ubuntu endpoint. We tested this process with version 6.0.8 and it can take some time:

```
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt-get update
sudo apt-get install suricata -y
```

2. Download and extract the Emerging Threats Suricata ruleset:

```
cd /tmp/ && curl -LO https://rules.emergingthreats.net/open/suricata-6.0.8/emerging.rules.tar.gz
sudo tar -xvzf emerging.rules.tar.gz && sudo mkdir /etc/suricata/rules && sudo mv rules/*.rules /etc/suricata/rules/
sudo chmod 640 /etc/suricata/rules/*.rules
```
3. Restart the Suricata service:
```
sudo systemctl restart suricata
```
4. Add the following configuration to the /var/ossec/etc/ossec.conf file of the Wazuh agent. This allows the Wazuh agent to read the Suricata logs file:
```
<ossec_config>
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
</ossec_config>
```

### Step 3: Simulate Attack using Kali Linux

On Kali Linux terminal, run a SYN scan:
```bash
nmap -sS -T4 <target-ip>
```
`-sS`: SYN scan

`-T4`: Faster scan timing

This scan should trigger Suricata detection rules for port scanning.

### Step 4: View Alerts in Wazuh Dashboard
Login to Wazuh Dashboard.

Navigate to Security Events → Choose agent.

Filter by Rule Group: Suricata

Look for alert like:

ET SCAN Nmap Synchronous Scan

## Submission
Submit screenshots of:
- Suricata service running
- Alert in Wazuh Dashboard


## Learning Outcome
By completing this lab, you will:
- Understand the basics of IDS and Suricata.
- Install and configure Suricata to monitor traffic.
- Detect and respond to a port scanning attack.
- Visualize network alerts on Wazuh SIEM.
- Gain hands-on experience with EDR concepts.

