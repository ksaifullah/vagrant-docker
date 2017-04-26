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
VOLUME_MOUNT=$3

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
  # Get a mount point for drupal files.
  DRUPAL_FILES="${VOLUME_MOUNT}/${CONTAINER_NAME}/files"
  if [ -d $DRUPAL_FILES ]; then
    rm -rf ${DRUPAL_FILES}/*
  else
    mkdir -p $DRUPAL_FILES
  fi
  
  # Create directory and extract the files.
  DATA_FILE="/vagrant/data/aabss/files.tar.gz"
  if [ -f "${DATA_FILE}" ]; then
    tar -xvzf $DATA_FILE -C $DRUPAL_FILES
  fi

  # Change file user/group to support apache.
  chown -R www-data:www-data $DRUPAL_FILES

  # Build mysql container.
  docker build -t ksaifullah/aabss:latest /vagrant/apps/aabss

  # Run the 'mysql' docker image.
  docker run --name $CONTAINER_NAME \
    -h aabss.station \
    --link $MYSQL_CONTAINER:mysql \
    -v ${DRUPAL_FILES}:/drupal/files \
    -v /var/www/aabss:/var/www/html \
    -p 8080:80 \
    -d ksaifullah/aabss:latest
else
  if [ -z "$(docker ps | grep ${CONTAINER_NAME})" ]; then
    docker start ${CONTAINER_NAME}
  fi
fi

echo "Drupal server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' ${CONTAINER_NAME})"
