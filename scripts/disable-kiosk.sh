#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run $(basename "$0") as root"
  exit 1
fi

set -e

DIR="$(cd $(dirname "$0") && pwd)"
source "${DIR}/env.sh"

# The device needs to be mounted before we can use it
trap unmount-device EXIT
mount-device

echo 'Disabling kiosk mode...'

if grep -F -- '--force-kiosk-mode' "$CHROME_CONF_FILE" &> /dev/null; then
  echo "Updating ${CHROME_CONF_FILE}..."
  sed -i '/--force-kiosk-mode/d' "$CHROME_CONF_FILE"
else
  echo "${CHROME_CONF_FILE} up-to-date"
fi
