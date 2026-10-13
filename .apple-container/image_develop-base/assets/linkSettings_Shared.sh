#!/bin/sh

# Link this project's code-server settings to the shared ones. code-server
# keeps its data per project, extensions included (--user-data-dir in
# image_develop-base's ENTRYPOINT), while settings.json, keybindings.json and
# snippets/ link to ~/.config/code-server-user, which the projects mount from
# the same .coder-config folder. VS Code saves through the links.
#
# image_develop-base installs this in /entrypoint.d, which code-server's
# entrypoint runs at container start, before code-server starts.

set -eu

shared=/home/coder/.config/code-server-user
user=/home/coder/project/.coder-data/User

mkdir -p "$shared/snippets" "$user"
touch "$shared/settings.json" "$shared/keybindings.json"

ln -sf "$shared/settings.json" "$user/settings.json"
ln -sf "$shared/keybindings.json" "$user/keybindings.json"
ln -sfn "$shared/snippets" "$user/snippets"
