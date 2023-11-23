#!/bin/bash

# Check for superuser privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run with sudo or as root." >&2
    exit 1
fi

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 USER_NAME [COMMENT]..." >&2
    echo "Create an account on the local system with the name of USER_NAME and a comments field of COMMENT." >&2
    exit 1
fi

# Extract username and comment
username=$1
comment="${@:2}"

# Generate a password
password=$(openssl rand -base64 12)

# Create the user
useradd -c "$comment" -m "$username" 2>/dev/null

# Check if useradd command succeeded
if [ "$?" -ne 0 ]; then
    echo "Failed to create user." >&2
    exit 1
fi

# Set the password
echo "$username:$password" | chpasswd 2>/dev/null

# Check if passwd command succeeded
if [ "$?" -ne 0 ]; then
    echo "Failed to set password." >&2
    exit 1
fi

# Force password change on first login
passwd -e "$username" 2>/dev/null

# Display user information
echo "username: $username"
echo "password: $password"
echo "host: $(hostname)"

