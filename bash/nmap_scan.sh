#!/bin/bash
##nmap_scan.sh

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi


##Scan hosts
nmap -O -oX nmapscan.txt 192.168.2.0/23 

##Look for linux hosts output to linuxhosts.txt
echo "xpath //host[status[@state='up'] and os[osmatch/osclass[@osfamily='Linux']]]/address[@addrtype='ipv4']/@addr" | xmllint --shell nmapscan.txt | grep "content=" | awk -F= '{ print $2 }' > linuxhosts.txt

##Look for win hosts
#echo "xpath //host[status[@state='up'] and os[osmatch/osclass[@osfamily='Windows']]]/address[@addrtype='ipv4']/@addr" | xmllint --shell nmapscan.txt | grep "content=" | awk -F= '{ print $2 }' > winhosts.txt

##Look for Apple hosts
#echo "xpath //host[status[@state='up'] and os[osmatch/osclass[@osfamily='Apple']]]/address[@addrtype='ipv4']/@addr" | xmllint --shell nmapscan.txt | grep "content=" | awk -F= '{ print $2 }' > applhosts.txt


##Look for raspis
nmap -sN 192.168.2.0/23 | grep -i "b8:27:eb\|dc:a6:32\|e4:5f:01" -B2  | sed -n -e's/^.*for //$p' >> pihosts.txt

exit 0
