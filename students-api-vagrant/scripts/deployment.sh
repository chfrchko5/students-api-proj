#!/bin/bash

# add .env file for database
cat << EOF > .env
MYSQL_ROOT_PASSWORD="rootpass"
MYSQL_DATABASE="students"
MYSQL_USER="app_user"
MYSQL_PASSWORD="pass"
EOF

# using makefile, run the docker compose up command to deploy 4 containers
make compose