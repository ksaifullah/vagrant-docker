#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

CONTAINER_NAME=$1
VOLUME_MOUNT=$2

# Stop the execution of a script if a command or pipeline has an error.
set -e

# Print all executed commands to the terminal
set -x

# Check if mysql container is already installed.
if [ -z "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
  # Build mysql container.
  docker build -t ksaifullah/mysql:latest /vagrant/apps/mysql

  # Create a directory to mount mysql data directory.
  DB_FILES="${VOLUME_MOUNT}/${CONTAINER_NAME}/dbfiles"
  mkdir -p $DB_FILES

  # Run the container.
  docker run \
    --name ${CONTAINER_NAME} \
    -h mysql.station \
    -v /vagrant/data/mysql/dump:/tmp/dump \
    -v /vagrant/data/mysql/etc:/etc/mysql \
    -v ${DB_FILES}:/var/lib/mysql \
    -d ksaifullah/mysql:latest

  # Let mysql import the db dump.
  sleep 2m
else
  if [ -z "$(docker ps | grep ${CONTAINER_NAME})" ]; then
    docker start ${CONTAINER_NAME}
  fi
fi

echo "MySQL custom server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' ${CONTAINER_NAME})"
