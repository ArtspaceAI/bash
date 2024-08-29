#!/bin/bash

# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index again after adding Docker repository
sudo apt-get update -y

# Install Docker Engine, Docker CLI, and Containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker

# Verify that Docker is installed correctly by running the hello-world image
sudo docker run hello-world

echo "Docker has been successfully installed!"

# Optional: Add your user to the docker group to run docker commands without sudo
read -p "Do you want to add your user to the docker group? (y/n): " add_to_group

if [ "$add_to_group" = "y" ]; then
    sudo usermod -aG docker $USER
    echo "You have been added to the docker group. Please log out and back in for this change to take effect."
fi
