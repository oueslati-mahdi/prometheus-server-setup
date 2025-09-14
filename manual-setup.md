

# 🛠️ Manual Installation of Prometheus on EC2 (Ubuntu)

This guide explains step by step how to install Prometheus **manually** with explanation of each command.

---


## 1. Update system packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y



## 2. Create a Prometheus system user
sudo useradd --no-create-home --shell /bin/false prometheus

# Creates a dedicated user "prometheus" that cannot log in.
# Running Prometheus under its own restricted user improves security.



## 3. Download Prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.55.0/prometheus-2.55.0.linux-amd64.tar.gz

# Downloads the official Prometheus release tarball from GitHub.
# We use /tmp as a working directory since it’s temporary.



## 4. Extract Prometheus
tar xvf prometheus-2.55.0.linux-amd64.tar.gz
cd prometheus-2.55.0.linux-amd64

# Extracts the archive and changes into the extracted directory.
# It contains the Prometheus binaries and default config files.



## 5. Move Prometheus binaries
sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/

# Moves the Prometheus (prometheus) and Prometheus tool (promtool) binaries
# to /usr/local/bin so they are available system-wide.



## 6. Create directories for Prometheus
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# /etc/prometheus → stores Prometheus configuration files
# /var/lib/prometheus → stores the time-series database (TSDB) data



## 7. Move configuration files
sudo mv consoles /etc/prometheus
sudo mv console_libraries /etc/prometheus
sudo mv prometheus.yml /etc/prometheus/

# Moves default console templates, libraries, and the main config file prometheus.yml
# into /etc/prometheus.



## 8. Set permissions
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Ensures that the "prometheus" user owns its config files and data directory.
# Only Prometheus should have permission to read/write these files.



## 9. Create a systemd service
sudo vim /etc/systemd/system/prometheus.service

## Paste the following content:
[Unit]
Description=Prometheus Monitoring
After=network.target

[Service]
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target

## 👉 This defines Prometheus as a systemd service.
## It tells systemd how to start Prometheus, which user to run it as, and which config/data directories to use.



## 10. Start Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# daemon-reload → reloads systemd to apply the new service file
# enable → makes Prometheus start automatically on boot
# start → launches Prometheus immediately




## 11. Verify Prometheus
sudo systemctl status prometheus
# Shows the status of the Prometheus service.
# Look for "Active: active (running)".



## 12. Access Prometheus Web UI
# Open your browser and go to:
http://<EC2-PUBLIC-IP>:9090

# Replace <EC2-PUBLIC-IP> with your server’s public IP address.
# ⚠️ Make sure port 9090 is open in your EC2 security group inbound rules.
