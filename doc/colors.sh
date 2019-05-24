#!/bin/bash

TXT_BOLD=1;TXT_INVERT=7;
TXT_FG_DEFAULT=39;TXT_FG_BLACK=30;TXT_FG_RED=31;TXT_FG_YELLOW=33;TXT_FG_BLUE=34;TXT_FG_LIGHT_GRAY=37;TXT_FG_LIGHT_GREEN=92;
TXT_BG_DEFAULT=49;TXT_BG_RED=41;TXT_BG_GREEN=42;TXT_BG_YELLOW=43;TXT_BG_LIGHTRED=101;TXT_BG_LIGHTBLUE=104;TXT_BG_LIGHTYELLOW=103

function out {
    msg=$1
    fg_color=${2:-0}
    bg_color=${3:-0}
    attr=${4:-0}

    echo -e "\e[${attr};${bg_color};${fg_color}m";
    echo -en ${msg}
    echo -e "\e[0m";

}

function out_err {
    out "$1" $TXT_BOLD $TXT_BG_LIGHTRED $TXT_FG_BLACK
}

function out_warn {
    out "$1" $TXT_BOLD $TXT_BG_LIGHTYELLOW $TXT_FG_BLACK
}

function out_ok {
    out "$1" $TXT_BOLD $TXT_BG_GREEN $TXT_FG_BLACK
}

function out_debug {

}

function out_line {
   echo "wurst"

}

out "Hello World" 41 11 1

out_err "Error Out"
out_warn "Waring Out"
out_ok "OK out"