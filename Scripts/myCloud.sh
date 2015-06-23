#!/bin/bash
# ---------------------------------------------------------------------------
# my_cloud - Store and retrieve files on a remote server

# Copyright 2013, William Shotts <bshotts@users.sourceforge.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.

# Prerequsites:
# my_cloud expect that remote hosts have a directory named 'cloud'
# within the user's home directory. 

# Usage:
# my_cloud -h|--help
# my_cloud -c|--cloud user@host -l|--list
# my_cloud -c|--cloud user@host -g|--get file...
# my_cloud -c|--cloud user@host -p|--put file...
# my_cloud -c|--cloud user@host -d|--delete file...

# Revision history:
# 2013-12-30  Created by new_script ver. 3.0
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}
VERSION="0.1"

clean_up() { # Perform pre-exit housekeeping
  return
}

error_exit() { # Handle fatal error
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  clean_up
  exit 1
}

graceful_exit() { # Normal exit
  clean_up
  exit
}

signal_exit() { # Handle trapped signals
  case $1 in
    INT)    error_exit "Program interrupted by user" ;;
    TERM)   echo -e "\nnew_script: Program terminated" >&2 ; graceful_exit ;;
    *)      error_exit "new_script: Terminating on unknown signal" ;;
  esac
}

usage() {
  echo -e "Usage: $PROGNAME [-h ]|[-c user@host [-l]|[-g|-p|-d file...]]"
}

help_message() {
  cat <<- _EOF_
  $PROGNAME ver. $VERSION
  Store and retrieve files on a remote server

  $(usage)

  Options:
  -h, --help              Display this help message and exit.
  -c, --cloud user@host   Remote server login, where 'user@host' 
                          is the login name and host.
  -l, --list              List files on remote server
  -g, --get file...       Get file(s) from remote server
  -p, --put file...       Put file(s) on remote server
  -d, --delete file...    Delete file(s) on remote server

_EOF_
  return
}

set_mode() {
  if [[ $mode == "empty" ]]; then
    mode=$1
  else
    error_exit "Only one mode (-l, -g, -p, -d) is allowed."
  fi
}

# Trap signals
trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT

# Parse command-line
mode=empty
file_list=
while [[ -n $1 ]]; do
  case $1 in
    -h | --help)    help_message; graceful_exit ;;
    -c | --cloud)   shift; user_host="$1" ;;
    -l | --list)    set_mode list ;;
    -g | --get)     set_mode get ;;
    -p | --put)     set_mode put ;;
    -d | --delete)  set_mode delete ;;
    -* | --*)       usage; error_exit "Unknown option $1" ;;
    *)  # Process arguments
        case $mode in
          get) file_list="$file_list $user_host:cloud/$1"
            ;;
          put) [[ -f "$1" ]] && file_list="$file_list $1"
            ;;
          delete) file_list="$file_list $1"
            ;;
        esac
        ;;
  esac
  shift
done

# Main logic

# quit if no remote host is specified
[[ -n "$user_host" ]] || error_exit "You must specify a user@host (-c)."
host=${user_host##*@}

case $mode in
  list )  echo -e "\n### Files on host ${host}: ###"
    ssh $user_host 'ls -lA cloud'
    ;;
  get ) echo -e "\n### Getting $file_list from host $host ###"
    scp -p $file_list .
    ;;
  put ) echo -e "\n### Putting $file_list on host $host ###"
    scp -p $file_list $user_host:cloud
    ;;
  delete ) echo -e "\n### Deleting $file_list from host $host ###"
    ssh $user_host "cd cloud && rm $file_list"
    ;;
esac
graceful_exit
