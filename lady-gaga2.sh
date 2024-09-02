#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Changing to the root directory..."
# Make sure it's the root directory first
cd ..

echo "Updating packages..."
# Update packages and install necessary tools
sudo apt-get update -y
sudo apt-get -y install curl tar ca-certificates screen

echo "Checking if apphub is already downloaded..."
# Download, extract, and set up the application
if [ ! -f ../apphub-linux-amd64/apphub ]; then
  echo "Downloading apphub..."
  curl -o apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz
  echo "Extracting apphub..."
  tar -zxf apphub-linux-amd64.tar.gz
  echo "Cleaning up downloaded tar file..."
  rm -f apphub-linux-amd64.tar.gz
fi

echo "Starting apphub in a detached screen session..."
# Start apphub in a detached screen session
screen -S apphub-session -d -m sudo ../apphub-linux-amd64/apphub

echo "Waiting for the process to start up..."
# Wait for the process to start up (adjust as needed)
sleep 4

echo "Starting a new screen session for status check..."
# Start a new screen session for status check
screen -S status-check -d -m bash -c '../apphub-linux-amd64/apphub status; exec bash'

echo "Configuring gaganode..."
# Configure gaganode
sudo ./apps/gaganode/gaganode config set --token=zzpozuelztsyrtbc3ce802710170d4d3

echo "Restarting apphub..."
# Restart apphub
../apphub-linux-amd64/apphub restart

echo "Checking the status of the apphub again..."
# Check the status of the apphub again
../apphub-linux-amd64/apphub status

echo "Script execution completed."
