# https://github.com/dockerfile/mysql
FROM mysql:latest

# Fulfil the basic requirement.
ENV MYSQL_ROOT_PASSWORD=admin

# Copy database dump file.
COPY ["init.sh", "/docker-entrypoint-initdb.d/"]
