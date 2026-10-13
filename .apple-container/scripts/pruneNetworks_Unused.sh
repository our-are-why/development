#!/bin/sh

# Delete networks that no container is connected to. The default network
# stays.
#
# Usage: pruneNetworks_Unused.sh
#
# The caller guarantees:
#   - the Mac runs macOS 26 or later, which `container network` needs

set -eu

echo "== Networks no container is connected to"
container network prune
