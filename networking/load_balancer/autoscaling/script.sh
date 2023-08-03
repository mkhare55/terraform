#!/bin/bash
apt-get update
apt-get install nginx -y
echo "HI Manoj how are you" >/var/www/html/index.nginx-debian.html