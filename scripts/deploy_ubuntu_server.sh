#!/bin/bash
# Deployment script for running lichess-bot as a background service on Ubuntu

# Change to the project directory if not already there
cd "$(dirname "$0")/.." || exit

echo "===== Setting up lichess-bot as a background service ====="

# Create systemd service file
SYSTEMD_FILE="/etc/systemd/system/lichess-bot.service"
BOT_PATH="$(pwd)"
USER="$(whoami)"

# Create service file content
sudo bash -c "cat > $SYSTEMD_FILE" << EOL
[Unit]
Description=Lichess Bot with Maia-1400
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$BOT_PATH
ExecStart=/bin/bash -c "source $BOT_PATH/venv_new/bin/activate && python3 $BOT_PATH/lichess-bot.py"
Restart=always
RestartSec=10
StandardOutput=append:$BOT_PATH/logs/lichess-bot.log
StandardError=append:$BOT_PATH/logs/lichess-bot-error.log

[Install]
WantedBy=multi-user.target
EOL

# Create logs directory if it doesn't exist
mkdir -p logs

# Reload systemd
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable lichess-bot
sudo systemctl start lichess-bot

echo "===== lichess-bot service started ====="
echo "Check status with: sudo systemctl status lichess-bot"
echo "View logs with: tail -f logs/lichess-bot.log"
echo "Stop service with: sudo systemctl stop lichess-bot"
