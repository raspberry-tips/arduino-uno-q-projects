# Kugellabyrinth (UNO Q + Modulino Movement)

Board neigen und die Kugel durch drei Level auf der 8×13-LED-Matrix
balancieren – vorbei an den Löchern bis zum pulsierenden Ziel.

**Hardware:** Arduino UNO Q + [Modulino Movement](https://store.arduino.cc/products/modulino-movement) am Qwiic-Port.

## Einrichtung in Arduino App Lab

1. **My Apps → Create new app +**, Namen vergeben
2. Inhalt von `sketch/sketch.ino` durch [`sketch.ino`](sketch.ino) ersetzen
3. **Bibliothek eintragen:** `sketch/sketch.yaml` öffnen und unter dem
   `default`-Profil folgenden Block ergänzen (Einrückung beachten):

```yaml
    libraries:
      - Arduino_Modulino (0.9.0)
      - STM32duino VL53L4CD (1.0.5)
      - STM32duino VL53L4ED (1.0.1)
      - Arduino_LSM6DSOX (1.1.2)
      - Arduino_LPS22HB (1.0.2)
      - Arduino_HS300x (1.0.0)
      - ArduinoGraphics (1.1.5)
      - Arduino_LTR381RGB (1.0.0)
```

4. **Run** klicken

## Kalibrierung

Rollt die Kugel spiegelverkehrt oder sind links/rechts und vor/zurück
vertauscht, oben im Sketch `INVERT_X`, `INVERT_Y` bzw. `SWAP_AXES` anpassen.

## Anzeige

| Element | Darstellung |
|---|---|
| Wand | gedimmt, dauerhaft an |
| Loch | pulsiert schwach |
| Ziel | pulsiert hell |
| Kugel | volle Helligkeit |
