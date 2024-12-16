#!/bin/bash

# Define variables
URL="https://huggingface.co/Doubiiu/ToonCrafter/resolve/main/model.ckpt"
DEST_DIR="checkpoints/tooncrafter_512_interp_v1"
DEST_FILE="model.ckpt"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Download the file using wget
wget -O "$DEST_DIR/$DEST_FILE" "$URL"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Download completed and file saved to $DEST_DIR/$DEST_FILE"
else
  echo "Failed to download the file. Please check the URL or your internet connection."
  exit 1
fi
