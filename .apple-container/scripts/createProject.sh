#!/bin/sh

# Create a new project as a copy of template_project.
#
# Usage: createProject.sh <project-dir>
#
# The caller guarantees:
#   - project-dir doesn't exist yet; this script creates it
#   - project-dir is inside the folder that holds .apple-container, which the
#     generated startContainer.sh relies on
#   - project-dir's name, lowercased, is a valid image name (letters and
#     digits, joined by . _ or -), since the generated scripts default the
#     image name to it

set -eu

project_dir=$1
name=$(basename "$project_dir" | tr '[:upper:]' '[:lower:]')
template_dir="$(cd "$(dirname "$0")/../template_project" && pwd)"

mkdir -p "$(dirname "$project_dir")"
cp -R "$template_dir" "$project_dir"

echo "Created $project_dir (image name: $name)"
