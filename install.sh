#!/bin/bash
set -e

REPO="antonjk/bash-cprintf"
INSTALL_DIR="/usr/local/share/cprintf"
BIN_DIR="/usr/local/bin"

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
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r * "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/cprintf"

# Create symlink
sudo ln -sf "$INSTALL_DIR/cprintf" "$BIN_DIR/cprintf"

# Cleanup
rm -rf "$TEMP_DIR"

echo "bash-cprintf installed successfully!"
echo "Usage: cprintf '<fg:red>Hello</fg> <b>World</b>'"

