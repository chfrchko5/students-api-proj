#!/bin/bash

# package updates
sudo apt-get update && sudo apt-get upgrade

# install 'make' if not present
if which make &> /dev/null; then
    echo '"make" package is present'
else
    sudo apt-get install make
fi

# install 'docker' if not present
if which docker &> /dev/null; then
    echo "docker is present"
else
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
fi

# add vagrant user to the docker group
sudo usermod -aG docker vagrant
newgrp docker