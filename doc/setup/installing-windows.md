# Windows 10 Pro / Enterprise / Server

> This will ***not*** work for ***Windows 10 Home*** due to a lack of HyperV support

- Install Docker for windows from [dockerstore](https://www.docker.com/docker-windows)

- Search for ***Docker for Windows*** > ***Settings*** And activate ***Expose daemon on tcp://localhost:2375 without TLS***

- Go to ***Settings*** > ***Update & Security*** > ***For developers*** and activate ***Developer mode***

- Go to ***Control Panel*** > ***Programs*** and select ***Turn Windows features on or off***: 
  Select (activate) ***Windows Subsystem for Linux (Beta)*** and reboot
  
- Download and start ***ubuntu*** by following this [link](https://aka.ms/wslstore)
  
- Click to start menu and type ***bash***, accept the Terms and Conditions.

- Turn off  W3SVC (World Wide Web Publishing Service): Search for ***Services***, scroll down and deactivate this service (if it's active).

- Deactivate HTTP.SYS service on port 80 by running `netsh http add iplisten ipaddress=::` in ***Windows PowerShell***

Within bash run

## The manual way

Follow these steps if you don't want to run our automatic setup:

```
echo "export DOCKER_HOST=tcp://127.0.0.1:2375" >> ~/.bashrc
echo "KICKSTART_WIN_PATH=C:/" >> ~/.kickstartconfig

sudo apt-get update
sudo apt-get install curl git
```
...and follow the docker-cd [installation guide](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

**Do not install docker.io using ubuntu's repositories. The client won't be able to speak to the server**

## Automatic setup script

Launch `bash` in command dialog (or windows search). Copy and past 
the installer: [see the source](installer/win-ubuntu-docker-install.sh)

```
sudo apt update && sudo apt install curl && bash < curl  -H 'Cache-Control: no-cache' -s "https://raw.githubusercontent.com/c7lab/kickstart/master/doc/intaller/win-ubuntu-docker-install.sh"
```

You should now be able to execute `docker run hello-world` without error.

In case of trouble, see [Windows 10 pro notes](installing-windows-versions.md).


Create a SSH Key (and copy it to windows user directory)
```
ssh-keygen -o -a 150 -t ed25519
cp ~/.ssh/id_ed25519* /mnt/c/Users/[yourUserName]
```



## Other Operating Systems

Tested versions of windows:

| Date       | Windows    | Docker     | Working |
|------------|------------|------------|---------|
| 2018-04-14 | 10.0.16299 | 18.03.0-ce | yes     |

