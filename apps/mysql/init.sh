#!/bin/bash

# Local of sql dump files.
DUMP="/tmp/dump"

# Return if the dump directory doesn't exists.
if [ ! -d ${DUMP} ]; then
  return
fi

# MySQL account credentials.
USER="root"
PASS="admin"

# Stop the execution of a script if a command or pipeline has an error.
set -e

# Loop through all the dump files and create user and db with same name.
for filename in $(ls -a ${DUMP} | grep .sql); do
  # Get the first part before any dot (.) comes.
  name=$(echo $filename | cut -d'.' -f1)

  # Get only alpha-numeric characters.
  dbname=$(echo $name | sed 's/[^a-zA-Z0-9]//g')

  # Create database, user account and grant privileges.
  mysql -u${USER} -p${PASS} -e "
    DROP DATABASE IF EXISTS ${dbname};
    CREATE DATABASE IF NOT EXISTS ${dbname};
    CREATE USER '${dbname}'@'%' IDENTIFIED BY '${dbname}';
    GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'%';
    FLUSH PRIVILEGES;"
  
  # Unzip db dump file if already zipped and import in the db.
  if [ "${filename##*.}" != "sql" ]; then
    zcat ${DUMP}/${filename} | mysql -u${USER} -p${PASS} $dbname
  else
    mysql -u${USER} -p${PASS} $dbname < ${DUMP}/${filename}
  fi
done