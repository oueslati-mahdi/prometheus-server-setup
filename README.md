# 🚀 Prometheus Server Setup on EC2

This repository explains how to install and configure **Prometheus** on an **AWS EC2 Ubuntu server** in two ways:

1. **Manual Setup** – step by step commands with explanation.  
2. **Automated Script** – run one script and everything is done for you.  

Prometheus is an open-source monitoring solution designed for **time-series metrics collection**. It is often used with Grafana for dashboards and Alertmanager for notifications.

---

## 🔹 Method 1: Manual Setup

Follow the steps in [manual-setup.md](manual-setup.md) for a detailed walkthrough.  
Each command is explained so you understand what’s happening behind the scenes.

---

## 🔹 Method 2: Automated Script

For a quick installation:

```bash
git clone https://github.com/oueslati-mahdi/prometheus-server-setup.git
cd prometheus-server-setup
chmod +x install-prometheus.sh
sudo ./install-prometheus.sh
