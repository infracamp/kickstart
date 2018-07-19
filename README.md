# kickstart - Autoprovisioning Microservice Container (Linux, Windows10, MacOS)





## Documents index

- [**Setting up your environment**](doc/installing.md)
- [Bash Scripting 101](doc/bash_scripting101.md)

## Project setup: Kickstart

**Copy'n'Paste installer script**: (execute as user in your project-directory)
```bash
curl -o kickstart.sh "https://raw.githubusercontent.com/infracamp/kickstart/master/bin/kickstart.sh" && chmod +x kickstart.sh
```

The script will save [kickstart.sh](https://raw.githubusercontent.com/c7lab/kickstart/master/opt/kickstart.sh) to the
current directory and set the executable bit.

**Run kickstart:**
```bash
./kickstart.sh
```

Kickstart will create an empty `.kick.yml` file in the current directory. You might want to edit
at least the `from:`-Line.


## .kick.yml - Kickstart configuration file.

```yaml
version: 1
from: "infracamp/kickstart"



```

Run `./kickstart.sh` - the container should start.

To select a special flavor select

```yaml
version: 1
from: "infracamp/kickstart-flavor-gaia"
```


## Available Flavors

| Flavor  | Pull-Name                          | Software                                    | Support                      |    |
|---------|------------------------------------|---------------------------------------------|------------------------------|----|
|         | `infracamp/kickstart-flavor-bare`   | <base container>                            |                              | [![Docker Pulls](https://img.shields.io/docker/pulls/continue/kickstart.svg)](https://hub.docker.com/r/continue/kickstart/) [![Docker layers](https://images.microbadger.com/badges/image/continue/kickstart.svg)](https://microbadger.com/images/continue/kickstart) |
| gaia    | `infracamp/kickstart-flavor-gaia`   | apache2, php7.2, imagemagick, xsl, ...      | [details](https://github.com/c7lab/kickstart-flavor-gaia/blob/master/README.md)    | [![Docker Pulls](https://img.shields.io/docker/pulls/continue/kickstart-flavor-gaia.svg)](https://hub.docker.com/r/continue/kickstart-flavor-gaia/) [![Docker layers](https://images.microbadger.com/badges/image/continue/kickstart-flavor-gaia.svg)](https://microbadger.com/images/continue/kickstart-flavor-gaia) |
| erebos  | `infracamp/kickstart-flavor-erebos` | nodejs, angular-cli (5)                     | [details](https://github.com/c7lab/kickstart-flavor-erebos/blob/master/README.md)  | [![Docker Pulls](https://img.shields.io/docker/pulls/continue/kickstart-flavor-erebos.svg)](https://hub.docker.com/r/continue/kickstart-flavor-erebos/) [![Docker layers](https://images.microbadger.com/badges/image/continue/kickstart-flavor-erebos.svg)](https://microbadger.com/images/continue/kickstart-flavor-erebos) |

___(do you have ready to use containers - append it to this list)___

## Writing config-files

```.kick.yml```
```
config_file:
  template: "config.php.dist"
  target: "config.php"
```

Will read `config.dist.php` file, which will be parsed copied into config.php.

```config.dist.php```
```
<?php
define("CONF_MYSQL_HOST", "%CONF_MYSQL_HOST%");
define("VERSION_STRING", "%VERSION_STRING%");
```

The configuration will be loaded from environment variables.


## Development and Deploy Tool: `kick`

- Will work from any directory
- All paths relative to .kickstart.yml
- Exec by default: `kick init`

## System-wide config file

Kickstart will read the user-config from:
```
~/.kickstartconfig
```

Available Options:

```
KICKSTART_PORTS="80:4200;25:25"     # Change the Port-Mappings
KICKSTART_WIN_PATH=                 # If running on windows - map bash 
```

## Project-wide config file

```
./kickstartconfig
```


## Defaults

### Networking

By default, kickstart will configure debuggers to send data to `10.10.10.10`. So 
this ip should be added to your pc's networks.


## Building containers

You can build ready-to-deploy containers with kickstart. Just add a `Dockerfile`
to your Project-Folder

```
FROM infracamp/kickstart-flavor-gaia

ENV DEV_CONTAINER_NAME="some_name"
ENV HTTP_PORT=80

ADD / /opt
RUN ["bash", "-c",  "chown -R user /opt"]
RUN ["/kickstart/container/start.sh", "build"]

ENTRYPOINT ["/kickstart/container/start.sh", "standalone"]
```

Interval: A `kick interval` will be triggered every second (synchronous).

To save cpu-time you could add this to your `.kick.yml`
```yaml
command:
    interval:
      - "sleep 300"

```

## Building own flavors

Feel free to build your own flavors.

Some rules:

- Each flavor should reside in an separate repository
- It must build the tags `latest` (stable release) and `testing` (current master branch build)
- It must provide tests
- And should provide easy to use documentation
- It should build using hub.docker.com public build service (free of charge!)

Flavor names derive from greek mystical names [click](https://de.wikipedia.org/wiki/Griechische_Mythologie)