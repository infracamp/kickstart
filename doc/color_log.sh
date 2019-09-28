#!/bin/bash

############################# LOGGING SYSTEM #########################
cols=$(tput cols)

function log () {
  last_log=$1
  printf "$(tput sc; tput bold)%.${cols}s" "$last_log";
}

function debug() {
  last_log=$1
  printf "$(tput sc; tput dim)%.${cols}s" "$last_log";
}

function ok() {
  printf "$(tput rc; tput setaf 0; tput bold)%.${cols}s %s" "$last_log" "$1"
  printf "$(tput rc)\033[$(expr $cols - 10)G$(tput bold)$(tput setaf 0)[$(tput setaf 2) %4s $(tput setaf 0)]$(tput sgr0)\n" "OK";
}

function warn() {
  printf "$(tput rc; tput setaf 3; tput bold)%.${cols}s %s" "$last_log" "$1"
  printf "$(tput rc)\033[$(expr $cols - 10)G$(tput bold)$(tput setaf 0)[$(tput setaf 3) %4s $(tput setaf 0)]$(tput sgr0)\n" "WARN";
}

function err() {
  printf "$(tput rc; tput setaf 1; tput bold)%.${cols}s %s" "$last_log" "$1"
  local msg=$1; printf "$(tput rc)\033[$(expr $cols - 10)G$(tput bold)$(tput setaf 0)[$(tput setaf 1) %4s $(tput setaf 0)]$(tput sgr0)\n" "ERR";
}
########################## END LOGGING SYSTEM #######################


log helloschnello
 sleep 1
err wurst


debug "lade etwas böses"
sleep 1
err "Not found"


debug "lade etwas böses"
sleep 1
warn "Not found"

log "lade etwas böses"
sleep 1
ok