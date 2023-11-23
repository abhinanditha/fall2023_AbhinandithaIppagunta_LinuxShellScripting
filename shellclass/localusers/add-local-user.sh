#!/bin/bash

# Enforce Superuser Privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo or as root."
  exit 1
fi

# Prompt for User Input
read -p "Enter the username to create: " username
read -p "Enter the real name for the account: " realname
read -p "Enter the password for the account: " password

# Create a New User
useradd -c "$realname" -m "$username"

# Check if User Creation Was Successful
if [ $? -ne 0 ]; then
  echo "User account creation failed."
  exit 1
fi

# Set Password for the User
echo "$password" | passwd --stdin "$username"

# Check if Password Setting Was Successful
if [ $? -ne 0 ]; then
  echo "Setting password failed."
  exit 1
fi

# Force Password Change on First Login
passwd -e "$username"

# Display User Information
echo "username: $username"
echo "password: $password"
echo "host: $(hostname)"

# Make the Script Executable
chmod +x add-local-user.sh
