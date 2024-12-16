#!/bin/bash

# Script to install Miniconda on AWS Linux

# Exit immediately if a command exits with a non-zero status
set -e


# Define Miniconda download URL
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALLER="Miniconda3-latest-Linux-x86_64.sh"

# Download Miniconda installer
if [ ! -f "$INSTALLER" ]; then
    echo "Downloading Miniconda installer..."
    wget $MINICONDA_URL
else
    echo "Installer already downloaded. Skipping download."
fi

# Verify installer (Optional, can be skipped by commenting out the lines below)
# echo "Verifying installer integrity..."
# SHA256_SUM=$(sha256sum $INSTALLER | awk '{print $1}')
# EXPECTED_SUM="<INSERT_EXPECTED_HASH_FROM_MINICONDA_WEBSITE>"
# if [ "$SHA256_SUM" != "$EXPECTED_SUM" ]; then
#     echo "SHA256 checksum verification failed! Exiting."
#     exit 1
# fi
# echo "SHA256 checksum verified."

# Make the installer executable
chmod +x $INSTALLER

# Run the installer
./$INSTALLER -b -p $HOME/miniconda3

# Initialize Miniconda in the current shell
source $HOME/miniconda3/bin/activate

# Add Miniconda to PATH permanently
if ! grep -q "miniconda3/bin" ~/.bashrc; then
    echo "Adding Miniconda to PATH in .bashrc..."
    echo "source $HOME/miniconda3/bin/activate" >> ~/.bashrc
fi

# Reload .bashrc to apply changes
source ~/.bashrc

# Test Miniconda installation
echo "Testing Miniconda installation..."
conda --version

# Update Conda to the latest version
echo "Updating Conda to the latest version..."
conda update -n base -c defaults conda -y

# Cleanup
rm -f $INSTALLER

echo "Miniconda installation completed successfully!"
