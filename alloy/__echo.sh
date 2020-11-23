#
# __print.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 11/20/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash

COLOR_RESET="\033[0m"
DARK_GRAY="\033[1;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
CHECK_MARK="✔"
CROSS_MARK="✖"
ARROW_MARK="→"
WARNING_MARK="⚠"
INFO_MARK="ℹ"
CIRCLE_MARK="◯"

__colorize() {
  local color=$1
  local text=$@

  echo -e "${color}${text}${COLOR_RESET}"
}

darkgray() {
  while read data; do
    __colorize ${DARK_GRAY} ${data}
  done
}

red() {
  while read data; do
    __colorize ${RED} ${data}
  done
}

green() {
  while read data; do
    __colorize ${GREEN} ${data}
  done
}

yellow() {
  while read data; do
    __colorize ${YELLOW} ${data}
  done
}

blue() {
  while read data; do
    __colorize ${BLUE} ${data}
  done
}

purple() {
  while read data; do
    __colorize ${PURPLE} ${data}
  done
}

cyan() {
  while read data; do
    __colorize ${CYAN} ${data}
  done
}

success() {
  while read data; do
    echo -e "${GREEN}${CHECK_MARK} $data"
  done
}

warning() {
  while read data; do
    echo -e "${YELLOW}${WARNING_MARK} $data"
  done
}

error() {
  while read data; do
    echo -e "${RED}${CROSS_MARK} $data"
  done
}

muted() {
  while read data; do
    echo -e "${DARK_GRAY}${CIRCLE_MARK} $data"
  done
}

info() {
  while read data; do
    echo -e "${CYAN}${INFO_MARK} $data"
  done
}

status() {
  while read data; do
    echo -e "${COLOR_RESET}${ARROW_MARK} $data"
  done
}