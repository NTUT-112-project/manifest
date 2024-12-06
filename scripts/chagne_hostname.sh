#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Function to display usage
usage() {
  echo "Usage: $0 NEW_HOSTNAME"
  exit 1
}

# Check if a new hostname is provided
if [ -z "$1" ]; then
  usage
fi

NEW_HOSTNAME=$1

# Validate hostname format (RFC 1123 compliant)
if ! [[ "$NEW_HOSTNAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
  echo "Invalid hostname. Only letters, numbers, and hyphens are allowed."
  exit 1
fi

# Set the hostname using hostnamectl
hostnamectl set-hostname "$NEW_HOSTNAME"

# Update /etc/hosts
echo "Updating /etc/hosts..."
sed -i "s/127.0.1.1 .*/127.0.1.1 $NEW_HOSTNAME/" /etc/hosts

# Confirm the change
echo "Hostname changed to '$NEW_HOSTNAME'. Please restart your system to apply the change completely."

exit 0
