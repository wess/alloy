#
# __yaml.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 11/20/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash

parse_yaml() {
  if ! command -v "niet" &> /dev/null; then
    apt install -y python3-pip && pip install niet
  fi

  cat ${1} | niet -f eval .   
}