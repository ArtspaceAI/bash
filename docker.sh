#!/bin/bash

# Update package list and install prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker's official APT repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package list again and install Docker
sudo apt-get update
sudo apt-get install -y docker-ce

# Add the current user to the Docker group
sudo usermod -aG docker $USER

# Apply the new group membership
newgrp docker

# Run the specified Docker container
docker run -d --name tm traffmonetizer/cli_v2 start accept --token BwMj5pLJlpL+Y7COGlt6Xqk3pJHxnn68DC033tP9tjw=
