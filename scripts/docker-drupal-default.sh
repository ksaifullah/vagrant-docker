#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Stop the execution of a script if a command or pipeline has an error.
set -e

# Print all executed commands to the terminal
set -x

# Drupal server parameters.
CONTAINER_NAME=$1
MYSQL_CONTAINER=$2

# Check if mysql container is already installed.
if [ -z "$(docker ps -a | grep ${MYSQL_CONTAINER})" ]; then
  echo "Drupal has a dependency of MySQL container."
  exit 0
else
  if [ -z "$(docker ps | grep ${MYSQL_CONTAINER})" ]; then
    docker start ${MYSQL_CONTAINER}
  fi
fi

# Check if drupal container is already installed.
if [ -z "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
  # Download 'mysql' docker image.
  docker pull drupal:latest

  # Run the 'mysql' docker image.
  docker run --name $CONTAINER_NAME \
    --link $MYSQL_CONTAINER:mysql \
    -p 80:80 \
    -d drupal:latest
else
  if [ -z "$(docker ps | grep ${CONTAINER_NAME})" ]; then
    docker start ${CONTAINER_NAME}
  fi
fi

echo "Drupal server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' ${CONTAINER_NAME})"
