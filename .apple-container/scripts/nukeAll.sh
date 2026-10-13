#!/bin/sh

# Delete Apple `container` resources: containers (running ones too, and the
# builder with its build cache), `container machine` VMs with their disks,
# images (including the builder and VM init images `container` runs on),
# volumes, and networks other than the default. Files a machine reached
# through its mount of your Mac home folder stay.
#
# `container` itself keeps working: its service, kernel and config.toml stay,
# and it downloads the images it runs on again when it next needs them.
# Rebuild image_develop-base and the projects afterwards.
#
# Usage: nukeAll.sh
#
# The caller guarantees:
#   - the Mac runs macOS 26 or later, which `container network` needs

set -eu

echo "== Containers, including running ones and the builder"
container delete --all --force

# `container delete --all` skips machines, and `container machine delete`
# takes one at a time; it stops a running machine first.
echo "== Machines"
for machine in $(container machine list --quiet); do
  container machine delete "$machine"
done

# With no containers or machines left, this removes the builder and VM init
# images too
echo "== Images"
container image prune --all

echo "== Volumes"
container volume prune

echo "== Networks other than the default"
container network prune
