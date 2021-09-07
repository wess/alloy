#
# __helpers.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 11/20/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash

pause() {
  read -p "$*"
}

quit() {
  echo >&2 "$@"
  exit 1
}

define(){ IFS='\n' read -r -d '' ${1} || true; }