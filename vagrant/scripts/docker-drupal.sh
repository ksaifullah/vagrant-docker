#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Check if mysql container is already installed.
IMAGE="$(docker ps -a | grep drupal)"
if [[ ! -z $IMAGE ]]; then :
  echo "Drupal container already exists."
  exit 0
fi

# Drupal server parameters.
MYSQL_CONTAINER=$1
DRUPAL_CONTAINER=$2
DRUPAL_VERSION=$3
 
# Download 'mysql' docker image.
docker pull drupal:$DRUPAL_VERSION

# Check if mysql container is already installed.
IMAGE="$(docker ps -a | grep mysql)"
if [[ -z $IMAGE ]]; then :
  echo "Drupal has a dependency of MySQL container."
  exit 0
fi

# Run the 'mysql' docker image.
docker run --name $DRUPAL_CONTAINER \
  --link $MYSQL_CONTAINER:mysql \
  -p 80:80 \
  -d drupal:$DRUPAL_VERSION

echo "Drupal server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' ${DRUPAL_CONTAINER})"
