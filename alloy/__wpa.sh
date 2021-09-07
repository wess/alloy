#
# __wifi.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 12/14/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash


_move_wpa_config() {
  echo "Copying wpa_supplicant.conf to image..." | status
  `cp $WPA_CONFIG $WPA_FILE`
}

setup_wpa() {
  
  if [ "$MANIFEST_ENABLE_WPA" != "yes" ]; then
    return 0
  fi

  echo "WPA is enabled" | success

  echo "Checking for wpa_supplicant.conf in configs..." | status


  if [[ -f "${WPA_CONFIG}" ]]; then
    _move_wpa_config
  else
    echo "WPA is enabled, but wpa_supplicant.conf not found in configs folder" | error
    exit -1
  fi
}
