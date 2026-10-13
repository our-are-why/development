#!/bin/sh

# Delete stopped containers (see pruneContainers_Stopped.sh), then the images
# that the remaining containers aren't using. That includes image_develop-base
# and code-server when they're unused, so rebuild image_develop-base before
# building a project; that build downloads code-server again. To keep images,
# use pruneContainers_Stopped.sh.
#
# Build resources stay: the BuildKit builder and its cache have their own
# scripts, pruneBuilder.sh and pruneBuilderCache.sh. So do the builder and VM
# init images `container` runs on. `container image list` leaves those out,
# while `container image prune --all` would delete them, hence the loop.
#
# `container list` doesn't show `container machine` VMs, so an image a machine
# uses looks unused here and gets deleted.
#
# Usage: pruneArtifacts_Projects.sh

set -eu

"$(dirname "$0")/pruneContainers_Stopped.sh"

echo "== Images the remaining containers aren't using"
# Images of the remaining containers, rewritten to the short form `container
# image list` prints (docker.io/library/foo:1 -> foo:1). Older `container`
# versions escape slashes in the JSON.
in_use=$(container list --all --format json |
  grep -oE '"reference":"[^"]*"' |
  sed -e 's/^"reference":"//' -e 's/"$//' -e 's#\\/#/#g' \
    -e 's#^docker\.io/library/##' -e 's#^docker\.io/##')

# Containers remain but no references were read: the JSON format has changed,
# and deleting now could remove images that are in use
if [ -n "$(container list --all --quiet)" ] && [ -z "$in_use" ]; then
  echo "error: can't read image references from 'container list --format json'; not deleting images" >&2
  exit 1
fi

for image in $(container image list --quiet); do
  if printf '%s\n' "$in_use" | grep -qxF "$image"; then
    echo "  keep $image (in use)"
    continue
  fi
  container image delete "$image"
done
