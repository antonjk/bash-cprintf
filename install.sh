#!/bin/bash
set -e

REPO="antonjk/bash-cprintf"
INSTALL_DIR="/usr/local/share/cprintf"
BIN_DIR="/usr/local/bin"
MAN_DIR="/usr/share/man/man1"

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

# Install man page
if [ -f "doc/cprintf.1" ]; then
    sudo mkdir -p "$MAN_DIR"
    sudo cp doc/cprintf.1 "$MAN_DIR/cprintf.1"
    sudo chmod 644 "$MAN_DIR/cprintf.1"
    echo "Man page installed to $MAN_DIR/cprintf.1"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo "bash-cprintf installed successfully!"
echo "Usage: cprintf '<fg:red>Hello</fg> <b>World</b>'"
echo "See 'man cprintf' for complete documentation"

