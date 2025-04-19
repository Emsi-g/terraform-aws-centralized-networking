#!/bin/bash
sleep 2
while ! ping -c1 -W1 8.8.8.8 >/dev/null 2>&1; do
  echo "Waiting for internet connection..."
  sleep 2
done

echo "Internet is available. Continuing setup..."
# Update package list
apt update -y

# Install Apache web server
apt install -y apache2

# Start and enable Apache
systemctl start apache2
systemctl enable apache2

# Get the hostname
HOSTNAME=$(hostname)

# Write custom message to index.html
echo "Hello world!!! My server hostname is $HOSTNAME" > /var/www/html/index.html
