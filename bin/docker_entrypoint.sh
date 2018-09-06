#!/bin/bash

set -exuo pipefail

if [ $# -eq 0 ]; then
  exec su - sumokoin -c "/sumokoin/bin/sumokoind --rpc-bind-ip 0.0.0.0"
else
  exec "$@"
fi
