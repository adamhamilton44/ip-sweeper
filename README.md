[Logo](IP-Sweeper-Wizard.png)

A Ping Sweeping Wizard with Full NMAP Support

Ping sweep a 1-255 IP range, retrieve your results, proceed to execute Nmap commands with the discovered IPs.
Author

Adam Hamilton

    GitHub
    Email

Contributing

Contributions are always welcome!
Please refer to the contact information above to get in touch.

## Features

    Choose between running a ping sweep or proceeding directly to Nmap.
    IP Sweeper Wizard prompts for the first 3 octets (e.g., 192.168.10.), then performs a ping scan from 192.168.10.1 to 192.168.10.255.
    Upon completion, a file is saved as ipsweep.<IP range>.txt in the user's current working directory (e.g., ipsweep.192.168.10.txt).
    Option to run an Nmap scan against the discovered IPs.
    Multiple Nmap options available:
        Timing options (-T0 to -T6)
        host scanning options (-Psauye)
        Script scanning options (-Sstunxfwncv)
        Operating system enumeration (-O)
        IP or Hostname options (192.168.20.5),(www.website.com)
        Decoy scanning options (-D RND:5,10,15,20)
        Top ports (--top-ports 5 to 65535)
        Output file options (-oNXGA)
        Show final nmap command before running
    Note: NMAP's --script (scanning options) when used with this script assume you have a good understanding of how and when to use.

Feedback

Feel free to reach out with any ideas or feedback at blacklisthacker@protonmail.com.
Run Locally

 Clone the project

```bash
  git clone https://github.com/adamhamilton44/ip-sweeper.git
```

Go to the project directory

```bash
  cd ipsweep
```

Install Dependcies

```bash
  sudo apt update
  sudo apt install ping -y
  sudo apt install nmap -y
```

Copy ipsweep.sh to $PATH

```bash
  sudo cp ipsweep.sh /usr/local/bin/ipsweep

```
Run anywhere
ipsweep

## 🚀 About Me
I'm a self taught noob this was my first project i opened to Github.

# Source Code
![]()

## User Experience
- ASCII ART
[here][def10]
- IP-Sweeper-Wizard found ip's
[here][def11]
- Ping scan or nmap scan options
[here][def2]
- nmap ip address or URL
[here][def3]
- URL options
[here][def4]
- Port options
[here][def5]
- Decoy options
[here][def12]
- Timing options
[here][def6]
- Outfile options
[here][def7]
- Final command
[here][def8]

## User Error
- User Error Message
[here][def9]

## Sudo Options
- Sudo option
[here][def]


## Acknowledgements
A Special thanks to all the Bash Scripting Language Influncers that have helped me along the way.

 - [The Cyber Mentor](@TCMSecurityAcademy)
 - [HackerSploit](@HackerSploit)
 - [Learn Linux TV](@LearnLinuxTV)
 - [Network Chuck](@networkchuckacademy)
 - [John Hammond](@_JohnHammond)
 - [David Bombal](@davidbombal)

## Github Profile Sections

👩‍💻 Currently working on advancing into more complex Bash scripts.

💬  Feel free to ask me about anything.

📫 Reach me via Email: blacklisthacker@protonmail.com

⚡️ Fun fact: I am actually a professional dog trainer. [Visit my website](https://good-happy-puppy.com)

# Fund My Projects

Bitcoin: 3ENrACvnNY7AYG7HUvcdwJgZjnpoaQ9Lbt


[Logo]: IP-Sweeper-Wizard.png
[def]: sudo.png
[def2]: pingORnmap.png
[def3]: hostype.png
[def4]: full-website-options.png
[def5]: ports-option.png
[def6]: timing-options.png
[def7]: outfile-options.png
[def8]: outcommand.png
[def9]: errors.png
[def10]: asciiart.png
[def11]: sweepername.png
[def12]: decoy-options.png
