#!/bin/bash
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# DO NOT EDIT THIS FILE! CHANGES WILL BE OVERWRITTEN ON UPDATE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Ready to use development containers. Just run ./kickstart.sh to start
# a development environment for this project.
#
# Config-File: .kick.yml
#
# Kickstart home: https://github.com/c7lab/kickstart
#
# Author: Matthias Leuffen <leuffen@continue.de>
#

# Error Handling.

trap 'on_error $LINENO' ERR;
PROGNAME=$(basename $0)
PROGPATH="$( cd "$(dirname "$0")" ; pwd -P )"   # The absolute path to kickstart.sh

function on_error () {
    echo "Error: ${PROGNAME} on line $1" 1>&2
    exit 1
}



CONTAINER_NAME=${PWD##*/}

export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'

if [ "$DEV_CONTAINER_NAME" != "" ]
then
    echo -e $COLOR_RED "\n[ERR] Are you trying to run kickstart.sh from inside a kickstart container?!"
    echo "(Detected DEV_CONTAINER_NAME is set in environment)"
    echo -e $COLOR_NC
    exit 4;
fi;

command -v curl >/dev/null 2>&1 || { echo -e "$COLOR_LIGHT_RED I require curl but it's not installed (run: 'apt-get install curl').  Aborting.$COLOR_NC" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo -e "$COLOR_LIGHT_RED I require docker but it's not installed (see http://docker.io).  Aborting.$COLOR_NC" >&2; exit 1; }





_KICKSTART_DOC_URL="https://github.com/infracamp/kickstart/"
_KICKSTART_UPGRADE_URL="https://raw.githubusercontent.com/infracamp/kickstart/master/dist/kickstart.sh"
_KICKSTART_RELEASE_NOTES_URL="https://raw.githubusercontent.com/infracamp/kickstart/master/dist/kickstart-release-notes.txt"
_KICKSTART_VERSION_URL="https://raw.githubusercontent.com/infracamp/kickstart/master/dist/kickstart-release.txt"

_KICKSTART_CURRENT_VERSION="1.2.0"

##
# This variables can be overwritten by ~/.kickstartconfig
#
KICKSTART_WIN_PATH=""

# Publish ports - separated by semikolon (define it in .kickstartconfig)
KICKSTART_PORTS="80:80/tcp,4000-4999:4000-4999/tcp,4000-4999:4000-4999/udp"
# KICKSTART_PORTS="80:4200/tcp;81:4450/udp"

KICKSTART_DOCKER_OPTS=""
KICKSTART_DOCKER_RUN_OPTS=""

if [ -e "$HOME/.kickstartconfig" ]
then
    echo "Loading $HOME/.kickstartconfig"
    . $HOME/.kickstartconfig
fi

if [ -e "$PROGPATH/.kickstartconfig" ]
then
    echo "Loading $PROGPATH/.kickstartconfig (This is risky if you - abort if unsure)"
    sleep 1
    # @todo Search for .kickstartconfig in gitignore to verify the user wants this.
    . $PROGPATH/.kickstartconfig
fi



_usage() {
    echo -e $COLOR_NC "Usage: $0 [<command>]

    COMMANDS:

        $0 [dev|<command>]
            Run kick <command> and start bash inside container (development mode)

        $0 run <command>
            Execute kick <command> and return (unit-testing)

        $0 build
            Build a standalone container

        $0 test
            Execute kick test

        $0 --ci-build
            Build the service and push to gitlab registry (gitlab_ci_runner)

    EXAMPLES

        $0              Just start a shell inside the container (default development usage)
        $0 run test     Execute commands defined in section 'test' of .kick.yml

    ARGUMENTS
        -t <tagName> --tag=<tagname>   Run container with this tag (development)
        -u --unflavored                Run the container whithout running any scripts (develpment)
        --upgrade                      Search / Install new kickstart version

    "
    exit 1
}


_print_header() {
    echo -e $COLOR_WHITE "

 infracamp's
   ▄█   ▄█▄  ▄█   ▄████████    ▄█   ▄█▄    ▄████████     ███        ▄████████    ▄████████     ███
  ███ ▄███▀ ███  ███    ███   ███ ▄███▀   ███    ███ ▀█████████▄   ███    ███   ███    ███ ▀█████████▄
  ███▐██▀   ███▌ ███    █▀    ███▐██▀     ███    █▀     ▀███▀▀██   ███    ███   ███    ███    ▀███▀▀██
 ▄█████▀    ███▌ ███         ▄█████▀      ███            ███   ▀   ███    ███  ▄███▄▄▄▄██▀     ███   ▀
▀▀█████▄    ███▌ ███        ▀▀█████▄    ▀███████████     ███     ▀███████████ ▀▀███▀▀▀▀▀       ███
  ███▐██▄   ███  ███    █▄    ███▐██▄            ███     ███       ███    ███ ▀███████████     ███
  ███ ▀███▄ ███  ███    ███   ███ ▀███▄    ▄█    ███     ███       ███    ███   ███    ███     ███
  ███   ▀█▀ █▀   ████████▀    ███   ▀█▀  ▄████████▀     ▄████▀     ███    █▀    ███    ███    ▄████▀
  ▀                           ▀                                                 ███    ███
  http://infracamp.org                                                                 happy containers
  " $COLOR_YELLOW "
+-------------------------------------------------------------------------------------------------------+
| Infracamp's Kickstart - DEVELOPER MODE                                                                |
| Version: $_KICKSTART_CURRENT_VERSION
| Flavour: $USE_PIPF_VERSION (defined in 'from:'-section of .kick.yml)"



    KICKSTART_NEWEST_VERSION=`curl -s "$_KICKSTART_VERSION_URL"`
    if [ "$KICKSTART_NEWEST_VERSION" != "$_KICKSTART_CURRENT_VERSION" ]
    then
        echo "|                                                           "
        echo "| UPDATE AVAILABLE: Head Version: $KICKSTART_NEWEST_VERSION"
        echo "| To Upgrade Version: Run ./kickstart.sh --upgrade                              "
        echo "|                                                                                 "
        sleep 5
    fi;

    echo "| More information: https://github.com/infracamp/kickstart                         "
    echo "| Or ./kickstart.sh help                                                                                |"
    echo "+-------------------------------------------------------------------------------------------------------+"

}


run_shell() {
   echo -e $COLOR_CYAN;


   if [ `docker ps | grep $CONTAINER_NAME | wc -l` -gt 0 ]
   then
        echo "[kickstart.sh] Container '$CONTAINER_NAME' already running"
        echo "Starting shell... (please press enter)"
        echo "";
        docker exec -it --user user -e "DEV_TTYID=[SUB]" $CONTAINER_NAME /bin/bash
        echo -e $COLOR_CYAN;
        echo "<=== [kickstart.sh] Leaving container."
        echo -e $COLOR_NC
        exit 0;
   fi

   echo "[kickstart.s] Another container is already running!"
   docker ps
   echo ""
   read -r -p "Your choice: (i)gnore, (s)hell, (k)ill, (a)bort?:" choice
   case "$choice" in
      i|I)
        return 0;
        ;;
      s|S)
        echo "===> [kickstart.sh] Opening new shell: "
        echo -e $COLOR_NC

        docker exec -it --user user -e "DEV_TTYID=[SUB]" `docker ps | grep "/kickstart/" | cut -d" " -f1` /bin/bash

        echo -e $COLOR_CYAN;
        echo "<=== [kickstart.sh] Leaving container."
        echo -e $COLOR_NC
        exit
        ;;
      k|K)
        echo "Killing running kickstart containers..."
        docker kill `docker ps | grep "/kickstart/" | cut -d" " -f1`
        return 0;
        ;;

      *)
        echo 'Response not valid'
        exit 3;
        ;;

    esac
}


ask_user() {
    echo "";
    read -r -p "$1 (y|N)" choice
    case "$choice" in
      n|N)
        echo "Abort!";
        ;;
      y|Y)
        return 0;
        ;;

      *)
        echo 'Response not valid';;
    esac
    exit 1;
}

_ci_build() {

    echo "CI_BUILD: Building container.. (CI_* Env is preset by gitlab-ci-runner)";

    BUILD_TAG=":$CI_BUILD_NAME"
    if [ "$CI_REGISTRY" == "" ]
    then
        echo "[Error deploy]: Environment CI_REGISTRY not set"
        exit 1
    fi

    CMD="docker build --pull -t $CI_REGISTRY_IMAGE$BUILD_TAG -f ./Dockerfile ."
    echo "[Building] Running '$CMD' (MODE1)";
    eval $CMD

    echo "Logging in to: $CI_REGISTRY_USER @ $CI_REGISTRY"
    echo "$CI_REGISTRY_PASSWORD" | docker login --username $CI_REGISTRY_USER --password-stdin $CI_REGISTRY
    docker push $CI_REGISTRY_IMAGE$BUILD_TAG
    echo "Push successful..."
    exit
}



DOCKER_OPT_PARAMS=$KICKSTART_DOCKER_RUN_OPTS;
if [ -e "$HOME/.ssh" ]
then
    echo "Mounting $HOME/.ssh..."
    DOCKER_OPT_PARAMS="$DOCKER_OPT_PARAMS -v $HOME/.ssh:/home/user/.ssh";
fi

if [ -e "$HOME/.gitconfig" ]
then
    echo "Mounting $HOME/.gitconfig..."
    DOCKER_OPT_PARAMS="$DOCKER_OPT_PARAMS -v $HOME/.gitconfig:/home/user/.gitconfig";
fi

if [ -e "$PROGPATH/.env" ]
then
    echo "Adding docker environment from $PROGPATH/.env (Development only)"
    DOCKER_OPT_PARAMS="$DOCKER_OPT_PARAMS --env-file $PROGPATH/.env";
fi

# Ports to be exposed
IFS=';' read -r -a _ports <<< "$KICKSTART_PORTS"
for _port in "${_ports[@]}"
do
    DOCKER_OPT_PARAMS="$DOCKER_OPT_PARAMS -p $_port"
done

run_container() {
    echo -e $COLOR_GREEN"Loading container '$USE_PIPF_VERSION'..."
    docker pull "$USE_PIPF_VERSION"

	if [ "$KICKSTART_WIN_PATH" != "" ]
	then
		# For Windows users: Rewrite Path of bash to Windows path
		# Will work only on drive C:/
		PROGPATH="${PROGPATH/\/mnt\/c\//$KICKSTART_WIN_PATH}"
	fi

    docker rm $CONTAINER_NAME
    echo -e $COLOR_WHITE "==> [$0] STARTING CONTAINER (docker run): Running container in dev-mode..." $COLOR_NC
    docker $KICKSTART_DOCKER_OPTS run -it                                      \
        -v "$PROGPATH/:/opt/"                           \
        -e "DEV_CONTAINER_NAME=$CONTAINER_NAME"         \
        -e "DEV_TTYID=[MAIN]"                           \
        -e "DEV_UID=$UID"                               \
        -e "LINES=$LINES"                               \
        -e "COLUMNS=$COLUMNS"                           \
        -e "TERM=$TERM"                                 \
        -e "DEV_MODE=1"                                 \
        $DOCKER_OPT_PARAMS                              \
        --name $CONTAINER_NAME                          \
        $USE_PIPF_VERSION $ARGUMENT

    status=$?
    if [[ $status -ne 0 ]]
    then
        echo -e $COLOR_RED
        echo "[kickstart.sh][FAIL]: Container startup failed."
        echo -e $COLOR_NC
        exit $status
    fi;
    echo -e $COLOR_WHITE "<== [kickstart.sh] CONTAINER SHUTDOWN"
    echo -e $COLOR_RED "    Kickstart Exit - Goodbye" $COLOR_NC
    exit 0;
}


if [ ! -f "$PROGPATH/.kick.yml" ]
then
    echo -e $COLOR_RED "[ERR] Missing $PROGPATH/.kick.yml file." $COLOR_NC
    ask_user "Do you want to create a new .kick.yml-file?"
    echo "# Kickstart container config file - see https://gitub.com/c7lab/kickstart" > $PROGPATH/.kick.yml
    echo "# Run ./kickstart.sh to start a development-container for this project" >> $PROGPATH/.kick.yml
    echo "version: 1" >> $PROGPATH/.kick.yml
    echo 'from: "infracamp/kickstart-flavor-gaia"' >> $PROGPATH/.kick.yml
    echo "File created. See $_KICKSTART_DOC_URL for more information";
    echo ""
    sleep 2
fi



# Parse .kick.yml for line from: "docker/container:version"
USE_PIPF_VERSION=`cat $PROGPATH/.kick.yml | sed -n 's/from\: "\(.\+\)\"/\1/p'`

if [ "$USE_PIPF_VERSION" == "" ]
then
    echo -e $COLOR_RED "[ERR] .kick.yml file does not include 'from:' - directive." $COLOR_NC
    exit 2
fi;


# Parse the command parameters
ARGUMENT="";
while [ "$#" -gt 0 ]; do
  case "$1" in
    -t) USE_PIPF_VERSION="-t $2"; shift 2;;
    --tag=*) USE_PIPF_VERSION="-t ${1#*=}"; shift 1;;

    --upgrade)
        echo "Checking for updates from $_KICKSTART_UPGRADE_URL..."
        curl "$_KICKSTART_RELEASE_NOTES_URL"

        ask_user "Do you want to upgrade?"

        echo "Writing to $0..."
        curl "$_KICKSTART_UPGRADE_URL" -o "$0"
        echo "Done"
        echo "Calling on update trigger: $0 --on-after-update"
        $0 --on-after-upgrade
        echo -e "$COLOR_GREEN[kickstart.sh] Upgrade successful.$COLOR_NC"
        exit 0;;

    --on-after-upgrade)
        exit 0;;

    --skel)
        ask_user "Do you want to overwrite existing files with skeleton?"
        curl https://codeload.github.com/infracamp/kickstart-skel/tar.gz/master | tar -xzv --strip-components=2 kickstart-skel-master/$2/ -C ./
        exit 0;;

    --ci-build)
        _ci_build $2 $3
        exit0;;

    -h|--help)
        _usage
        exit 0;;

    --tag) echo "$1 requires an argument" >&2; exit 1;;

    -*) echo "unknown option: $1" >&2; exit 1;;

    *)  break;

  esac
done

ARGUMENT=$@;
_print_header
if [ `docker ps | grep "/kickstart/" | wc -l` -gt 0 ]
then
    run_shell
fi;
run_container