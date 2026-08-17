# Kugellabyrinth (UNO Q + Modulino Movement)

Board neigen und die Kugel durch drei Level auf der 8×13-LED-Matrix
balancieren – vorbei an den Löchern bis zum pulsierenden Ziel.

**Hardware:** Arduino UNO Q + [Modulino Movement](https://store.arduino.cc/products/modulino-movement) am Qwiic-Port.

## Einrichtung in Arduino App Lab

1. **My Apps → Create new app +**, Namen vergeben
2. Inhalt von `sketch/sketch.ino` durch [`sketch.ino`](sketch.ino) ersetzen
3. **Bibliothek hinzufügen:** In der linken Seitenleiste auf das
   Bibliotheks-Symbol (**Add Sketch Library**) klicken, nach `Arduino_Modulino`
   suchen und hinzufügen. Die `sketch.yaml` der App lässt sich in App Lab
   (Stand 0.10.0) nicht direkt bearbeiten – App Lab trägt die Bibliothek über
   den Button selbst ins Build-Profil ein. Zur Kontrolle: Die
   [`sketch.yaml`](sketch.yaml) in diesem Ordner zeigt, wie das Profil danach
   aussehen sollte.

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
