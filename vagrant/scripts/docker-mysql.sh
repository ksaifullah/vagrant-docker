#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Check if mysql container is already installed.
IMAGE="$(docker ps -a | grep mysql)"
if [[ ! -z $IMAGE ]]; then :
  echo "MySQL container already exists."
  exit 0
fi

# Download 'mysql' docker image.
docker pull mysql:latest

# Run the 'mysql' docker image.
docker run --name mysqlstation \
  -e MYSQL_ROOT_PASSWORD=admin \
  -e MYSQL_DATABASE=drupalstation \
  -e MYSQL_USER=drupalstation \
  -e MYSQL_PASSWORD=drupalstation \
  -p 3306:3306 \
  -d mysql:latest

echo "MySQL server ip address: $(docker inspect --format '{{.NetworkSettings.IPAddress}}' mysqlstation)"
