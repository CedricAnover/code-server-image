#!/bin/bash

set -e

CODER_VERSION=$1
CODER_URL="https://github.com/coder/coder/releases/download/v$CODER_VERSION/coder_${CODER_VERSION}_linux_amd64.deb"
CODER_FILE="coder_${CODER_VERSION}_linux_amd64.deb"

echo "Downloading $CODER_URL..."
wget -O "$CODER_FILE" "$CODER_URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download the file. Exiting."
    exit 1
fi

# Install the .deb file
echo "Installing $CODER_FILE..."
sudo dpkg -i "$CODER_FILE"

# Fix any dependency issues
echo "Fixing dependencies..."
sudo apt-get install -f

# Clean up
echo "Cleaning up..."
rm "$CODER_FILE"

echo "Installation completed successfully."
