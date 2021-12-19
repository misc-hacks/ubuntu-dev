#!/bin/bash

# Set timezone
if [ -n "${TIMEZONE}" ]; then
  echo "setting TZ to ${TIMEZONE}"
  sed -i -e "s|^export TZ=.*|export TZ=${TIMEZONE}|" /home/dev/.zshrc
fi

# Set sudo password
if [ -n "${SUDO_PASSWORD_HASH}" ]; then
  echo "setting sudo password hash (only if not set yet)"
  sed -i "s|^dev:[\!\*]:|dev:${SUDO_PASSWORD_HASH}:|" /etc/shadow
fi

# Load keys from PUBLIC_KEY_DIR
if [ -d ${PUBLIC_KEY_DIR} ]; then
  cd ${PUBLIC_KEY_DIR}
  mkdir -p /home/dev/.ssh
  cat * > /home/dev/.ssh/authorized_keys
  chown -R dev:dev /home/dev/.ssh
fi

# Start ssh service
service ssh start

# Pause the init process
source /pause.sh
magic_pause
