#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Name of the container.
CONTAINER_NAME=$1

# Stop the execution of a script if a command or pipeline has an error.
set -e

# Print all executed commands to the terminal
set -x

# Check if mysql container is already installed.
if [ -z "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
  # Download 'mysql' docker image.
  docker pull mysql:latest

  # Run the 'mysql' docker image.
  docker run --name ${CONTAINER_NAME} \
    -e MYSQL_ROOT_PASSWORD=admin \
    -e MYSQL_DATABASE=drupal \
    -e MYSQL_USER=drupal \
    -e MYSQL_PASSWORD=drupal \
    -d mysql:latest
else
  if [ -z "$(docker ps | grep ${CONTAINER_NAME})" ]; then
    docker start ${CONTAINER_NAME}
  fi
fi

echo "MySQL default server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' ${CONTAINER_NAME})"
