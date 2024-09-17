#!/bin/bash

# OS version
# lsb_release -a
OS_VERSION=$(awk -F'"' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
echo "OS Version: $OS_VERSION"
echo

# all users on the OS with bash shell installed
echo "Users with Bash shell:"
grep '/bin/bash' /etc/passwd | cut -d: -f1
echo

# shows the open ports
echo "Open Ports:"
ss -tuln | grep LISTEN
