#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Check if mysql container is already installed.
IMAGE="$(docker ps -a | grep drupal)"
if [[ ! -z $IMAGE ]]; then :
  echo "Drupal container already exists."
  exit 0
fi

# Download 'mysql' docker image.
docker pull drupal:latest

# Check if mysql container is already installed.
IMAGE="$(docker ps -a | grep mysql)"
if [[ -z $IMAGE ]]; then :
  echo "Drupal has a dependency of MySQL container."
  exit 0
fi

# Run the 'mysql' docker image.
docker run --name drupalstation \
  --link mysqlstation:mysql \
  -p 80:80 \
  -d drupal:latest

echo "Drupal server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' drupalstation)"
