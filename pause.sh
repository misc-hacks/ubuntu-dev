#!/bin/bash

# magic_pause waits for stopping magics.
function magic_pause {
  while true; do
    sleep 3
    if [ -e /tmp/__magic_exit_1 ]; then
      rm -rf /tmp/__magic_*
      echo "container stopping with exit code 1..."
      exit 1
    elif [ -e /tmp/__magic_exit_0 ]; then
      rm -rf /tmp/__magic_*
      echo "container stopping with exit code 0..."
      exit 0
    fi
  done
}
