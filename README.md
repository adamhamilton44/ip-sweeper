![![LOGO][def2]][def3]
# ping sweeper with Network Mapper support

Ping sweep a 1-255 ip range and run nmap against the found ip's.


## Author
Adam Hamilton
- [Github](https://www.github.com/adamhamilton44)

- [Email](blacklisthacker@protonmail.com)
## Contributing

Contributions are always welcome!

See Above for ways to get ahold of me.

## Features

- Program will ask for first 3 octects if not provided when running script. example: ipsweep 192.168.10
- After ipsweep is done it will save to current folder under ipsweep.192.168.10.txt.
- Next it will ask you if you would like to run a full nmap port scan against found ip addresses.
- If yes then it will append all information in the same file it read the ip's from.  

## Feedback

If you have any feedback, please reach out to me at [Email](blacklisthacker@protonmail.com)

## Optimizations

Added the ability to ask user for ip address if not provided.

Added ability to run a nmap port discovery scan on all ports against found ip addresses

## Run Locally

Clone the project

```bash
  https://github.com/adamhamilton44/ip-sweeper.git
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
I'm a self taught noob this is my first project i have opened to Github.

## Script
![![IP-Sweeper][def2]](IP_SWEEPER.png)


## Acknowledgements
A Special thanks to all the Bash Scripting Language Influncers that have helped me along the way.

 - [The Cyber Mentor](@TCMSecurityAcademy)
 - [HackerSploit](@HackerSploit)
 - [Learn Linux TV](@LearnLinuxTV)
 - [Network Chuck](@networkchuckacademy)
 - [John Hammond](@_JohnHammond)
 - [David Bombal](@davidbombal)

## Github Profile Sections

👩‍💻 I'm currently working on more bash scripts

💬 Ask me about anything

📫 How to reach me Email: blacklisthacker@protonmail.com

⚡️ Fun fact I am actually a Professional dog trainer.
   [My website](https://good-happy-puppy.com) 

# Fund My Projects

Bitcoin: 3ENrACvnNY7AYG7HUvcdwJgZjnpoaQ9Lbt


[def]: /root/Documents/Github/MyCurrentProject/IP_Sweeper.png
[def2]: https://carbon.now.sh/?bg=rgba%2825%2C46%2C9%2C1%29&t=3024-night&wt=none&l=auto&width=680&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=56px&ph=56px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code=%2523%21%252Fusr%252Fbin%252Fenv%2520bash%250A%250A%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%250A%2523%2520Created%253A%2520by%2520Adam%2520Hamilton%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2523%250A%2523%2520Version%253A%25201.0.2%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2523%250A%2523%2520Date%253A%2520SUN%252012%252F31%25202%253A19%2520P.M.%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2523%250A%2523%2520Usage%253A%2520simple%2520ip%2520sweep%2520with%2520nmap%2520abilities%2520%2523%250A%2523%2520Fixes%253A%2520added%2520error%2520handeling%2520for%2520ip%2520range%2520%2520%2523%250A%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%250A%250A%2523%2520color%2520variables%250A%2523%2520red%250Ar%253D%2524%27%255Ce%255B1%253B31m%27%250A%2523%2520green%250Ag%253D%2524%27%255Ce%255B1%253B32m%27%250A%2523%2520purple%250Ap%253D%27%255Ce%255B0%253B35m%27%250A%2523%2520warning%250Aw%253D%27%255Ce%255B1%253B31m%255B%255Ce%255B5%253B31mERROR%255Ce%255B0m%255Ce%255B1%253B31m%255D%255Ce%255B0m%27%250A%2523%2520reset%250Ax%253D%2524%27%255Ce%255B0m%27%250A%2523%2520cyan%250Ac%253D%2524%27%255Ce%255B1%253B36m%27%250A%2523%2520blue%250Ab%253D%2524%27%255Ce%255B1%253B34m%27%250A%250A%250A%250Aecho%2520-e%2520%2522%2524b%2520%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2522%250Aecho%2520-e%2520%2522%2524r%2520%252F%2520%2520%2520%2520%2520%2520_%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%252F%2520%2522%250Aecho%2520-e%2520%2522%2524g%2520%255C%2520%2520%2520%2520%2520%28_%29___%2520%2520%2520%2520%2520%2520%2520%2520______%2520%2520%2520%2520%2520%2520_____%2520%2520___%2520%2520____%2520%2520___%2520%2520_____%2520%2520%255C%2520%2522%250Aecho%2520-e%2520%2522%2524p%2520%252F%2520%2520%2520%2520%252F%2520%252F%2520__%2520%255C______%252F%2520___%252F%2520%257C%2520%252F%257C%2520%252F%2520%252F%2520_%2520%255C%252F%2520_%2520%255C%252F%2520__%2520%255C%252F%2520_%2520%255C%252F%2520___%252F%2520%2520%252F%2520%2522%250Aecho%2520-e%2520%2522%2524c%2520%255C%2520%2520%2520%252F%2520%252F%2520%252F_%252F%2520%252F_____%28__%2520%2520%29%257C%2520%257C%252F%2520%257C%252F%2520%252F%2520%2520__%252F%2520%2520__%252F%2520%252F_%252F%2520%252F%2520%2520__%252F%2520%252F%2520%2520%2520%2520%2520%2520%255C%2520%2522%250Aecho%2520-e%2520%2522%2524r%2520%252F%2520%2520%252F_%252F%2520.___%252F%2520%2520%2520%2520%2520%252F____%252F%2520%257C__%252F%257C__%252F%255C___%252F%255C___%252F%2520.___%252F%255C___%252F_%252F%2520%2520%2520%2520%2520%2520%2520%252F%2520%2522%250Aecho%2520-e%2520%2522%2524g%2520%255C%2520%2520%2520%252F_%252F%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%252F_%252F%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%255C%2520%2522%250Aecho%2520-e%2520%2522%2524x%2520%252F%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%252F%2520%2522%250Aecho%2520-e%2520%2522%2524b%2520%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2523%2522%250A%250A%2523%2520create%2520a%2520variable%2520for%2520first%2520added%2520arguements%250Aout%253D%2522%25241%2522%250A%250A%2523%2520Ask%2520user%2520for%2520the%2520first%25203%2520octets%2520of%2520ip%2520address%2520if%2520not%2520supplied%2520when%2520calling%2520script%250Aif%2520%255B%2520%2522%2524out%2522%2520%253D%253D%2520%2522%2522%2520%255D%253B%2520then%250A%2520%2520%2520%2520%2509echo%2520-e%2520%2522%255Cn%2520%2524c%2520Please%2520enter%2520%2524r%2520ONLY%2520%2524c%2520the%2520first%2520%2524r%255B3%255D%2524c%2520oxtets%253A%2520%2524g%2520Example%253A%2520%2524c%2520192.168.1%2520%2524x%2522%250A%2509read%2520-r%2520out%250A%2520%2520%2520%2520%2509%2523%2520make%2520sure%2520user%2520supplied%2520the%2520correct%2520range%2520for%2520sweeper%2520%253D%2520to%2520minumim%25201.1.1%2520-%2520maxium%2520255.255.255%250A%2509%2509%255B%255B%2520%2522%2524out%2522%2520%253D%7E%2520%255E%2825%255B0-5%255D%257C2%255B0-4%255D%255B0-9%255D%257C1%255B0-9%255D%255B0-9%255D%257C%255B1-9%255D%255B0-9%255D%257C%255B1-9%255D%29%255C.%2825%255B0-5%255D%257C2%255B0-4%255D%255B0-9%255D%257C1%255B0-9%255D%255B0-9%255D%257C%255B1-9%255D%255B0-9%255D%257C%255B1-9%255D%29%255C.%2825%255B0-5%255D%257C2%255B0-4%255D%255B0-9%255D%257C1%255B0-9%255D%255B0-9%255D%257C%255B1-9%255D%255B0-9%255D%257C%255B1-9%255D%29%2524%2520%255D%255D%2520%2526%2526%2520echo%2520-e%2520%2522%255Cn%2520%2524p%2520Running%2520ip-sweeper%2520on%2520the%2520ip%2520range%253A%2520%2524c%2520%2524out%2520%2524x%2522%2520%257C%257C%2520%257B%2520echo%2520-e%2520%2522%255Cn%2520%2524w%2520%2524r%2520Incorrect%2520format%2520or%2520range%2520%2524w%2520%2524r%2522%253B%2520exit%25201%253B%2520%257D%250A%2509for%2520ip%2520in%2520%2560seq%25201%2520%2520254%2560%253B%2520do%250A%2520%2520%2520%2520%2509ping%2520-c%25201%2520-W%25200.30%2520%2522%2524out
[def3]: IP_Sweeper.png
