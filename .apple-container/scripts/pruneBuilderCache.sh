#!/bin/sh

# Clear the BuildKit build cache but keep the builder container ("buildkit").
# The cache lives on the builder's own disk, so a stopped builder still holds
# it: this starts the builder for the prune and stops it again afterwards.
# For a full reset that deletes the builder too, use pruneBuilder.sh.
#
# Usage: pruneBuilderCache.sh

set -eu

builder_container=buildkit

containers=$(container list --all --quiet)
if ! printf '%s\n' "$containers" | grep -qxF "$builder_container"; then
  echo "No builder container, so there's no build cache to clear"
  exit 0
fi

running=$(container list --quiet)
if ! printf '%s\n' "$running" | grep -qxF "$builder_container"; then
  echo "== Starting the builder to reach its cache"
  container builder start
  # Stop it again on the way out, including when the prune fails
  trap 'echo "== Stopping the builder again"; container builder stop' EXIT
fi

# The builder image is moby/buildkit, so buildctl is there and talks to the
# builder's buildkitd on its default socket. --all includes the internal and
# frontend records a plain prune leaves behind.
echo "== Pruning the build cache"
container exec "$builder_container" buildctl prune --all
