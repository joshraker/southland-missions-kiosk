#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run $(basename "$0") as root"
  exit 1
fi

set -e

DIR="$(cd $(dirname "$0") && pwd)"
source "${DIR}/env.sh"

: "${OS_IMG:=/root/pi-images/chromium-os-shrunk.img}"

if [ ! -f "$OS_IMG" ]; then
  echo "File ${OS_IMG} does not exist"
  exit 1
fi

if [ ! -e "${DEVICE}1" ]; then
  echo "Device ${DEVICE} not found"
  exit 1
fi

unmount-device

IMG_SIZE="$(stat -c %s "$OS_IMG" | numfmt --to iec-i --suffix B)"

echo "Writing ${OS_IMG} to ${DEVICE} (${IMG_SIZE})..."
dd if="$OS_IMG" of="$DEVICE" bs=1M conv=fsync status=progress
sync

echo
"${DIR}/initialize-kiosk.sh"

