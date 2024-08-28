#!/bin/bash

# Variables (Modify these according to your network configuration)
INTERFACE="enp0s3"
GATEWAY="192.168.1.1"
DNS1="8.8.8.8"
DNS2="8.8.4.4"
NETPLAN_CONFIG="/etc/netplan/01-netcfg.yaml"

# Prompt for the last octet of the IP address
read -p "Enter the last octet for the static IP (e.g., 100 for 192.168.1.100): " LAST_OCTET

# Construct the full static IP address
STATIC_IP="192.168.1.$LAST_OCTET/24"

# Step 1: Find the current IP configuration (optional - just for logging)
echo "Current IP Configuration:"
ip addr show $INTERFACE

# Step 2: Edit the network configuration file
echo "Updating network configuration to set static IP..."
sudo tee $NETPLAN_CONFIG > /dev/null <<EOL
network:
  version: 2
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses:
        - $STATIC_IP
      gateway4: $GATEWAY
      nameservers:
        addresses:
          - $DNS1
          - $DNS2
EOL

# Step 3: Apply the configuration
echo "Applying network configuration..."
sudo netplan apply

# Step 4: Restart the network service
echo "Restarting networking service..."
sudo systemctl restart networking

# Step 5: Verify the static IP address
echo "Verifying the new IP configuration..."
ip addr show $INTERFACE

echo "Static IP setup complete. Your new IP is $STATIC_IP."
