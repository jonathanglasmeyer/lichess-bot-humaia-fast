# Maia-1400 Lichess Bot

Diese Konfiguration stellt einen Lichess-Bot bereit, der das Maia-1400-Schachnetzwerk verwendet, um menschenähnliche Züge zu spielen. Der Bot ist für eine Spielstärke von etwa 1400 Elo konzipiert und verwendet Temperaturparameter, um ein natürliches Spielverhalten zu erreichen.

## Funktionsweise

- **Maia-1400 Netzwerk**: Ein neuronales Netzwerk, das anhand von menschlichen 1400-Elo-Spielen trainiert wurde
- **nodes=1 Modus**: Der Bot verwendet keine Suchbaumanalyse, sondern direkte Netzwerkvorhersagen
- **Temperaturparameter**: Steuern Zufälligkeit und Varianz der Züge für menschenähnliches Spielen

## Installation und Ausführung

### Ubuntu Server

1. **Installation**:
   ```bash
   chmod +x scripts/install_ubuntu.sh
   ./scripts/install_ubuntu.sh
   ```

2. **Bot starten**:
   ```bash
   chmod +x scripts/start_bot_ubuntu.sh
   ./scripts/start_bot_ubuntu.sh
   ```

3. **Als Hintergrunddienst einrichten**:
   ```bash
   chmod +x scripts/deploy_ubuntu_server.sh
   ./scripts/deploy_ubuntu_server.sh
   ```

### macOS

1. **Installation**:
   ```bash
   chmod +x scripts/install_macos.sh
   ./scripts/install_macos.sh
   ```

2. **Bot starten**:
   ```bash
   chmod +x scripts/start_bot_macos.sh
   ./scripts/start_bot_macos.sh
   ```

## Wartung und Überwachung

### Ubuntu Server (als Dienst)

- **Status überprüfen**:
  ```bash
  sudo systemctl status lichess-bot
  ```

- **Logs ansehen**:
  ```bash
  tail -f logs/lichess-bot.log
  ```

- **Dienst stoppen**:
  ```bash
  sudo systemctl stop lichess-bot
  ```

- **Dienst neustarten**:
  ```bash
  sudo systemctl restart lichess-bot
  ```

## Konfiguration

Die Konfiguration ist in zwei Dateien aufgeteilt:

1. **config_base.yml**: Enthält alle Einstellungen außer dem Token (im Repository enthalten)
2. **config_token.yml**: Enthält nur den Lichess API-Token (nicht im Repository enthalten)

### Setup des API-Tokens

```bash
# Token konfigurieren (einmalig)
./scripts/configure_token.sh DEIN_LICHESS_TOKEN
```

Dieses Skript erstellt automatisch die vollständige `config.yml` aus `config_base.yml` und dem angegebenen Token.

### Wichtige Konfigurationsparameter

- **Engine-Einstellungen**: Pfad und Optionen für lc0
- **Temperaturparameter**: Steuern das Zugverhalten für menschenähnliches Spielen
  - `Temperature`: Primäre Zugauswahltemperatur (0.9 empfohlen)
  - `TempEndgame`: Temperatur für das Endspiel (0.35 empfohlen)
  - `TempCutoffMove`: Ab welchem Zug das Endspiel beginnt (24 empfohlen)
  - `TempDecayMoves`: Über wie viele Züge die Temperatur abnimmt (18 empfohlen)
- **Rate-Limiting**: Einstellungen zur Vermeidung von API-Begrenzungen

## Fehlerbehebung

- **API-Ratenbegrenzungen**: Die Einstellungen `rate_limiting_delay` und `api_retry_delay` in config.yml anpassen
- **Engine startet nicht**: Prüfen Sie, ob lc0 korrekt installiert ist und die Maia-1400-Gewichte vorhanden sind
