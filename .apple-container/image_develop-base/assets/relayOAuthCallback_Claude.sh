#!/bin/sh

# Relay the OAuth callback of a Claude Code login to Claude Code inside the
# container. After you sign in, the authorization server redirects the browser
# on the Mac to http://localhost:PORT/callback with the authorization code, but
# Claude Code is listening on that port inside the container, so the page fails
# to load. Copy the URL of that failed page and pass it to this command, run in
# the container; it delivers the callback in the browser's place, and Claude
# Code then exchanges the code for tokens itself.
#
# image_develop-base installs this as /usr/local/bin/relayOAuthCallback_Claude.
#
# Usage: relayOAuthCallback_Claude '<callback-url>'
#   callback-url is the failed page's URL as copied from the browser:
#   http://localhost:PORT/callback?code=...&state=...

set -eu

curl -fsS "$1"
echo "Done: check the terminal where Claude Code is waiting for the login"
