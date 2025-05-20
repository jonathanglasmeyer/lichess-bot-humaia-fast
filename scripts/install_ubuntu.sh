#!/bin/bash
# Installation script for lichess-bot on Ubuntu Server
# Created for Maia-1400 lichess bot

echo "===== Installing lichess-bot dependencies for Ubuntu ====="

# Update package lists
sudo apt-get update

# Install Python and pip
sudo apt-get install -y python3 python3-pip python3-venv

# Install git if not already installed
sudo apt-get install -y git

# Install lc0 dependencies
sudo apt-get install -y cmake g++ build-essential libstdc++6 zlib1g-dev

# Set up Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Create necessary directories
mkdir -p engines/lc0-weights
mkdir -p engines/opening-books
mkdir -p logs

echo "===== Installing Leela Chess Zero (lc0) ====="

# Install lc0 from Ubuntu repository if available
if apt-cache show lc0 &>/dev/null; then
    sudo apt-get install -y lc0
else
    echo "lc0 not found in repositories, installing from source..."
    
    # Clone lc0 repository
    git clone --recurse-submodules https://github.com/LeelaChessZero/lc0.git
    cd lc0
    
    # Build lc0
    ./build.sh
    
    # Copy the binary to a location in PATH
    sudo cp build/release/lc0 /usr/local/bin/
    
    # Return to the original directory
    cd ..
fi

echo "===== Verifying Maia neural network weights ====="

# Check if weights exist in the repository
if [ ! -f "engines/lc0-weights/maia-1400.pb.gz" ]; then
    echo "WARNUNG: Maia-1400 Gewichtsdatei nicht gefunden!"
    echo "Bitte stelle sicher, dass die Datei 'engines/lc0-weights/maia-1400.pb.gz' existiert."
    echo "Das Repository sollte diese Datei bereits enthalten."
else
    echo "Maia-1400 Gewichtsdatei gefunden. ✓"
fi

echo "===== Installation completed ====="
echo "To start the bot, run: ./scripts/start_bot.sh"
