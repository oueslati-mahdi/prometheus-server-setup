#!/bin/bash

# Exit on error
set -e

PROM_VERSION="2.55.0"
PROM_USER="prometheus"


echo "==> Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y


echo "==> Creating Prometheus user..."
sudo useradd --no-create-home --shell /bin/false $PROM_USER || true


echo "==> Downloading Prometheus v$PROM_VERSION..."
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v$PROM_VERSION/prometheus-$PROM_VERSION.linux-amd64.tar.gz


echo "==> Extracting Prometheus..."
tar xvf prometheus-$PROM_VERSION.linux-amd64.tar.gz
cd prometheus-$PROM_VERSION.linux-amd64


echo "==> Moving binaries..."
sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/


echo "==> Creating directories..."
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus


echo "==> Moving configuration files..."
sudo mv consoles /etc/prometheus
sudo mv console_libraries /etc/prometheus
sudo mv prometheus.yml /etc/prometheus/


echo "==> Setting permissions..."
sudo chown -R $PROM_USER:$PROM_USER /etc/prometheus
sudo chown -R $PROM_USER:$PROM_USER /var/lib/prometheus
sudo chown $PROM_USER:$PROM_USER /usr/local/bin/prometheus
sudo chown $PROM_USER:$PROM_USER /usr/local/bin/promtool


echo "==> Creating systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=$PROM_USER
Group=$PROM_USER
Type=simple
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus/ \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF


echo "==> Reloading systemd and starting Prometheus..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus


echo "==> Installation complete!"
echo "Check status with: sudo systemctl status prometheus"
echo "Access Prometheus at: http://<your-ec2-public-ip>:9090"
