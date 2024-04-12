#!/bin/bash

# Function to check for sudo/root privileges
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
    fi
}

# Function to move IP-Sweeper-Wizard script to /usr/local/bin
move_wizard_script() {
    sudo cp /opt/ip-sweeper/IP-Sweeper-Wizard.sh /usr/local/bin/IP-Sweeper-Wizard
    echo "The main script IP-Sweeper-Wizard.sh is now accessible globally. You can run it using 'IP-Sweeper-Wizard'."
}

# Function to install necessary packages and scripts
install_dependencies() {
    if ! command -v git &>/dev/null; then
        echo "git is not installed. Please install it using your package manager." >&2
        exit 1
    fi

    case "$(uname -s)" in
        Linux)
            if command -v apt-get &>/dev/null; then
                sudo apt update && sudo apt install -y git python3 python3-pip
            elif command -v pacman &>/dev/null; then
                sudo pacman -Sy git python3 python3-pip --noconfirm
            elif command -v dnf &>/dev/null; then
                sudo dnf update && sudo dnf install -y git python3 python3-pip
            else
                echo "Unsupported package manager." >&2
                exit 1
            fi
            ;;
        *)
            echo "Unsupported OS." >&2
            exit 1
            ;;
    esac

    if ! [ -d /usr/share/nmap/scripts/vulscan ]; then
	cd /usr/share/nmap/scripts && mkdir vulscan || return
        sudo git clone https://github.com/scipag/vulscan
	sudo ln -s pwd /scipag_vulscan /usr/share/Nmap/scripts/vulscan #-sV --script=vulscan/vulscan.nse
        sudo nmap --script-updatedb
    fi

    if ! python3 -c "import libnmap" &>/dev/null; then
        sudo pip3 install python-libnmap
    fi
}

check_sudo

if [[ -d /opt/ip-sweeper ]]; then
    move_wizard_script
else
    mkdir -p /opt/ip-sweeper
    cd "$(dirname "$0")" || exit 1
    cd ../ || exit 1

    if [ -d "ip-sweeper" ]; then
        echo "ip-sweeper directory found."
        sudo mv ip-sweeper/* /opt/ip-sweeper/
        rmdir ip-sweeper
        move_wizard_script
    else
        echo "ip-sweeper directory not found. Please make sure to download the program from GitHub."
        echo "git clone https://github.com/adamhamilton44/ip-sweeper.git"
        echo "Run the above git clone command to download or 'sudo apt install git' if you need the git command."
        exit 1
    fi
fi

read -rp "Would you like to install additional dependencies (git, python3, pip, etc.)? (yes/no): " response
if [[ $response =~ ^[Yy][Ee][Ss]$ ]]; then
    install_dependencies
else
    echo "No additional dependencies will be installed."
fi

echo "We are done you are now ready to run IP-Sweeper-Wizard as needed."
exit 0
