#
# __cleanup.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 11/20/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash

detach_loopback() {
  for img in $(losetup  | grep $1 | awk '{ print $1 }' );  do
    losetup -d $img
  done

  dmsetup remove_all
}

murder_children() {
  local pids=$(jobs -pr)

  [ -n "${pids}" ] && kill $pids && sleep 5 && kill -9 $pids
}