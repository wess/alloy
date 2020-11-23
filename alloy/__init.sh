#
# __images.sh
# Ancilla
# 
# Author: Wess (wess@frenzylabs.com)
# Created: 11/19/2020
# 
# Copywrite (c) 2020 FrenzyLabs, LLC.
#

#!/bin/env bash

download() {
  if [ -r "${FILE_DOWNLOAD}" ]; then
    rm "${FILE_DOWNLOAD}"
  fi

  if ! [ -r "${IMG_FILE}" ]; then
    echo "Downloading Raspberry pi OS image..." | status

    curl -C - -Lo "${FILE_DOWNLOAD}" "${DOWNLOAD_URL}"
    mv "${FILE_DOWNLOAD}" "${ZIP_FILE}"

    echo "Download complete" | success
    
    echo "Decompressing image..." | status

    unzip -p "${ZIP_FILE}" > "${IMG_FILE}"

    echo "Decompression complete." | success
  fi
}

decompress() {
  if [ -r "${ZIP_FILE}" ]; then
    unzip -p "${ZIP_FILE}" > "${IMG_FILE}"
  fi
}

cleanup() {
  if [ -r "${ZIP_FILE}" ]; then
    rm "${ZIP_FILE}"
  fi

  if [ -r "${FILE_DOWNLOAD}" ]; then
    rm "${FILE_DOWNLOAD}"
  fi
}

git_ignore() {
  if ! [ -r "${IGNORE_FILE}" ]; then
    echo "Generating .gitignore file..." | status

    touch "${IGNORE_FILE}"
    
    echo "*~" >> "${IGNORE_FILE}"
    echo ".fuse_hidden*" >> "${IGNORE_FILE}"
    echo ".directory" >> "${IGNORE_FILE}"
    echo ".Trash-*" >> "${IGNORE_FILE}"
    echo ".nfs*" >> "${IGNORE_FILE}"
    echo ".DS_Store" >> "${IGNORE_FILE}"
    echo ".AppleDouble" >> "${IGNORE_FILE}"
    echo ".LSOverride" >> "${IGNORE_FILE}"
    echo "Icon" >> "${IGNORE_FILE}"
    echo "._*" >> "${IGNORE_FILE}"
    echo ".DocumentRevisions-V100" >> "${IGNORE_FILE}"
    echo ".fseventsd" >> "${IGNORE_FILE}"
    echo ".Spotlight-V100" >> "${IGNORE_FILE}"
    echo ".TemporaryItems" >> "${IGNORE_FILE}"
    echo ".Trashes" >> "${IGNORE_FILE}"
    echo ".VolumeIcon.icns" >> "${IGNORE_FILE}"
    echo ".com.apple.timemachine.donotpresent" >> "${IGNORE_FILE}"
    echo ".AppleDB" >> "${IGNORE_FILE}"
    echo ".AppleDesktop" >> "${IGNORE_FILE}"
    echo "Network Trash Folder" >> "${IGNORE_FILE}"
    echo "Temporary Items" >> "${IGNORE_FILE}"
    echo ".apdisk" >> "${IGNORE_FILE}"
    echo "Thumbs.db" >> "${IGNORE_FILE}"
    echo "Thumbs.db:encryptable" >> "${IGNORE_FILE}"
    echo "ehthumbs.db" >> "${IGNORE_FILE}"
    echo "ehthumbs_vista.db" >> "${IGNORE_FILE}"
    echo "*.stackdump" >> "${IGNORE_FILE}"
    echo "[Dd]esktop.ini" >> "${IGNORE_FILE}"
    echo "\$RECYCLE.BIN/" >> "${IGNORE_FILE}"
    echo "*.cab" >> "${IGNORE_FILE}"
    echo "*.msi" >> "${IGNORE_FILE}"
    echo "*.msix" >> "${IGNORE_FILE}"
    echo "*.msm" >> "${IGNORE_FILE}"
    echo "*.msp" >> "${IGNORE_FILE}"
    echo "*.lnk" >> "${IGNORE_FILE}"

    echo ".gitignore file generated." | success
  fi
}

setup_dir() {
  echo "Setting up directories..." | status
  for i in ${!DIRS[@]}; do
    DIR=${DIRS[$i]}
    KEEP="${DIR}/.gitkeep"

    if ! [ -r "${DIR}" ]; then
      mkdir -p "${DIR}"
      echo "Creating directory $(basename "${DIR}")" | success
    fi
  done
  
   echo "Directory setup complete." | success
}

init() {
  echo "Setting up environment..." | status
  setup_dir
  git_ignore
  download
  decompress
  cleanup
}
