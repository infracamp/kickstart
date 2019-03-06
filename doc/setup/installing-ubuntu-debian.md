# Setting up Ubuntu/Kubuntu, MacOS, Debian for kickstart

This document covers docker setup and install instructions for:

- [Ubuntu >16.04](#ubuntu)
- [MacOS](#macos)
- [Debian](#debian)

For Windows10 see the [KickGuest Virtualbox Project](/projects/kickguest-virtualbox/)


## <a name="ubuntu"></a> Ubuntu Install (16.04 - 18.10)

As user run:
```bash
sudo apt-get install docker.io curl
sudo gpasswd -a $USER docker
```
This will install docker and curl and add your local user to the docker group.

Logout and login again. You should be able to run `docker ps` without warnings as
unprivileged user.

**Thats it**


## <a name="ubuntu"></a> MacOS Install

- [Download stable Docker.dmg](https://download.docker.com/mac/stable/Docker.dmg)
- Install by dragging the file into the application bar 

Run terminal

```
docker info
docker ps
```

Should work right out of the box.


## <a name="debian"></a> Debain Install (stetch / debian 9)

The package `docker.io` is only included in debians `testing` branch.

To only install packages from `testing` if required, edit your apt-preferences:

Edit `/etc/apt/preferences.d/000` to

```
Package: *
Pin: release a=stable
Pin-Priority: 700

Package: * 
Pin: release a=testing
Pin-Priority: 650
```

And add the testing-sorurces to `/etc/apt/sources.list`:

```
deb http://mirror.eu.oneandone.net/debian/ unstable main contrib non-free
```

```bash
sudo apt update
sudo apt install docker.io curl
sudo gpasswd -a $USER docker
```

