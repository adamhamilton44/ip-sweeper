#!/bin/bash



# Check if the user has sudo/root privileges needed for moving IP-Sweep to /opt
# also downloading from package manager git, python3, pip if not installed
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   echo "If you dont have sudo permissions"
   echo "please talk to your admin, boss, mom or dad or whoever does have permission" 
   exit 1
fi

# If user added IP-Sweep directory to opt/ directory then move the main script (IP-Sweeper-Wizaerd.sh) to $PATH in /usr/local/bin/
if [[ -d /opt/IP-Sweep ]]; then
	# Copy the Wizard script to /usr/local/bin/
    	sudo cp /opt/IP-Sweep/IP-Sweeper-Wizard.sh /usr/local/bin/IP-Sweeper-Wizard
	echo "The main script IP-Sweeper-Wizard.sh is now accessible globally. You can run it using 'IP-Sweeper-Wizard'."
else    # if user didnt add to /opt directory
	# Make a directory for IP-Sweeper in the /opt directory then Change to the users current directory where IP-Sweep is located 
	# then move outside of all files and folders of IP-Sweeper to the parrent directory. 
	mkdir /opt/IP-Sweep
	cd "$(dirname "$0")" # move to the directory where user as put IP-Sweep directory since we are calling $0 we assume user didnt move this install script and only ran it.
	cd ../ # move to parent directory so removing the IP-Sweep directory doesnt throw errors

	# Since we are in the parent directory now this SHOULD always be true, but we will still Check if the IP-Sweep directory exists
	if [ -d "IP-Sweep" ]; then
    		echo "IP-Sweep directory found."

    		# Move everything inside IP-Sweep directory to /opt
    		sudo mv IP-Sweep/* /opt/IP-Sweep/

    		# Remove the empty IP-Sweep directory / here is why we cd .. to parent directory
    		rmdir IP-Sweep

    		# Copy the Wizard script to /usr/local/bin/
    		sudo cp /opt/IP-Sweep/IP-Sweeper-Wizard.sh /usr/local/bin/IP-Sweeper-Wizard

    		echo "IP-Sweep has been successfully installed and added to the /opt/ directory."
    		echo "The main script IP-Sweeper-Wizard.sh is now accessible globally. You can run it using 'IP-Sweeper-Wizard'."
	else
    		echo "IP-Sweep directory not found. Please make sure to download the program from GitHub."
    		echo "git clone https://github.com/adamhamilton44/ipsweep.git"
    		echo "Run the above git clone command to download or 'sudo apt install git' if you need the git command."
		exit 1
	fi
fi


echo "If you would like a extra nmap script added for vulnability hunting and xml file parsing type Yes."
echo "This will add a vulability .nse script to Nmap's scripts directory located in /usr/share/nmap/scripts/"
echo "It is a github Program named: vulnCom/vulners ! NOT to be misunderstood as Nmap's vuln script already downloaded with nmap"
echo "Also needed for reading and parsing the information in xml format i added the needed downloads"
echo "This includes python3, pip, libnmap, and a parsing script already added in the Scripts directory named parser.py"
echo "Anyway if you would like these extra function's type yes small letters only and we will download if not installed already, or type anything else but yes to exit."

read -r -p "Please type yes if you want the extra downloads. " down

if [[ "$down" == yes ]]; then
	# checking and running the correct package manager
	release_file=/etc/os-release
	# This is the bash script for the extra downloads needed to run the vulscan (vulnability scan) and downloads for the parsing of information
	# We need the python package libnmap using pip3 install as the installer, apt for python and pip (if not installed)
	home="$PWD"

	if grep -q "Arch" $release_file
	then
        	# The Host based on Arch, run the pacman command
        	# we wont upgrade users packages only merge correct version information
		sudo pacman -Sy git python3 python3-pip
	fi

	if grep -q "Debian" $release_file || grep -q "Ubuntu" $release_file
	then  # same here will not upgrade users packages only merge version information
		sudo apt update && sudo apt install -y git python3 python3-pip
	fi

	if grep -q "Red Hat" $release_file
	then # I guess it is safe to assume user is Red Hat
		sudo dnf update && sudo dnf install -y git python3 python3-pip
	fi
else
        echo "No extra downloads will be installed"
fi

if ! [ -f /usr/share/nmap/scripts/vulscan/vulscan.nse ]; then
        cd /usr/share/nmap/scripts/
        git clone https://github.com/vulnCom/vulners.git
	nmap --script-updatedb
fi

if ! [ -f /usr/lib/python3/dist-packages/libnmap/parser.py ]; then
        pip3 install python-libnmap
fi

cd $home

exit 0

