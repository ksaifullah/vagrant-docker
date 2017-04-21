#!/bin/bash

# https://docs.docker.com/engine/installation/linux/ubuntu

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Check if docker is already installed.
which docker &> /dev/null
if [[ $? == 1 ]]; then :
  # If exit status is 1, go and install docker below.
else
  exit 0
fi

# Update package information.
apt-get update > /dev/null

# Install packages to allow apt to use a repository over HTTPS:
apt-get install apt-transport-https --assume-yes
apt-get install ca-certificates --assume-yes
apt-get install curl --assume-yes
apt-get install software-properties-common --assume-yes

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable docker repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

# Update package information.
apt-get update > /dev/null

# Install the latest version of Docker
echo "********************** Install Docker **********************"
apt-get install docker-ce --assume-yes
echo "********************** Done **********************"

# Uninstall docker.
# sudo apt-get purge docker-ce
