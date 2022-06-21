#!/bin/bash
##nmap_scan.sh

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi


##Scan hosts
nmap -O -oX nmapscan.txt 192.168.2.0/23 --stylesheet  https://githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl --dns-servers 192.168.2.2

#convert hosts to html
xsltproc nmapscan.txt -o hosts.html

#copy hosts.html to /var/www/html
cp hosts.html /var/www/html

##Look for linux hosts output to linuxhosts.txt
echo "xpath //host[status[@state='up'] and os[osmatch/osclass[@osfamily='Linux']]]/address[@addrtype='ipv4']/@addr" | xmllint --shell nmapscan.txt | grep "content=" | awk -F= '{ print $2 }' > linuxhosts.txt

##Look for win hosts
#echo "xpath //host[status[@state='up'] and os[osmatch/osclass[@osfamily='Windows']]]/address[@addrtype='ipv4']/@addr" | xmllint --shell nmapscan.txt | grep "content=" | awk -F= '{ print $2 }' > winhosts.txt

##Look for Apple hosts
#echo "xpath //host[status[@state='up'] and os[osmatch/osclass[@osfamily='Apple']]]/address[@addrtype='ipv4']/@addr" | xmllint --shell nmapscan.txt | grep "content=" | awk -F= '{ print $2 }' > applhosts.txt


##Look for raspis

./piscan.sh
exit 0
