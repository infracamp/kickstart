# Setting up Ubuntu/Kubuntu 16.04, 17.10, 18.04 for kickstart

## Debain only: Setup testing repository (stetch / debian 9)

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

```
apt update
apt install docker.io curl
gpasswd -a yourUserName docker
```

## Install Docker and setup (both Ubuntu/Debian)

As user run:
```bash
sudo apt-get install docker.io curl
sudo gpasswd -a $USER docker
```
This will install docker and curl and add your local user to the docker group.

Logout and login again. You should be able to run `docker ps` without warnings as
unprivileged user.

***Network Setup***

Edit `/etc/network/interfaces` and add 

```yaml
auto eno0:10
iface eno0:10 inet static
    address 10.10.10.10
    netmask 255.255.255.255
```

(replace `eno0` with the correct interface name on your desktop)

run `sudo /etc/init.d/networking restart` and you should be able to 
`ping 10.10.10.10`.