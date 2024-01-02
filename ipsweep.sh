#!/usr/bin/env bash

##############################################
# Created: by Adam Hamilton                  #
# Version: 1.0.2                             #
# Date: SUN 12/31 2:19 P.M.                  #
# Usage: simple ip sweep with nmap abilities #
# Fixes: added error handeling for ip range  #
##############################################

# color code variables
# red
r=$'\e[1;31m'
# green
g=$'\e[1;32m'
# purple
p='\e[0;35m'
# warning
w='\e[1;31m[\e[5;31mERROR\e[0m\e[1;31m]\e[0m'
# reset
x=$'\e[0m'
# cyan
c=$'\e[1;36m'
# blue
b=$'\e[1;34m'



echo -e "$b ################################################################"
echo -e "$r /      _                                                      / "
echo -e "$g \     (_)___        ______      _____  ___  ____  ___  _____  \ "
echo -e "$p /    / / __ \______/ ___/ | /| / / _ \/ _ \/ __ \/ _ \/ ___/  / "
echo -e "$c \   / / /_/ /_____(__  )| |/ |/ /  __/  __/ /_/ /  __/ /      \ "
echo -e "$r /  /_/ .___/     /____/ |__/|__/\___/\___/ .___/\___/_/       / "
echo -e "$g \   /_/                                 /_/                   \ "
echo -e "$x /                                                             / "
echo -e "$b ################################################################"

# create a variable for first added arguements
out="$1"

# Ask user for the first 3 octets of ip address if not supplied when calling script
if [ "$out" == "" ]; then
    	echo -e "\n $c Please enter $r ONLY $c the first $r[3]$c oxtets: $g Example: $c 192.168.1 $x"
	read -r out
    	# make sure user supplied the correct range for sweeper = to minumim 1.1.1 - maxium 255.255.255
	[[ "$out" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])$ ]] && echo -e "\n $p Running ip-sweeper on the ip range: $c $out $x" || { echo -e "\n $w $r Incorrect format or range $w $r"; exit 1; }
	for ip in `seq 1  254`; do
    	ping -c 1 -W 0.30 "$out.$ip" | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >ipsweep.$out.txt
    	done
    	echo -e "\n $c File saved in: $r $PWD/ipsweep.$out.txt $x"
# if user supplied ip range whrn calling script make sure they supplid the correct range for sweeper 
else	[[ "$out" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])$ ]] && echo -e "\n $p Running ip-sweeper on the ip range: $c $out $x" || { echo -e "\n $w $r Incorrect format or range $w $r"; exit 1; }
    	for ip in `seq 1  254`; do
    	ping -c 1 -W 0.30 "$out.$ip" | grep "64 bytes" | cut -d " " -f 4 | tr -d ":"  >ipsweep.$out.txt
    	done
    	echo -e "\n $c File saved in: $r $PWD/ipsweep.$out.txt $x"

fi

# option to run a nmap scan expecting either Y|y or N|n and error exit if not
echo -e "\n $c Would you like to run a $p nmap port discovery scan $c against the found ip's?: $r [Y/N] $x"
read answer

if 	[ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
	nmap -Pn -p- -iL ipsweep.$out.txt -oN ipsweep.$out.txt --open  --append-output &>/dev/null
	echo -e "\n $c ipsweep and nmap scan are saved in: $r $PWD/ipsweep.$out.txt $x"
	echo -e "\n $p Thank You for using my $c ping sweeper script. $x"
	exit

elif	[ "$answer" = "N" ] || [ "$answer" = "n" ]; then
	echo -e "\n $g Good Bye \n $p Thank you for using my $c ping sweeper script. $x"
	exit
else
	echo -e "\n $w $r Incorrect Answer: Y/y or N/n ONLY! $w $x"
	exit 1
fi


done >ipsweep.$out.txt
# TO DO: add more nmap options
