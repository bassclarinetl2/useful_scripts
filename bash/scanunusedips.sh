#!/bin/bash

#Check if root or sudo
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
fi

#Scan for "down" hosts
sudo nmap -v -sn -n 192.168.2.1/24 --exclude 192.168.2.0/32,192.168.2.100/30,192.168.2.104/29,192.168.2.112/28,192.168.2.128/26,192.168.2.192/27,192.168.224/28,192.168.240/29,192.168.248/32,192.168.250/32 -oG - | awk '/Status: Down/{print $2}' > unusedhosts.txt
chmod 777 unusedhosts.txt

exit 0


