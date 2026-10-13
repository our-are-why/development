#!/bin/sh

# Build the shared dev image that projects build FROM, as "image_develop-base".
#
# Usage: buildImage.sh

set -eu

# Build from this directory, wherever this script is called from
cd "$(dirname "$0")"

# --no-cache so Claude Code and agy are reinstalled at their latest versions.
# Rebuild projects afterwards to pick up the new base.
container build --no-cache -t image_develop-base -f ./Containerfile .
