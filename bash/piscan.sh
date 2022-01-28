#!/bin/bash
#-----------------------------------------------------------------#
#  Find PI bash script 
#   Andy Richter  
#   05/19/2021  I really wrote it in 2019 when I got my printer
#  This script will search the local subnet for Raspberry Pi systems  
#  The script requires root access for nmap
#
#   There are no parms we find things for ourselves
#------------------------------------------------------------------#
systype="Raspberry Pi"
#systype=Unknown
me=$(readlink --canonicalize --no-newline $0)
if [ "$EUID" -ne 0 ]
  then echo >&2 "Please run as root or use sudo $me"
  exit
else 
  if ! command -v nmap &> /dev/null
    then
       echo "nmap not found on this system. Please install. exiting"
       exit
  fi
fi
# awk doesn't like variables between /.../ 
awkstr="/^Nmap/{ipaddress=\$NF}/$systype/{print ipaddress}"
 
# Use ip route to get the active rout to the internet, IP address and interface 
#  Then use that interface to find the subnet 
myrout=`ip route get 8.8.8.8`
myaddr=`echo $myrout | grep src| sed 's/.*src \(.* \)/\1/g'|cut -f1 -d ' '`
mydev=`echo $myrout | grep dev| sed 's/.*dev \(.* \)/\1/g'|cut -f1 -d ' '`
# now get our subnet
mynet=`ip -o -f inet addr show $mydev | awk '/scope global/{sub(/[^.]+\//,"0/",$4);print $4}'`

printf "\nSearching $mynet for $systype systems\nMy address is $mydev:$myaddr\n"

# Use nmap to find PI systems. 'Raspberry Pi' is found in NMAP for PI systems
foundSys=`sudo nmap -sP $mynet | awk "$awkstr"`
foundPI=`echo $foundSys`
numpi=`echo "$foundPI" | awk '{print NF}'`
s=$([[ ($numpi == 1) ]] && echo " " || echo "s")
# Now we know, print the list if any

printf "\nFound $numpi $systype system$s\n"
for ipaddr in $foundPI
   do
     printf "\t$systype system found at $ipaddr\n"
   done

exit 0
