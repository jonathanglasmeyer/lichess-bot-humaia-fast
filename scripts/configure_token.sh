#!/bin/bash
# Skript zum Erstellen der config.yml aus config_base.yml und einem Lichess API-Token
# Automatische Erkennung des lc0-Pfads für verschiedene Plattformen
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

# Automatische Erkennung des lc0-Pfads
echo -e "${YELLOW}Suche nach lc0-Installation...${NC}"
LC0_PATH=""

# Verschiedene mögliche Pfade prüfen
POSSIBLE_PATHS=(
    # System-Installationspfade
    "/usr/bin"
    "/usr/local/bin"
    "/opt/homebrew/bin"
    "/usr/games"
    # Aus Quellcode gebaute lc0-Versionen
    "$(pwd)/lc0/build/release"
    "/root/lichess-bot/lc0/build/release"
    "$HOME/lichess-bot/lc0/build/release"
)

for path in "${POSSIBLE_PATHS[@]}"; do
    if [ -f "$path/lc0" ]; then
        LC0_PATH="$path"
        echo -e "${GREEN}lc0 gefunden in: $LC0_PATH${NC}"
        break
    fi
done

# Wenn lc0 nicht gefunden wurde, nach which suchen
if [ -z "$LC0_PATH" ]; then
    LC0_WHICH=$(which lc0 2>/dev/null)
    if [ -n "$LC0_WHICH" ]; then
        LC0_PATH=$(dirname "$LC0_WHICH")
        echo -e "${GREEN}lc0 gefunden in: $LC0_PATH${NC}"
    fi
fi

# Wenn immer noch nicht gefunden, Benutzer fragen
if [ -z "$LC0_PATH" ]; then
    echo -e "${YELLOW}lc0 konnte nicht automatisch gefunden werden.${NC}"
    read -p "Bitte gib den Pfad zum lc0-Verzeichnis ein (z.B. /usr/bin): " LC0_PATH
    
    if [ ! -f "$LC0_PATH/lc0" ]; then
        echo -e "${RED}Warnung: lc0 wurde nicht in $LC0_PATH gefunden!${NC}"
        echo -e "Bitte installiere lc0 oder gib den korrekten Pfad an."
        read -p "Trotzdem fortfahren? (j/n): " CONTINUE
        if [[ ! $CONTINUE =~ ^[Jj]$ ]]; then
            echo -e "${RED}Abbruch.${NC}"
            exit 1
        fi
    fi
fi

# Automatische Erkennung des lc0-Backends
echo -e "${YELLOW}Erkenne lc0-Backend für diese Plattform...${NC}"
LC0_BACKEND=""

# Betriebssystem erkennen
OS_TYPE=$(uname -s)
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS verwendet Metal
    LC0_BACKEND="metal"
    echo -e "${GREEN}macOS erkannt: Verwende 'metal' Backend${NC}"
else
    # Linux (Ubuntu) verwendet BLAS oder OpenCL, je nach Verfügbarkeit
    if [ -d "/usr/include/openblas" ] || [ -d "/usr/local/include/openblas" ]; then
        LC0_BACKEND="blas"
        echo -e "${GREEN}Linux mit OpenBLAS erkannt: Verwende 'blas' Backend${NC}"
    elif [ -d "/usr/include/CL" ] || [ -d "/usr/local/include/CL" ]; then
        LC0_BACKEND="opencl"
        echo -e "${GREEN}Linux mit OpenCL erkannt: Verwende 'opencl' Backend${NC}"
    else
        # Fallback auf BLAS
        LC0_BACKEND="blas"
        echo -e "${YELLOW}Konnte kein spezifisches Backend erkennen: Verwende 'blas' als Standard${NC}"
    fi
fi

# Benutzer kann das Backend überschreiben, wenn gewünscht
read -p "Backend für lc0 [$LC0_BACKEND]: " USER_BACKEND
if [ -n "$USER_BACKEND" ]; then
    LC0_BACKEND="$USER_BACKEND"
    echo -e "${GREEN}Backend auf '$LC0_BACKEND' gesetzt${NC}"
fi

# Erstelle temporäre Konfigurationsdatei mit ersetzten Platzhaltern
cat config_base.yml | sed "s|__LC0_PATH__|$LC0_PATH|g" | sed "s|__LC0_BACKEND__|$LC0_BACKEND|g" > config_base_temp.yml

# config_token.yml und die modifizierte config_base.yml zusammenführen
cat config_token.yml config_base_temp.yml > config.yml

# Temporäre Datei entfernen
rm config_base_temp.yml

echo -e "${GREEN}config.yml erfolgreich erstellt!${NC}"
echo -e "Dein Token wurde in config_token.yml gespeichert (diese Datei ist in .gitignore ausgeschlossen)"
echo -e "Die vollständige Konfiguration wurde in config.yml gespeichert"

# Sicherheitshinweis
echo -e ""
echo -e "${YELLOW}Sicherheitshinweis:${NC}"
echo -e "Dein Token ist ein Sicherheitsschlüssel und sollte niemals in öffentlichen Repositories gespeichert werden."
echo -e "config_token.yml und config.yml sind in .gitignore aufgeführt und werden nicht zum Repository hinzugefügt."
