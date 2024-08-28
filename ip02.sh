#!/bin/bash

# Auto-detect primary network interface
INTERFACE=$(ip route show default | awk '{print $5}')

# Auto-detect operating system
OS=$(uname -s)

# Set IP configuration based on OS
if [ "$OS" = "Linux" ]; then
  # Ubuntu-specific configuration
  IP_ADDRESS="192.168.1.201/24"
  GATEWAY="192.168.1.1"
  DNS_SERVERS="8.8.8.8 4.4.4.4"
else
  echo "Unsupported operating system: $OS"
  exit 1
fi

# Apply network configuration
ip addr flush dev "$INTERFACE"
ip addr add "$IP_ADDRESS" dev "$INTERFACE"
ip link set dev "$INTERFACE" up
ip route add default via "$GATEWAY"
echo "Static IP setup complete. Your new IP is $IP_ADDRESS."
