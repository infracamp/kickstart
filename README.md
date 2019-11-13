# kickstart

See [https://infracamp.org/project/kickstart] for detailed documentation.

## TL;DR

Download the `kickstart.sh` and install it by executing the curl command provided blow and place and 
commit it within your project directory. To start-up a project you then just clone the repository and
execute `./kickstart.sh` inside the projects root directory.

On your local workstation, `kickstart.sh` will:
- Start up the container setting env `DEV_MODE=1` and giving you an **interactive shell** as user `user` inside the container.
- Mount the **project directory** to `/opt` inside the container so every user has the same absolute path.
- Expose **ports 80,4000,4100,4200** on localhost so you can access the service with any browser at `http://localhost`
  (configured by project in `.kickstartconfig` or global in `$HOME/.kickstartconfig`)
- **Detect operating system** and container service (OSx, Linux, WSL2)
- Set the **uid** of user `user` inside the container according to your actual uid so there will no permission problems
- Check for other running instances of the project (Choose between: Kill, Shell or Ignore)
- Securely mount your **ssh-key** into the container, so you can use git within your container
- Mount the **bash history** into the container
- Mount **cache directories** for **apt, npm, composer, pip** into the container
- Evaluate global `$HOME/.kickcstartonfig` file for additional mounts/ports/settings
- Securely provide developer's **secrets** from `$HOME/.kickstart/secrets/<project>/<secret_name>`to the container
- Set **environment variables** according to `.env`-file
- Detect and provide the **hosts's IP address** to the container (for running debuggers, etc) as env `DOCKER_HOST_IP`
- Start **additional services** from `.kick-stack.yml` in composer format
- Setup interactive shell (colors, screen-size, adjustments for osX, non-interactive shells)
- **Run commands** defined in `.kick.yml`-file in the project folder (if using kickstart-flavor-containers)
- Inform you about **updates** of `kickstart.sh` and provide auto-download updates by calling `./kickstart.sh --upgrade`
- Provide access to **skeleton projects** that can be defined in a central git repository

On testing stage `kickstart.sh` will:
- Execute the tests the same way they will be executed in CI/CD environment. So you can debug 
  on localhost instead of pushing over any over again.

On CI/CD pipeline `kickstart.sh` will:
- Ensure no ssh-keys or secrets are copied inside the container.
- **Auto-detect** `gitlab-ci`, `github-actions`, `jenkins` build environment and determine `TAG` and `BRANCH`
- Set permissions according to the build environment
- **Build the container** running `docker build` and tagging with the correct tags
- Logging into the **registry** accoring to the build environment
- **Pushing** to a registry defined inside the build environment

On Deploy-stage:
- Autodetect docker-swarm, kubernetes by environment inside build environment
- HTTP-PUSH to hooks urls

A bash script to start and manage your develompment containers.

## Quick Start

Run the container defined in `.kick.yml`:
```
./kickstart.sh
```

Run a command defined in `.kick.yml`-`command:` section:
```
./kickstart.sh :[command]
```

List available skeletons:
```
./kickstart.sh skel list
```

Install skeleton:
```
./kickstart.sh skel install <name>
```

Upgrade to newest kickstart version:
```
./kickstart.sh upgrade
```

Run a ci-build (build and push using gitlab-ci-runner):
```
./kickstart.sh ci-build
```





## Documents index

- [InfraCamp Homepage](http://infracamp.org)
- [**Setting up your environment**](doc/setup/installing-ubuntu-debian-mac.md)
- [Bash Scripting 101](doc/bash_scripting101.md)
- [.kick.yml reference](doc/kick.yml.md)

## Project setup: Kickstart

**Copy'n'Paste installer script**: (execute as user in your project-directory)
```bash
curl -o kickstart.sh "https://raw.githubusercontent.com/infracamp/kickstart/master/dist/kickstart.sh" && chmod +x kickstart.sh
```

The script will save [kickstart.sh](https://raw.githubusercontent.com/infracamp/kickstart/master/dist/kickstart.sh) to the
current directory and set the executable bit.

**Run kickstart:**
```bash
./kickstart.sh
```

Kickstart will create an empty `.kick.yml` file in the current directory. You might want to edit
at least the `from:`-Line.


## .kick.yml - Kickstart configuration file. *([Full Docs](doc/kick.yml.md))*

```yaml
version: 1
from: "infracamp/kickstart-flavor-ubuntu"

..more options..
```

Run `./kickstart.sh` - the container should start.

To select a special flavor select

```yaml
version: 1
from: "infracamp/kickstart-flavor-gaia"
```



## Available Flavors

See [infracamp.org/container/](https://infracamp.org/container/) for
full list and links to their documentation.

## Writing config-files

`.kick.yml:`
```yaml
config_file:
  template: "config.php.dist"
  target: "config.php"
```

Will read `config.dist.php` file, which will be parsed copied into config.php.

`config.php.dist`
```php
<?php
define("CONF_MYSQL_HOST", "%CONF_MYSQL_HOST%");
define("VERSION_STRING", "%VERSION_STRING%");
```

The configuration will be loaded from environment variables.


## Development and Deploy Tool: `kick`

You can define commands and run it inside the container.

```
version: 1
from: "infracamp/kickstart-flavor-gaia"

command:
    build:
        - "echo 'Build called'"
    run:
        - "echo 'Run called'"
        
    do_something:
        - "echo 'doing something'"
```

- Will work from any directory
- All paths relative to .kickstart.yml
- Run commands: `kick do_something`


## Starting a stack of helper services

Kickstart will search for a file `.kick-stack.yml` in the project main
directory. If this file exists, it will be deployed as docker stack.

**Make sure, all services you want to access from within your container
are attached to the external network `project_name`**

Assume our project_name is `my_proj_1` and we want to provide a mysql service
```yaml
version: "3"
services:
  mysqld:
    image: mysql
    networks:
      - my_proj_1


networks:
  my_proj_1:
    external: true
```

The mysql service will be availabe as `my_proj_1_mysqld`.


## System-wide config file

Kickstart will read the user-config from:
```
~/.kickstartconfig
```

Available Options:

```
KICKSTART_DOCKER_RUN_OPTS=""        # Optional parameters passed to the docker run command
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


### Add links to other containers

Start one or more containers. If you are not using kickstart, make sure
you specify a name with the parameter `--name`.

Create, if not already exisitng a project-wide `.kickstartconfig` file.
Add a Line:

```
KICKSTART_DOCKER_RUN_OPTS="--link otherContainerName"
```



## Building containers

You can build ready-to-deploy containers with kickstart. Just add a `Dockerfile`
to your Project-Folder

```dockerfile
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