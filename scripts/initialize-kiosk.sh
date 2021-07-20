#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run $(basename "$0") as root"
  exit
fi

set -e

DIR="$(cd $(dirname "$0") && pwd)"
source "${DIR}/env.sh"

ETC='/media/pi/ROOT-A/etc'
CHROME_CONF_FILE="${ETC}/chrome_dev.conf"
SERVICE_FILE="${ETC}/init/system-services.override"
KIOSK_CONF_FILE="${KIOSK_DIR}/config.json"

echo 'Initializing Kiosk...'

if grep -F -- '--force-kiosk-mode' "$CHROME_CONF_FILE" &> /dev/null; then
  echo "${CHROME_CONF_FILE} up-to-date"
else
  echo "Updating ${CHROME_CONF_FILE}..."
  echo '--force-kiosk-mode' >> "$CHROME_CONF_FILE"
fi

if [ -e "$SERVICE_FILE" ]; then
  echo "${SERVICE_FILE} already exits"
else
  echo "Creating ${SERVICE_FILE}..."
  echo 'start on started boot-services' > "$SERVICE_FILE"
fi

[ -e "$KIOSK_DIR" ] || mkdir -p "$KIOSK_DIR"

if [ -e "$KIOSK_CONF_FILE" ]; then
  echo "${KIOSK_CONF_FILE} already exists"
else
  echo "Creating ${KIOSK_CONF_FILE}..."
  cat > "$KIOSK_CONF_FILE" << HERE
{
  "AppId" : "kcdnoglonapgfllkihkgageoililgckl",
  "AppPath" : "${KIOSK_APP_BASENAME}",
  "Enable" : true
}
HERE
fi

echo
"${DIR}/update-kiosk.sh"
