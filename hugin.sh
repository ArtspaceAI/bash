#!/bin/bash

# Update and upgrade the system
apt update && apt upgrade -y
#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install -y software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index
sudo apt update

# Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start Docker
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Verify Docker installation
sudo docker run hello-world

# Install necessary packages
sudo apt install -y sudo software-properties-common bash nano curl wget git

# Add the Mysterium Network repository and update
sudo add-apt-repository -y ppa:mysteriumnetwork/node
sudo apt-get update

# Install additional packages
sudo apt install -y bash nano curl wget git

# Install prerequisites for Huginn
sudo apt-get install -y runit build-essential zlib1g-dev libyaml-dev libssl-dev \
libgdbm-dev libreadline-dev libncurses5-dev libffi-dev libxml2-dev libxslt-dev \
libcurl4-openssl-dev libicu-dev logrotate pkg-config cmake nodejs graphviz jq \
shared-mime-info

# Install Ruby
sudo apt-get install -y ruby

# Clone Huginn repository
git clone https://github.com/huginn/huginn.git
cd huginn

# Install Bundler
gem install bundler

# Install Huginn dependencies
bundle install

# Set up the database
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

# Set up Huginn
bundle exec foreman start
