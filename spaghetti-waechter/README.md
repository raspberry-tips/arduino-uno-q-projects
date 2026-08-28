# Spaghetti-Wächter — KI-Druckwächter für den Arduino UNO Q

App-Lab-App, die 3D-Druck-Fehler ("Spaghetti") per FOMO-AD-Anomalieerkennung
auf dem Arduino UNO Q erkennt — mit Status-Webseite, Home-Assistant-Anbindung
(MQTT Discovery inkl. Beweisfoto-Kamera), LED-Matrix-Alarm und optionaler
automatischer Druck-Pause via Moonraker/Klipper.

**Artikelserie mit allen Details:**
[KI-Druckwächter mit dem Arduino UNO Q](https://raspberry.tips/arduino/arduino-uno-q-druckwaechter-teil-1)
(deutsch, 5 Teile) · [English version](https://raspberry.tips/en/arduino/arduino-uno-q-print-watchdog-part-1)

## Struktur

```
spaghetti-waechter/
├── app.yaml            Bricks: arduino:visual_anomaly_detection + arduino:web_ui
├── python/
│   ├── main.py         Zyklus: printing? → Frame → detect → 3-von-4-Filter → Aktionen
│   ├── config.py       Defaults — alles auch im Webinterface einstellbar (Port 7000)
│   ├── ha_mqtt.py      MQTT Discovery (Alarm, Score, Status, Alarm-Bild-Kamera, LWT)
│   └── moonraker.py    print_state / print_duration / pause (urllib, kein Zusatzpaket)
├── assets/index.html   Status-Webseite: Livebild, Alarm-Bild, Log, alle Einstellungen
└── sketch/sketch.ino   LED-Matrix: Blink-Alarm + Herzschlag; Bridge.provide("set_alarm")
```

## Sicherheits-Design

- Alarm erst bei **3 von 4** anomalen Zyklen (Fenster ~60 s) — ein Ausreißer verpufft
- Nur aktiv, wenn Moonraker **"printing"** meldet; Warmup-Sperre für Homing/Purge
- **AUTO_PAUSE = False** bis die Schwelle auf echten Drucken validiert ist;
  Pause = sauberes Parken, nie M112
- Alarm latcht bis Druckende; Alarm-Frames (roh + markiert) landen in `data/alarme/`

## Inbetriebnahme (Kurzfassung)

1. FOMO-AD-Modell in Edge Impulse trainieren (Teil 3 der Serie),
   Deployment „Linux aarch64" → `.eim`
2. Modell registrieren: `.eim` nach `~/.arduino-bricks/ei-models/` (chmod +x)
   + `model.yaml` unter `~/.arduino-bricks/models/custom-ei/spaghetti-fomo-ad-v1/`
   (Format: siehe Teil 4 der Serie); Check: `arduino-app-cli model list`
3. Kamera-Dienste aus Teil 2 stilllegen: `sudo systemctl disable --now liveview capture`
4. App-Ordner nach `~/ArduinoApps/` kopieren, in App Lab öffnen, **Run**
   (Erststart zieht Docker-Images, dauert ein paar Minuten)
5. Einstellungen im Browser: `http://<board-ip>:7000` → ⚙️ Settings
   (Schwelle, Moonraker-IP, MQTT-Zugang — MQTT gilt nach App-Neustart)

⚠️ Die Status-Webseite hat keinen Login — nur im vertrauenswürdigen LAN betreiben
und einen eigenen, rein lokalen MQTT-Benutzer nur für den Wächter verwenden.

## Wichtigste Lektion aus dem Praxisbetrieb

**Inferenz muss durch exakt dieselbe Bild-Pipeline wie das Training** (Auflösung,
Drehung, Weißabgleich). Die App nutzt deshalb dieselbe GStreamer-Pipeline wie der
Trainings-Datensammler (`kamera-setup/`) als Dauerstrom. Und: FOMO-AD lernt die
komplette Szene — nach jeder Änderung an Kameraposition oder Licht neu trainieren
(der eingebaute Trainings-Puffer in `data/training/` sammelt dafür automatisch).
