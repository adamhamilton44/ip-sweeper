#!/usr/bin/env bash

#################################################
# Author: Adam Hamilton                         #
# Created Date: Thursday-Jan-04-2024            #
# Time: 01:09-am                                #
# Purpose: ping sweeper with nmap support       #
# Version: v2.0.0                               #
# Notes: Added a function to shorten the script #
#################################################


# Variable COLOR Commands
# red
r=$'\e[1;31m'
# green
g=$'\e[1;32m'
# blue
b=$'\e[1;34m'
# cyan
c=$'\e[1;36m'
# reset
x=$'\e[0m'
# purple
p='\e[0;35m'
# warning
w='\e[1;31m[\e[5;31mERROR\e[0m\e[1;31m]\e[0m'


# Function to validate IP format
validate_ip() {
    [[ "$out" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])$ ]] && return 0 || return 1
}

# Display ASCII art
echo -e " $b ################################################################ $x "
echo -e " $r /      _                                                      /  $x "
echo -e " $g \     (_)___        ______      _____  ___  ____  ___  _____  \  $x "
echo -e " $c /    / / __ \______/ ___/ | /| / / _ \/ _ \/ __ \/ _ \/ ___/  /  $x "
echo -e " $p \   / / /_/ /_____(__  )| |/ |/ /  __/  __/ /_/ /  __/ /      \  $x "
echo -e " $r /  /_/ .___/     /____/ |__/|__/\___/\___/ .___/\___/_/       /  $x "
echo -e " $g \   /_/                                 /_/                   \  $x "
echo -e " $c /                                                             /  $x "
echo -e " $b ################################################################ $x "

# Get user input for IP range if not supplied
if [ -z "$1" ]; then
    read -rp " $c Please enter $r ONLY $c the first $r 3 $c octets: $g Example: $c 192.168.1 $r ===> $x " out
    validate_ip "$out" || { echo -e "\n $w Incorrect format for IP range $w $x "; exit 1; }
else
    out="$1"
    validate_ip "$out" || { echo -e "\n $w Incorrect format for IP range $w $x "; exit 1; }
fi

# Perform ping sweep
for ip in $(seq 1 254); do
    ping -c 1 -W 0.70 "$out.$ip" | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> "ipsweep.$out.txt"
done

echo -e "\n $c File saved in: $r $PWD/ipsweep.$out.txt $x "

# Option to run nmap scan
read -rp " $c Would you like to run a $g nmap port discovery scan $c against the found IP\'s? $r [Y/N]: $r ===> $x  " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    nmap -Pn -p- -iL "ipsweep.$out.txt" -oN "ipsweep.$out.nmap.txt" --open  &>/dev/null
    cat "ipsweep.$out.nmap.txt" >> "ipsweep.$out.txt"
    rm -rf "ipsweep.$out.nmap.txt"
    echo -e "\n $c ipsweep and nmap scan are saved in: $r $PWD/ipsweep.$out.txt $x "
    echo -e "\n $p Thank You for using my $c ping sweeper script. $x"
    exit 0
elif [[ "$answer" =~ ^[Nn]$ ]]; then
    echo -e "\n $g Good Bye \n $p Thank you for using my $c ping sweeper script. $x"
    exit 0
else
    echo -e "\n $w Incorrect Answer: Y/y or N/n ONLY! $w $x"
    exit 1
fi

