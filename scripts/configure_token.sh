#!/bin/bash
# Skript zum Erstellen der config.yml aus config_base.yml und einem Lichess API-Token
# Verwendung: ./scripts/configure_token.sh DEIN_LICHESS_TOKEN

# Farbdefinitionen für Terminal-Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Prüfen ob Token als Parameter übergeben wurde
if [ -z "$1" ]; then
    echo -e "${RED}Fehler: Kein Token angegeben${NC}"
    echo -e "Verwendung: $0 DEIN_LICHESS_TOKEN"
    echo -e "Beispiel: $0 lip_abcdefghijklmnopqrst"
    exit 1
fi

TOKEN="$1"

# Prüfen ob config_base.yml existiert
if [ ! -f "config_base.yml" ]; then
    echo -e "${RED}Fehler: config_base.yml nicht gefunden${NC}"
    echo -e "Bitte stelle sicher, dass du dich im Hauptverzeichnis des Repositories befindest."
    exit 1
fi

# Erstellen der config.yml
echo -e "${YELLOW}Erstelle config.yml mit deinem Token...${NC}"

# Token in config_token.yml schreiben
cat > config_token.yml << EOL
token: "${TOKEN}"
EOL

# config_base.yml und config_token.yml zusammenführen
cat config_token.yml config_base.yml > config.yml

echo -e "${GREEN}config.yml erfolgreich erstellt!${NC}"
echo -e "Dein Token wurde in config_token.yml gespeichert (diese Datei ist in .gitignore ausgeschlossen)"
echo -e "Die vollständige Konfiguration wurde in config.yml gespeichert"

# Sicherheitshinweis
echo -e ""
echo -e "${YELLOW}Sicherheitshinweis:${NC}"
echo -e "Dein Token ist ein Sicherheitsschlüssel und sollte niemals in öffentlichen Repositories gespeichert werden."
echo -e "config_token.yml und config.yml sind in .gitignore aufgeführt und werden nicht zum Repository hinzugefügt."
