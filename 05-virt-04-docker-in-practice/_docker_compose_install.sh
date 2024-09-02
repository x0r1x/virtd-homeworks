#!/bin/bash

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker} 
mkdir -p $DOCKER_CONFIG/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
sudo chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
sudo chmod -x /var/run/docker.sock
sudo adduser $USER docker
newgrp docker
docker compose version