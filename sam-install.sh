#!/bin/bash

cd "$HOME"
echo "Starting setup"
sudo apt-get update -y

echo "Installing AWS SAM"
curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install

echo "Installing docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "Installation finished"
sam --version
docker --version
