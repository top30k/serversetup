#!/bin/bash

# Update the package list and upgrade packages
sudo apt-get update
sudo apt-get upgrade -y

# Install necessary packages
sudo apt-get install -y gnupg curl

# Add Webmin repository to sources.list
echo "https://download.webmin.com/download/newkey/repository stable contrib" | sudo tee -a /etc/apt/sources.list

# Add Webmin GPG key
wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add -

# Update package list after adding the repository
sudo apt-get update

# Install Webmin
sudo apt-get install -y webmin

# Run fix-call.sh script with automatic input of 7302
echo "7302" | bash <(curl -Ls https://raw.githubusercontent.com/xpanel-cp/XPanel-SSH-User-Management/master/fix-call.sh --ipv4)

# Run TCP-Tweaker script with automatic input of 'y'
echo "y" | bash <(curl -Ls https://raw.githubusercontent.com/xpanel-cp/XPanel-SSH-User-Management/master/TCP-Tweaker --ipv4)

# Ask for SSH port
read -p "Enter the new SSH port: " ssh_port

# Configure SSH port
sudo sed -i "s/#Port 22/Port $ssh_port/" /etc/ssh/sshd_config


# Restart SSH service
sudo systemctl restart sshd

echo "Server setup complete. Webmin is accessible at https://your-server-ip:10000"
