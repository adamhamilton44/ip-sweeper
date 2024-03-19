#!/bin/bash

#############################
# Author: Adam Hamilton
# Created Date: Friday-Feb-23-2024
# Time: 10:49-pm
# Purpose: Revised IP-Sweeper-Wizard /w Nmap full support
# Version: v2.0
#############################

# Variable COLOR Commands remove or commit out any colors not needed
# red
declare -r r=$'\e[1;31m'
# green
declare -r g=$'\e[1;32m'
# blue
declare -r b=$'\e[1;34m'
# cyan
declare -r c=$'\e[1;36m'
# reset
declare -r x=$'\e[0m'
# red ! exclamation
declare -r re='\e[1;31m[!!]\e[0m'
# arrow blinking right
declare -r ar='\e[1;31m[\e[5;31m ==> \e[0m\e[1;31m]\e[0m'
# arrow blinking left
declare -r al='\e[1;31m[\e[5;31m <== \e[0m\e[1;31m]\e[0m'
# double underline ATTENTION error
declare -r be='\e[1;31m[\e[21;31mATTENTION\e[0m\e[1;31m]\e[0m'
# purple
declare -r p='\e[1;35m'

# function to display ascii art
function show_ascii_art() {
        clear
        echo -e " $b ######################################################################## $x "
        echo -e " $r \      _                                                              /  $x "
        echo -e " $g /     (_)___        ______      _____  ___  ____  ___  _____          \  $x "
        echo -e " $c \    / / __ \______/ ___/ | /| / / _ \/ _ \/ __ \/ _ \/ ___/          /  $x "
        echo -e " $p /   / / /_/ /_____(__  )| |/ |/ /  __/  __/ /_/ /  __/ /              \  $x "
        echo -e " $r \  /_/ .___/     /____/ |__/|__/\___/\___/ .___/\___/_/               /  $x "
        echo -e " $g /   /_/                                 /_/                WITH       \  $x "
        echo -e " $c \                                                           N         /  $x "
        echo -e " $p /               _       ___                      __          M        \  $x "
        echo -e " $r \              | |     / (_)___  ____ __________/ /           A       /  $x "
        echo -e " $g /              | | /| / / /_  / /    \/ ___/ __  /             P      \  $x "
        echo -e " $c \              | |/ |/ / / / /_/ /_/ / /  / /_/ /         SUPPORT     /  $x "
        echo -e " $p /              |__/|__/_/ /___/\__,_/_/   \__,_/                      \  $x "
        echo -e " $r \                                                                     /  $x "
	echo -e " $g /                                                                     \  $x "
        echo -e " $b ######################################################################## $x "
        echo " "
}

# function to check if user has sudo or is root for extra download options and Nmap commands
check_for_root() {
        if [ "$EUID" -ne 0 ]; then
		echo " "
		echo -e "$be $p IMPORTANT INFORMATION $be $x"
		echo " "
		echo -e "$p IP-Sweeper-Wizard does$r NOT$g need$r sudo privileges."
		echo " "
		echo -e "$p But most Nmap commands need$r sudo.$x"
		echo " "
		echo -e "$p We can continue without$g $USER $p using$r sudo."
		echo " "
		echo -e "$p But you$g may have$p problems running Nmap commands.$x"
		echo " "
		echo -e "$p If you need$r sudo privileges$p then press$r 3$g on the following question.$x "
        	echo " "
		echo -e "$p Press any key when you are ready$g $USER $x"
		read -n 1 -r
		clear
	else
		echo -e "$p $USER has$r sudo$p all commands can run safely."
		echo -e "$p Press any key when you are ready"
		read -n 1 -r
		clear
        fi
}
: '
# boolein for parsing the xml file ONLY IF User allowed the download
# But even if user is sudo/root and choose no then script will not run parse will stay false
parse=false

# function to download the needed scripts and parser for github vulscan.nse - download script is located in Scripts/downloads.sh
# this is ONLY available to a sudo/root user
download_pip_lib_git_vuln() {
	if [ "$EUID" -eq 0 ]; then
		echo -e "$p You have the option if you would like to download a addon vulnability script for nmap from Gihub."
		echo -e "$r https://github.com/vulnCom/vulners. "
		echo -e "$g if you choose Y for yes i will check for$r python3-pip$g because we also need$r python-libnmap,$g this is for parsing xml files."
		echo -e "$g I will also search for$r git$g this is for the$r git clone$g command to download$r https://github.com/vulnCom/vulners$g that will be placed in your Nmap scripts directory$r /usr/share/nmap/scripts/.$x "
		echo -e "$p The script will check for and add any parts mentioned above if not downloaded already and will skip any you already have."
		echo -e "$b Continue with download?$r Y|N $x"
		read -r -p " ==> " answer

		while_asking_question

		if [[ "$answer" =~ [Yy] ]]; then
			bash ./Scripts/download.sh
			parse=true
		fi
	fi
}

# Function to check if a substring exists in a string
substring_exists() {
    string="$1"
    substring="$2"
    if [[ "$string" == *"$substring"* ]]; then
        return 0
    else
        return 1
    fi
}
'

# Array to store user choices
user_choices=()

# boolean for final Nmap command to output to user based on if IP-Sweeper-Wizard is used as a -iL infile for Nmap to read. 
ipp=false

# Function to get user input
function get_input() {
	read -r  choice
    	echo "$choice"
}

# Function to get and check users ip address syntax
function get_input_ip() {
    	read -r choice
    	echo "$choice"
}

# Function to check if the input is a valid IP address or ip = 1-255 X (4) + .
function is_valid_ip() {
    	local ip=$1
    	local IFS='.'
    	read -r -a ip_parts <<< "$ip"
    	for part in "${ip_parts[@]}"; do
        	if ! [[ "$part" =~ ^[0-9]+$ ]] || [[ "$part" -lt 0 || "$part" -gt 255 ]]; then
            		return 1
        	fi
    	done
    	return 0
}

# Function to check if the input contains only letters,numbers, and acceptable symbols
function contains_only_letters_and_numbers() {
    	local input=$1
    	if [[ "$input" =~ ^[a-zA-Z0-9\._-]+$ ]]; then
        	return 0
    	else
        	return 1
    	fi
}

# Function to check if the input contains only letters and acceptable (.) for .com .org
function contains_only_letters() {
    	local input=$1
    	if [[ "$input" =~ ^[a-z\.]+$ ]]; then
        	return 0
    	else
        	return 1
    	fi
}

# Function to validate correct usage for ip address to the IP-Sweeper-Wizard's IP format 192.168.1 without the final octet
validate_ip() {
	[[ "$ip_ping_scan_address" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])$ ]] && return 0 || return 1
}
# function for a repeated while loop
while_asking_question() {
	while [[ ! "$answer" =~ [YyNn] ]]; do
        	echo -e "$be $re  $p Incorrect answer. $re $be $p Please enter $b Y or N.$x "
        	read -r -p " ==> " answer
	done
}
# function for running the ping scan
run_ping_scan() {
	read -r -p "Please enter $r ONLY$c the first $r 3 $c octets: $g Example: 192.168.1 $r ===> $x " ip_ping_scan_address
        validate_ip "$ip_ping_scan_address" || { echo -e " $be $re $r Incorrect format for IP range$be $re $x "; exit 1; }
        # Perform ping sweep

	for ip in $(seq 1 254); do
        	ping -c 1 -W 1.0 "$ip_ping_scan_address.$ip" | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> "ipsweep.$ip_ping_scan_address.txt" 
		ip_pingfile="ipsweep.$ip_ping_scan_address.txt" # this is the outfile name ipsweep.<ip input>.txt
		infile="-iL $ip_pingfile" # Adding a variable for Nmap's final command using IP-Sweeper-Wizard file as Nmap read from file -iL option
		ezy="$ip_ping_scan_address" # short variable for a long because i am lazy and added options in V. 2 that makes my life easier.
    	done

	lines=$(wc -l < "$ip_pingfile") # get IP's line count so user has a idea how big the file size is before using Nmap options 5 or 250 makes a big difference in time Nmap will run
    	echo -e " $c File saved in: $r $PWD/$ip_pingfile $x "
	echo -e " $c There where $lines ip addresses found. \n Press enter/return when you are ready. $x"
	echo " "
	read -n 1 -r
}

# Long function for ip address or website URL for a correct format for Nmap input 
get_user_options() {
	show_ascii_art
    	echo -e "  $p Please answer with $r 1 2 or 3 $x"
    	echo " "
	echo -e " 1.$c IP address$p Example ==> $g 192.168.67.12 $x"
    	echo " "
	echo -e " 2.$c Website URL$p Example ==> $g www.google.com $x"
    	echo " "
	echo -e " 3.$r Exit script $x"
	echo " "
    	read -r -p " ==> " choice

	while [[ ! "$choice" =~ [123] ]]; do
        	echo -e "$be $re  choices are$p 1, 2, 3. $re $be  $x"
        	read -r -p "==> " choice
	done

	if [[ "$choice" == "1" ]]; then
        	while true; do
			echo -e "$c Please enter the ip address $p Example ==>$g 192.168.20.1 $x"
            		user_input=$(get_input_ip)

        		# Check if the input is a valid IP address
            		if [[ $user_input =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            			if is_valid_ip "$user_input"; then
                			echo -e "$c You entered the IP address $p ==> $g $user_input. $x"
                			nmap_website_prefix_name_extension="$user_input"
					ezy="$user_input"
                			break
            			else
                			echo -e "$be $re $p Invalid IP address format.$r Please try again.$be $re $x"
                			continue
            			fi
              		else
			    	echo -e "$be $re  $r Invalid IP address format. Please try again. $be $re $x"
            			continue
             		fi
    		done
	elif [[ "$choice" == "2" ]]; then
    		# Prompt the user to choose whether 'www.' is needed
    		echo -e  " $c Do you need www added to website name?$x \n (1) $p ==>$g www.google.com$x \n (2) $p ==>$g google.com$x"
    		echo " "
		read -r -p " ==> " www_choice
    		case $www_choice in
        		1) www_prefix="www.";;
        		2) www_prefix="";;
        		*) echo -e "$be $re $r Invalid choice. Defaulting to NULL www. $be $re $x"; www_prefix="";;
    		esac
		show_ascii_art
		echo -e "$p                 google      facebook       amazon $x"
		echo " "
    		# Prompt the user for the website name
    		while true; do
        		echo -e " $c Please enter only the website name.$p Example ==>$g google, amazon, facebook$x  "
        		read -r -p " ==> " website_name
        		if contains_only_letters_and_numbers "$website_name"; then
            			break
        		else
            			echo -e "$be $re  $r Invalid website name. Please use only letters and numbers.$be $re $x"
        		fi
    		done

    		# Prompt the user for the domain extension
    		while true; do
        		echo -e "$c Enter the domain extension with the $r (.) $p Example ==> $g .com  .gov  .org $x "
        		read -r -p " ==> " domain_extension
        		if contains_only_letters "$domain_extension"; then
            			break

			else
            			echo -e "$be $re $r  $be $re $p \n Please use only letters and a (.)$g (e.g., .com, .gov):$x "
        		fi
    		done

    		# Construct the URL
    		nmap_website_prefix_name_extension="$www_prefix$website_name$domain_extension"
    		echo -e "$b You entered the website URL:$p ==> $nmap_website_prefix_name_extension $x "
    		ezy="$website_name"

    else
    		echo -e "$r Exiting the script.$x"
    		exit 1
	fi
}
# function for a repeat -sV -sC -O -A scan options, maybe because i didnt really script this in the best way?!
function sysinfo_scan() {
	while [[ ! "$ossv" =~ [YyNn] ]]; do
        	echo -e "$be $re  $r Incorrect answer. $re $be $p Please enter $g Y or N.$x "
        	read -r -p " ==> " ossv
        done
	if [[ "$ossv" =~ [Yy] ]]; then
                echo -e "$c Choose all options that apply: \n system version check (-sV) \n operating system check (-O) \n Nmap basic scanning scripts (-sC) \n all options above (-A) \n $r !! If you plan on using Nmap's '--script scanning options'? $p then choose option $g (4) -A $x "
                sys_question=
                sys_options=("-sV" "-O" "-sC" "-A")
                ask_multiple_choices_question "$sys_question" "${sys_options[@]}"
                choice=$(get_input)
                IFS=',' read -ra choice_array <<< "$choice"
                for z in "${choice_array[@]}"; do
                        user_choices+=("${sys_options[$((z-1))]}")
                done
    	else
		echo -e "$b No options choosen"
	fi
}

# function for single answer questions, becuse we need single and double options available.
ask_single_choice_question() {
    	local question="$1"
    	shift
    	local options=("$@")
    	echo "$question "
    	# Display options
    	for ((i=0; i<"${#options[@]}"; i++)); do
        	echo " $((i+1)). ${options[i]}"
    	done
    	echo -e "$b Enter your choice: $x"
}

# Function to display a question and options allowing multiple choices, read above.
ask_multiple_choices_question() {
    	local question="$1"
    	shift
    	local options=("$@")
    	echo "$question"
    	# Display options
    	for ((i=0; i<"${#options[@]}"; i++)); do
        	echo "$((i+1)). ${options[i]}"
    	done
    	echo -e "$b Enter multiple choices if needed separated by commas $p Example ==>$g '1,2,3'  $x"
}

# function to create a usefull Nmap command when user choose ipsweeper file as input and a variable to run the command if user wants to.
final_command_ping() {
	final_ping_command=$(echo "nmap ${user_choices[*]} $infile $outfile" |  sed 's/\" , \"/\",\"/g') # we use sed for correct format to Nmap when using scripts.
	echo -e "$c your full command is $p ==> $g $final_ping_command $x"
}

# function to create a usefull Nmap command without ipsweeper used as input for a Nmap scan and a variable to run final command without errors.
final_command_nmap() {
	final_nmap_command=$(echo "nmap ${user_choices[*]} $nmap_website_prefix_name_extension $outfile" |  sed 's/\" , \"/\",\"/g')
	echo -e "$c Your full command is$p ==> $g $final_nmap_command $x "
}

# The Final function to run the correct Nmap command based on if user has a IP-Sweeper file as a -iL read in file to Nmap
run_final_scan() {
        if $ipp; then # if True then
                eval "$final_ping_command" # run Nmap command with ip sweeper as a read in file
        else
                eval "$final_nmap_command" # run command withoout a in file
        fi

}

#####################
# BEGINING OF SCRIPT#
#####################
# Finally we are past the functions hope that was worth the hassle.
show_ascii_art # our first function and used often to show ascii logo art

echo -e "$p                       Welcome to the IP-Sweeper-Wizard$x"

check_for_root # check for root give user options if not

download_pip_lib_git_vuln # asking only sudo users if they want the downloaded scripts for extended usage

show_ascii_art # I am proud of my ascii art you will see often
echo -e "$p IP-Sweeper-Wizard or Nmap scan$x"
echo " " # user options for using IP-Sweeper-Wizard or Nmap or to Exit
echo -e "$c Please enter a number$x \n \n 1. $c Run $r IP-Sweeper $c ping scan on a (255) ip range $p Example ==>  $g 192-168.1.(1-255) $x \n \n 2. $c Run a$r nmap$c scan against a target host(s) $p Example ==> $g 192.168.1.1 $p or $g www.somewebsite.com  $x \n 3 $r Exit the script. $x"
echo " "
read -r -p " ==> " option
while [[ ! "$option" =~ [123] ]]; do # while loops all over the place to avoid user errors
        echo -e "$be $re  $p options are $g  1 2 or 3 $re $be $x"
        read -r -p " ==>  " option
done
# choose between running the ipsweeper, Nmap scan, or exit script
if [[ "$option" == 1 ]]; then
    	run_ping_scan # run ip sweeper
	ipp=true # boolien is now True final Nmap command should include the IP-Sweeper-Wizard as a read in file
elif [[ "$option" == 2  ]]; then
    	get_user_options # get input for Nmap command

else
    	echo -e "$b Good-Bye $x " # sorry, i know it was all the functions above and know your board
    	exit 0
fi

 show_ascii_art #;)

echo -e "$p Please enter a single letter$x"
#Get user options for either a ping scan regular scan or neither
echo -e "$r P, S, N, X $x." # Nmap options ping scan, script scan, other sacn type, or exit
echo -e "$c Would you like to run a \n \n $x (P)  $c ping scan \n \n $x (S) $c nmap scan \n \n $x (N) $c other type \n \n $x (X) $r Exit Script $x "
read -r -p " ==> " answer

while [[ ! "$answer" =~ [PpSsNnXx] ]]; do # Asking myself why i didnt use until loops?
    	echo -e "$be $re  $p Please enter $g  P, S, N, or X $be $re $x "
    	read -r -p " ==> " answer
done

show_ascii_art

# run the desired scan type if user choose to run a ping or scan
if [[ "$answer" =~ [Pp] ]]; then # ping scan options Nmap
	echo -e "$c (-PS) TCP-SYN-PING \n (-PA) TCP-ACT-ONLY-PING \n (-PU) UDP-PING \n (-PY) SCTP-PING  \n (-PE) ICMP-ECHO-PING  \n (-PN)   \n (-PP) ICMP-TIMESTAMP-PING  \n (-PP)  \n (-PM) ICMP-MASK-PING   \n (-PO icmp)-default  \n (-PO igmp) \n (-PO ip-in-ip)  \n (-PR) ARP-PING   $x "
    	ping_question=" "
    	ping_options=("-PS" "-PA" "-PU" "-PY" "-PE" "-PN" "-PP" "-PM" "-PO" "-PO igmp" "-PO ip-in-ip" "-PR")
    	ask_single_choice_question "$ping_question" "${ping_options[@]}"
    	choice=$(get_input)
    	user_choices+=("${ping_options[$((choice-1))]}")
    	echo -e "$c User choose ==> $p ${ping_options[$((choice-1))]} $x"
    	if $ipp; then
			echo -e "$c Would you like to check $p $ezy $c for$g operating system information $p -O$x ,$g system version information$p -sV $x, $g vulnability script scanning$p -sC$x ? $r Y|N $x "
    	else

			echo -e "$c Would you like to check $p $ezy $c for$g operating system information $p -O$x ,$g system version information$p -sV $x, $g vulnability script scanning$p -sC$x ? $r Y|N $x"
	fi
    	read -r -p " ==> " ossv
	show_ascii_art
	sysinfo_scan # running the -sc -sv -O -A options Nmap
elif [[ "$answer" =~ [Ss] ]]; then

	echo -e "$c What type of scan type would you want to run \n (-sS)  TCP-SYN-SCAN  \n (-sT)  TCP-SYN/ACK-CONNECT \n (-sA)  ACK-SCAN-ONLY (NO SYN) \n (-sO)  IP-PROTOCOL-SCAN \n (-sU)  UDP-SCAN \n (-sN)  TCP-NULL \n (-sF)  FIN-SCAN \n (-sX)  XMAS-SCAN \n (-sW)  WINDOW-SCAN  \n (-sM)  MAIMON-SCAN $x "
    	scan_question=" " # This is the script scanning options
    	scan_options=("-sS" "-sT" "-sA" "-sO" "-sU" "-sN" "-sF" "-sX" "-sW" "-sM")
    	ask_single_choice_question "$scan_question" "${scan_options[@]}"
    	choice=$(get_input)
    	user_choices+=("${scan_options[$((choice-1))]}")
    	echo -e " $c User choose==> $p ${scan_options[$((choice-1))]}  $x"
	if $ipp; then

		echo -e "$c Would you like to check $p $ezy $c for$g operating system information $p -O$x ,$g system version information$p -sV $x, $g vulnability script scanning$p -sC$x ? $r Y|N $x"
    	else

		echo -e "$c Would you like to check $p $ezy $c for$g operating system information $p -O$x ,$g system version information$p -sV $x, $g vulnability script scanning$p -sC$x ?$r Y|N $x"
	fi
	read -r -p " ==> " ossv
	show_ascii_art
	sysinfo_scan
elif [[ "$answer" =~ [Nn]  ]]; then
	if $ipp; then # If user doesnt want to ping or scan then assume they are a experienced user and want to get to the hacking options

		echo -e "$c Would you like to check $p $ezy $c for$g operating system information $p -O$x ,$g system version information$p -sV $x, $g vulnability script scanning$p -sC$x ?$r Y|N$x"
    	else

		echo -e "$c Would you like to check $p $ezy $c for$g operating system information $p -O$x ,$g system version information$p -sV $x, $g vulnability script scanning$p -sC$x ?$r Y|N$x"
	fi
	read -r -p " ==> " ossv
	show_ascii_art
	sysinfo_scan
else
	echo -e "$r X choosen, Good Bye $x" # You are half way there, why back out now?
	exit 0
fi

show_ascii_art

echo -e "$p Do you want to choose the ports to check$x" # because i am lazy give user a --top-ports option to avoid misuse of including there own input of ports
echo " " # the options available shoud fit any normal Nmap scan a person needs options from 5 ports to 65,535 ports
echo -e "$g You will have the options to run the $p --top-ports command. \n $c options range from $g top 5 ports $c up to all $g 65,535 ports$r Y|N  $x "
echo " "
read -r -p " ==> " answer

while_asking_question # simple while loop for a Y or N answer

if [[ "$answer" =~ [Yy] ]]; then
	echo -e "$c Which port option would you like to use: \n top (5) ports \n top (10) ports \n top (20) ports \n top (50) ports \n top (100) ports \n top (250) ports \n top (500) ports \n top (1000) ports \n top (2500) ports \n top (5000) ports \n top (10000) ports \n ALL ports (65535) $x "
    	port_question=" "
    	port_options=("5" "10" "20" "50" "100" "250" "500" "1000" "2500" "5000" "10000" "65535")
    	ask_single_choice_question "$port_question" "${port_options[@]}"
    	choice=$(get_input)
    	user_choices+=(--top-ports "${port_options[$((choice-1))]}")
    	echo -e "$c User choose ==> $p ${port_options[$((choice-1))]} $x"
else

    	echo -e "$c No port option choosen $x"

fi

show_ascii_art

echo -e "$p Would you like to choose a timing option$x"
echo " " # ALL timing options availabe slower scans = better results, faster scans = time saved with many ip's
echo -e "$r -T0-T6$c options available -T4 is defult $r Y|N $x "
echo " "
read -r -p " ==> " answer

while_asking_question

if [[ "$answer" =~ [Yy] ]]; then

		echo -e "$c What timing option would you like to use: \n paranoid (-T0) \n sneaky (-T1) \n polite (-T2) \n normal (-T3) \n aggressive (-T4) \n insane (-T5) $x "
    	timing_question=" "
    	timing_options=("-T0" "-T1" "-T2" "-T3" "-T4" "-T5")
    	ask_single_choice_question "$timing_question" "${timing_options[@]}"
    	choice=$(get_input)
    	user_choices+=("${timing_options[$((choice-1))]}")
    	echo -e "$c User Choose ==>$p  ${timing_options[$((choice-1))]} $x"
else

    	echo -e "$c No timing option choosen $x" # ASS U ME ing most users will want to choose a timing option

fi

show_ascii_art

echo -e "$p Do you want to mask your real ip address with other ip addresses$x"
echo " " # Becuse stealth thats why duhh. How many decoys are acceptable??? 5-20 i gave for options
echo -e "$b These are decoy scans with up to 20 fake ip addresses $r Y|N  $x "
echo " "
read -r -p " ==> " answer

while_asking_question

if [[ "$answer" =~ [Yy] ]]; then

	mask_question=" "
	mask_options=("RND:5" "RND:10" "RND:15" "RND:20")
	ask_single_choice_question "$mask_question" "${mask_options[@]}"
    	choice=$(get_input)
    	user_choices+=("-D" "${mask_options[$((choice-1))]}")
    	echo -e "$c User choose ==> $p ${mask_options[$((choice-1))]} $x"
else

    	echo -e "$c No masking option choosen $x" # Maybe you are just scanning your home router.

fi

show_ascii_art

echo " " # Here comes the biggest headache for me. How to give the pentester, hacker, security consultant, the best options available there are over 600 scripts!!!
echo -e "$c This next part deals with $p Nmap's scripting engine (.nse) options.\n $b There are over 600 options available. \n $g Please take your time when choosing \n $r This script assumes you have a good understanding of the... \n how, when, and why's of the scripts you pick.$x "
read -r -p "Press enter when ready."
echo -e "$c Would you like to run the $p nmap scripting engine (.nse)$c scripts option? $r Y|N $x " # i understand if user said no
echo " "
read -r -p " ==> " nse
while [[ ! "$nse" =~ [YyNn] ]]; do
	echo -e "$be $re  $p Please enter $g Y|N $be $re $x "
	read -r -p " ==>  " nse
done
clear
# multi choice for Nmap scripting engine scans
if [[ "$nse" =~ [Yy] ]]; then
		echo -e "$c Please choose all options that apply followed by a comma. $p Example ==> $g 1,2,3,4,5 \n $c \n \n Keep in mind these script could take a very long time to run. $x"
		nse_question=" " # this is also where multi options are available for user because it takes a LONG time to run 600 scripts 1 by 1
		nse_options=($(cat Scripts/nmap-scripts.txt|sort)) # This line is the pride of my work. HOW to give user ALL nse scripts as a option.
		ask_multiple_choices_question "$nse_question" "${nse_options[@]}"
		choice=$(get_input)
		IFS=',' read -ra choice_array <<< "$choice"
		user_choices+=("--script") # Adding the --script syntax so Nmap knows what we are trying to do WITHOUT adding --script before ALL user options
		for ((z=0; z<"${#choice_array[@]}"; z++)); do
    		user_choices+=("${nse_options[$((choice_array[z]-1))]}")
    		if [ $z -lt $(( ${#choice_array[@]} - 1 )) ]; then
        		# shellcheck disable=SC2054
        		user_choices+=(,) # Adding a , between the script options if multipal options where used
    		fi
		done

else
		show_ascii_art
		echo -e "$c No nse scripts choosen" # I worked hard on this part and you dont even care.
fi

show_ascii_art

echo -e "$p Do you want to save nmap's output to a file$x"
echo -e "$b Options include $x "
# option for saving Nmaps output to a file
echo -e "$g  Normal file$p -oN$x \n $g Xml file$p -oX$x \n $g Gripable file$p -oG$x \n $g All 3 above options$p -oA \n $r Y|N $x"
echo " "
read -r -p " ==> " answer

while_asking_question

if [[ "$answer" =~ [Yy] ]]; then
	echo -e "$c Which file type to output?:\n $x 1 $c normal text file (-oN) $x \n \n  2 $c xml file (-oX) $x \n \n  3 $c gripable file (-oG) $x \n \n  4 $c all 3 types (-oA) $x"
	read -r -p " ==> " filetype
	until [[ "$filetype" =~ [1|2|3|4] ]]; do
		echo -e "$be $re $p Please enter $g 1,2,3,or4 $be $re $x "
		read -r -p " ==> " filetype
	done
	if $ipp; then # if user needs Nmap to read in a file as input
		case $filetype in
			1) outfile="-oN nmap-$ezy.txt";;
			2) outfile="-oX nmap-$ezy.xml";;
			3) outfile="-oG nmap-$ezy.grp";;
			4) outfile="-oA nmap-$ezy";;
			*) outfile=""; echo -e "$be $re $r Incorrect answer $be $re  no file will be created. $x " # tired of while loops now i just move on if you dont answer correctly
		esac
	else
		case $filetype in # no in file for Nmap we already have a ip or url
            		1) outfile="-oN nmap-$ezy.txt";;
            		2) outfile="-oX nmap-$ezy.xml";;
            		3) outfile="-oG nmap-$ezy.grp";;
            		4) outfile="-oA nmap-$ezy";;
            		*) outfile=""; echo -e "$be $re $r Incorrect answer $be $re no file will be created. $x" # Diddo ^
		esac
	fi

else
	outfile="" # user didnt want to create a outfile for Nmaps output
fi

echo " "
# if statement to run the correct command dependent on earlier user options with ip sweeper wizard file as Nmap input or not
if $ipp; then # If ip-sweeper scan is true
	final_command_ping # then show user the Nmap command with -iL ipsweep<file>.txt as the in file to read
else
	final_command_nmap # else dont
fi

#  run the above Nmap scan(s) should user be satified with the command
echo -e "$c Would you like to run the nmap command?$r Y|N $c \n \n type$r N$c to exit  $x"
echo " "
read -r -p " ==> " scan
while [[ ! "$scan" =~ [YyNn] ]]; do
	echo -e "$be $re  $p Please enter $g Y|N$be $re $x "
	read -r scan
done

if [[ "$scan" =~ [Yy] ]]; then
	run_final_scan

else
	show_ascii_art
	echo -e "$ar $c Thank you for using my$p IP-Sweeper-Wizard$c script  $al $x"
	sleep 5
	clear
	exit
fi
: '
if $parse; then
	if $ipp; then
		# Check if the nmap command contains all necessary options
		nmap_command="nmap -A --script -oX .xml"
		if substring_exists "$final_command_ping" "$nmap_command"; then
    			# Prompt the user whether they want to run the Python script
    			read -p "Do you want to parse the .xml Nmap output? (Y/N): " answer
			while_asking_question
    			if [[ "$answer" =~ [Yy] ]]; then
        		# Run the Python script
        		python3 ./Scripts/parser.py "nmap-$ezy.xml" > parsed-nmap-$ezy.xml
    		fi
	else
		nmap_command="nmap -A --script -oX .xml "
                if substring_exists "$final_command_nmap" "$nmap_command"; then
                        # Prompt the user whether they want to run the Python script
                        read -p "Do you want to parse the .xml Nmap output? (Y|N): " answer
			while_asking_question
                        if [[ "$answer" =~ [Yy] ]]; then
                        # Run the Python script
                        python3 ./Scripts/parser.py "nmap-$ezy.xml" > parsed-nmap-$ezy.xml
                fi
fi
'
exit 0
