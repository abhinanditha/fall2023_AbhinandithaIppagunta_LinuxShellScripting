#!/bin/bash

# Script name: add-new-local-user.sh


# Check if the script is executed with superuser privileges
if [[ "${UID}" -ne 0 ]]; then
    echo "Please run the script with superuser privileges." >&2
    exit 1
fi

# Check if at least one command line argument is provided
if [[ "${#}" -lt 1 ]]; then
    echo "Usage: ${0} USERNAME [COMMENT...]" >&2
    exit 1
fi

# Extract the username and comment from command line arguments
USERNAME="${1}"
COMMENT="${*}"
shift

# Generate a random password for the new user
PASSWORD=$(date +%s%N | sha256sum | head -c12)

# Create the new user with the provided username and comment
useradd -c "${COMMENT}" -m "${USERNAME}" &> /dev/null

# Check if useradd command was successful
if [[ "${?}" -ne 0 ]]; then
    echo "Failed to create the user '${USERNAME}'." >&2
    exit 1
fi

# Set the generated password for the new user
echo "${PASSWORD}" | passwd --stdin "${USERNAME}" &> /dev/null

# Check if passwd command was successful
if [[ "${?}" -ne 0 ]]; then
    echo "Failed to set the password for the user '${USERNAME}'." >&2
    exit 1
fi

# Display account creation details
echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"

# Exit with success status
exit 0

