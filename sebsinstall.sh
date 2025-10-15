#!/bin/bash

# Move to home directory
cd ~

# -------------------------------
# Install Docker
# -------------------------------
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Add current user to docker group
sudo groupadd -f docker
sudo usermod -aG docker $USER
newgrp docker

# -------------------------------
# Clone serverless-benchmarks repo
# -------------------------------
echo "Cloning serverless-benchmarks..."
git clone https://github.com/seelism/serverless-benchmarks
cd serverless-benchmarks

# Install Python venv if not already installed
sudo apt update
sudo apt install -y python3-venv jq  # added jq as it's used later

# Run install script for cloud providers and local deployment
./install.py --aws --azure --gcp --openwhisk --local

# Activate virtual environment
. python-venv/bin/activate

# Build Docker images for Node.js 20 runtime
./tools/build_docker_images.py --deployment local --type run --language nodejs --language-version 20

# Tag the Docker image
docker tag spcleth/serverless-benchmarks:run.local.nodejs.20-1.2.0 \
           spcleth/serverless-benchmarks:run.local.nodejs.20

# Start storage services
./sebs.py storage start all config/storage.json --output-json out_storage.json

# Update local deployment configuration
jq '.deployment.local.storage = input' config/example.json out_storage.json > config/local_deployment.json

echo "Setup complete!"
