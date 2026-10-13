#!/bin/sh

# Delete stopped containers, except the BuildKit builder container ("buildkit")
# so its build cache survives. Images stay; pruneArtifacts_Projects.sh deletes
# unused images as well.
#
# Usage: pruneContainers_Stopped.sh

set -eu

builder_container=buildkit

# `container prune` would delete a stopped builder too, hence the loop
echo "== Stopped containers (keeping $builder_container)"
running=$(container list --quiet)
for id in $(container list --all --quiet); do
  if [ "$id" = "$builder_container" ] || printf '%s\n' "$running" | grep -qxF "$id"; then
    continue
  fi
  container delete "$id"
done
