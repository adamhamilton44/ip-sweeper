#!/bin/bash
# This is the bash script for the extra downloads needed to run the vulscan (vulnability scan) and downloads for the parsing of information
# We need the python package libnmap using pip3 install as the installer, apt for pip (if not installed)
home="$PWD"

if ! [ -f /usr/bin/git ]; then
	apt update && apt install git -y
fi

if ! [ -f /usr/bin/pip3 ]; then
        apt update && apt install python3-pip -y
fi

if ! [ -f /usr/share/nmap/scripts/vulscan/vulscan.nse ]; then
        cd /usr/share/nmap/scripts/
	git clone https://github.com/vulnCom/vulners.git
fi

if ! [ -f /usr/lib/python3/dist-packages/libnmap/parser.py ]; then
	pip3 install python-libnmap
fi

cd $home
exit 0
