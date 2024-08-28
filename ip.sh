#!/bin/bash

# Variables (Modify these according to your network configuration)
GATEWAY="192.168.1.1"
DNS1="8.8.8.8"
DNS2="8.8.4.4"
NETPLAN_CONFIG="/etc/netplan/01-netcfg.yaml"
STATIC_IP="192.168.1.201/24"


# Function to check if netplan is installed
check_netplan() {
    if ! command -v netplan &> /dev/null; then
        echo "Netplan is not installed. Please install netplan.io."
        exit 1
    fi
}

# Function to detect the primary network interface
detect_interface() {
    INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')
    if [ -z "$INTERFACE" ]; then
        echo "No default network interface found."
        exit 1
    fi
    echo "Detected network interface: $INTERFACE"
}

# Function to check if the interface exists
check_interface() {
    if ! ip link show $INTERFACE &> /dev/null; then
        echo "Network interface $INTERFACE not found."
        exit 1
    fi
}


# Check if netplan is installed
check_netplan

# Detect the network interface
detect_interface

# Check if the network interface exists
check_interface

# Step 1: Find the current IP configuration (optional - just for logging)
echo "Current IP Configuration:"
ip addr show $INTERFACE

# Step 2: Edit the network configuration file
echo "Updating network configuration to set static IP..."
cat <<EOL > $NETPLAN_CONFIG
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

# Step 3: Prompt for confirmation
read -p "Do you want to apply this configuration? (y/n): " CONFIRMATION
if [ "$CONFIRMATION" != "y" ]; then
    echo "Configuration changes aborted."
    exit 0
fi

# Step 4: Apply the configuration
echo "Applying network configuration..."
netplan apply

# Step 5: Verify the static IP address
echo "Verifying the new IP configuration..."
ip addr show $INTERFACE

echo "Static IP setup complete. Your new IP is $STATIC_IP."
