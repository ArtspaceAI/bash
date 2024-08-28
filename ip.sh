#!/bin/bash

# Variables (Modify these according to your network configuration)
GATEWAY="192.168.1.1"
DNS1="8.8.8.8"
DNS2="8.8.4.4"
NETPLAN_CONFIG="/etc/netplan/01-netcfg.yaml"

# Function to check for root privileges
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or with sudo."
        exit 1
    fi
}

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

# Prompt for the last octet of the IP address
read -p "Enter the last octet for the static IP (e.g., 100 for 192.168.1.100): " LAST_OCTET

# Validate last octet input
if ! [[ "$LAST_OCTET" =~ ^[0-9]+$ ]] || [ "$LAST_OCTET" -lt 1 ] || [ "$LAST_OCTET" -gt 254 ]; then
    echo "Invalid last octet. Please enter a number between 1 and 254."
    exit 1
fi

# Construct the full static IP address
STATIC_IP="192.168.1.$LAST_OCTET/24"

# Check for root privileges
check_root

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

# Step 3: Prompt for confirmation
read -p "Do you want to apply this configuration? (y/n): " CONFIRMATION
if [ "$CONFIRMATION" != "y" ]; then
    echo "Configuration changes aborted."
    exit 0
fi

# Step 4: Apply the configuration
echo "Applying network configuration..."
sudo netplan apply

# Step 5: Verify the static IP address
echo "Verifying the new IP configuration..."
ip addr show $INTERFACE

echo "Static IP setup complete. Your new IP is $STATIC_IP."
