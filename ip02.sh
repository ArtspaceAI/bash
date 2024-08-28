#!/bin/bash

INTERFACE=$(ip route show default | awk '{print $5}')
OS=$(uname -s)

if [ "$OS" = "Linux" ]; then
  IP_ADDRESS="192.168.1.201/24"
  GATEWAY="192.168.1.1"
  DNS_SERVERS="8.8.8.8 4.4.4.4"
  NETPLAN_FILE="/etc/netplan/01-netcfg.yaml"

  # Create Netplan configuration
  sudo bash -c "cat > $NETPLAN_FILE <<EOL
network:
  version: 2
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses:
        - $IP_ADDRESS
      gateway4: $GATEWAY
      nameservers:
        addresses:
          - 8.8.8.8
          - 4.4.4.4
EOL"

  # Apply Netplan configuration
  sudo netplan apply

  echo "Static IP setup complete. Your new IP is $IP_ADDRESS."
else
  echo "Unsupported operating system: $OS"
  exit 1
fi
