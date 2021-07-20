#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run $(basename "$0") as root"
  exit 1
fi

DIR="$(cd $(dirname "$0") && pwd)"

: "${CHROMIUM_IMG:=${HOME}/pi-images/chromiumos_image_r89r1-rpi4b.img}"
: "${DEVICE:=/dev/sda}"

if [ ! -f "$CHROMIUM_IMG" ]; then
  echo "File ${CHROMIUM_IMG} does not exist"
  exit 1
fi

if [ ! -e "${DEVICE}1" ]; then
  echo "Device ${DEVICE} not found"
  exit 1
fi

umount "${DEVICE}"?* &> /dev/null

set -e

IMG_SIZE="$(stat -c %s "$CHROMIUM_IMG" | numfmt --to iec-i --suffix B)"

echo "Installing Chromium OS on ${DEVICE} (${IMG_SIZE})..."
dd if="$CHROMIUM_IMG" of="$DEVICE" bs=1M conv=fsync status=progress
sync
