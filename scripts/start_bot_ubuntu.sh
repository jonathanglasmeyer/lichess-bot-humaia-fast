#!/bin/bash
# Start script for lichess-bot on Ubuntu Server

# Change to the project directory if not already there
cd "$(dirname "$0")/.." || exit

# Activate virtual environment
source venv/bin/activate

# Set configuration file based on environment
CONFIG_FILE="config.yml"

# Check if lc0 is installed and in PATH
if ! command -v lc0 &> /dev/null; then
    echo "Error: lc0 is not installed or not in PATH"
    echo "Please run the install script first: ./scripts/install_ubuntu.sh"
    exit 1
fi

# Check if Maia weights exist
if [ ! -f "engines/lc0-weights/maia-1400.pb.gz" ]; then
    echo "Error: Maia-1400 weights not found"
    echo "Please run the install script first: ./scripts/install_ubuntu.sh"
    exit 1
fi

# Start the bot
echo "Starting lichess-bot with Maia-1400..."
python lichess-bot.py

# If the bot crashes, this will execute
echo "Bot has stopped. Check logs for details."
