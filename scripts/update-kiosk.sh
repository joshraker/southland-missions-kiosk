#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run $(basename "$0") as root"
  exit
fi

APP_DIR=$(cd $(dirname "$0")/.. && pwd)

source "${APP_DIR}/scripts/env.sh"

echo 'Updating kiosk app...'
rm -rf "$KIOSK_APP_DIR"
cp -r "$APP_DIR" "$KIOSK_APP_DIR"
rm -rf "${KIOSK_APP_DIR}/scripts" "${KIOSK_APP_DIR}/.git"
