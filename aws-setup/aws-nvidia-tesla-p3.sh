#!/bin/bash

# Define a marker file to track progress
MARKER_FILE="/var/log/nvidia_driver_install_step"

# Step 1: Update system and uninstall old NVIDIA drivers
if [ ! -f "$MARKER_FILE" ] || grep -q "STEP1" "$MARKER_FILE"; then
  echo "STEP1: Updating system and uninstalling old NVIDIA drivers..."
  sudo yum update -y

  # Uninstall existing NVIDIA drivers
  echo "Removing old NVIDIA drivers..."
  sudo yum remove -y 'nvidia-*'

  # Clean up leftover files
  sudo rm -rf /var/lib/nvidia /usr/share/nvidia /usr/lib/nvidia /usr/lib64/nvidia
  sudo rm -f /etc/modprobe.d/nvidia*.conf

  echo "STEP2" > "$MARKER_FILE"
  echo "Rebooting the system to apply changes..."
  sudo reboot
  exit 0
fi

# Step 2: Install required packages and disable Nouveau driver
if grep -q "STEP2" "$MARKER_FILE"; then
  echo "STEP2: Installing required packages and disabling Nouveau driver..."
  sudo yum install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r) gcc make dkms

  # Disable Nouveau driver
  echo "Disabling Nouveau driver..."
  sudo bash -c 'echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nouveau.conf'
  sudo bash -c 'echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf'
  sudo dracut --force

  echo "STEP3" > "$MARKER_FILE"
  echo "Rebooting the system to apply changes..."
  sudo reboot
  exit 0
fi

# Step 3: Add NVIDIA driver repository and install the driver
if grep -q "STEP3" "$MARKER_FILE"; then
  echo "STEP3: Adding NVIDIA driver repository and installing the driver..."
  wget https://us.download.nvidia.com/tesla/565.57.01/nvidia-driver-local-repo-amzn2023-565.57.01-1.0-1.x86_64.rpm -O nvidia-driver-local-repo.rpm
  sudo yum install -y ./nvidia-driver-local-repo.rpm
  sudo yum clean all
  sudo yum install -y nvidia-driver

  echo "STEP4" > "$MARKER_FILE"
fi

# Step 4: Verify installation
if grep -q "STEP4" "$MARKER_FILE"; then
  echo "STEP4: Verifying NVIDIA driver installation..."
  nvidia-smi
  echo "Installation complete!"
  sudo rm -f "$MARKER_FILE"  # Clean up the marker file
fi
