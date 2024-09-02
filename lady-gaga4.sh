#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Changing to the root directory...${NC}"
# Make sure it's the root directory first
cd ..

echo -e "${GREEN}Updating packages...${NC}"
# Update packages and install necessary tools
sudo apt-get update -y
sudo apt-get -y install curl tar ca-certificates screen

echo -e "${GREEN}Checking if apphub is already downloaded...${NC}"
# Download, extract, and set up the application
if [ ! -f ../apphub-linux-amd64/apphub ]; then
  echo -e "${GREEN}Downloading apphub...${NC}"
  curl -o apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz
  echo -e "${GREEN}Extracting apphub...${NC}"
  tar -zxf apphub-linux-amd64.tar.gz
  echo -e "${GREEN}Cleaning up downloaded tar file...${NC}"
  rm -f apphub-linux-amd64.tar.gz
fi

echo -e "${GREEN}Starting apphub in a detached screen session...${NC}"
# Start apphub in a detached screen session
screen -S apphub-session -d -m sudo ../apphub-linux-amd64/apphub

echo -e "${GREEN}Waiting for the process to start up...${NC}"
# Wait for the process to start up (adjust as needed)
sleep 4

echo -e "${GREEN}Starting a new screen session for status check...${NC}"
# Start a new screen session for status check
screen -S status-check -d -m bash -c '../apphub-linux-amd64/apphub status; exec bash'

echo -e "${GREEN}back to Apphub Folder cd ../apphub-linux-amd64/ ...${NC}" 
cd ../apphub-linux-amd64/ 

echo -e "${GREEN}Configuring gaganode...${NC}"
# Configure gaganode
sudo ./apps/gaganode/gaganode config set --token=zzpozuelztsyrtbc3ce802710170d4d3

echo -e "${GREEN}Restarting apphub...${NC}"
# Restart apphub
../apphub-linux-amd64/apphub restart

echo -e "${GREEN}Checking the status of the apphub again...${NC}"
# Check the status of the apphub again
../apphub-linux-amd64/apphub status

echo -e "${GREEN}Script execution completed.${NC}"
