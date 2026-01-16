#!/bin/bash
set -e

REPO="antonjk/bash-cprintf"
echo "Installing bash-cprintf..."

# Download latest release
LATEST_URL="https://github.com/$REPO/archive/refs/heads/main.zip"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
echo "${LATEST_URL} -> ${TEMP_DIR}"

curl -sSL "$LATEST_URL" -o cprintf.zip
unzip -q cprintf.zip
cd bash-cprintf-main

# Install files
sudo make install
