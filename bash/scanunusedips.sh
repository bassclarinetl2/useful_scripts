#!/bin/bash

#Check if root or sudo
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
fi

#Scan for "down" hosts
sudo nmap -v -sn -n 192.168.2.1/23 -oG - | awk '/Status: Down/{print $2}' > unusedhosts.txt

exit 0


