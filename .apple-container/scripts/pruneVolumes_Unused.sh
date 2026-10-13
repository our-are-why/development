#!/bin/sh

# Delete volumes that no container uses, running or stopped. A volume keeps its
# data after its container is gone, and this deletes that data too. Projects
# start their containers with --rm, so a project's volumes count as unused
# whenever the project isn't running.
#
# Usage: pruneVolumes_Unused.sh

set -eu

echo "== Volumes no container uses"
container volume prune
