#!/bin/bash
# Installation script for lichess-bot on macOS
# Created for Maia-1400 lichess bot

echo "===== Installing lichess-bot dependencies for macOS ====="

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Python if not already installed
if ! command -v python3 &> /dev/null; then
    echo "Installing Python..."
    brew install python
fi

# Install lc0 using Homebrew
echo "Installing Leela Chess Zero (lc0)..."
brew install lc0

# Set up Python virtual environment
python3 -m venv venv_new
source venv_new/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Create necessary directories
mkdir -p engines/lc0-weights
mkdir -p engines/opening-books
mkdir -p logs

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
echo "To start the bot, run: ./scripts/start_bot_macos.sh"
