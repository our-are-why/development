#!/bin/sh

# Delete the BuildKit builder container ("buildkit") along with its build cache
# and state. pruneArtifacts_Projects.sh keeps the builder; this is the full
# reset.
#
# The next `container build` creates a fresh builder with an empty cache.
#
# Usage: pruneBuilder.sh

set -eu

echo "== Deleting the builder container and its build cache"
# Stops the builder first if it's running, and succeeds if there's no builder
container builder delete --force
