#!/bin/bash

# Variables
nginx_user="nginx"
nginx_group="nginx"
backup_path="$HOME/nginx_backup"

# Installing dependencies for Nginx
sudo apt-get update
sudo apt-get install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev

# Downloading and extracting Nginx
wget http://nginx.org/download/nginx-1.20.1.tar.gz
tar -xzvf nginx-1.20.1.tar.gz
cd nginx-1.20.1

# Configure, compile, and install Nginx
./configure
make
sudo make install

# Add nginx user and group
sudo groupadd -f $nginx_group
sudo useradd -g $nginx_group -s /bin/false -d /var/www $nginx_user

# Change ownership of Nginx folders
sudo chown -R $nginx_user:$nginx_group /usr/local/nginx

# Create a script for backing up the Nginx directory
backup_script="$HOME/backup_nginx.sh"
cat <<EOF > $backup_script


mkdir -p $backup_path
tar -czf $backup_path/nginx-$(date +\%F).tar.gz /usr/local/nginx
EOF

chmod +x $backup_script

# Setting up the cron job
(crontab -l 2>/dev/null; echo "0 0 * * * $backup_script") | crontab -

echo "Nginx installation and backup setup completed."

