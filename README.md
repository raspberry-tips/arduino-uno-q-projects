# Arduino UNO Q – Projekte von raspberry.tips

Sketches und Projekte aus unserer [Arduino-UNO-Q-Artikelserie](https://raspberry.tips/category/arduino)
auf [raspberry.tips](https://raspberry.tips).

## Projekte

| Projekt | Beschreibung | Artikel |
|---|---|---|
| [`spaghetti-waechter/`](spaghetti-waechter/) | **KI-Druckwächter**: erkennt Fehldrucke lokal per Anomalie-Erkennung (FOMO-AD), meldet an Home Assistant und kann den Druck über Moonraker pausieren. App Lab App (Python + Sketch) als Ordner und als Import-Zip | [Serie, Teil 4](https://raspberry.tips/arduino/arduino-uno-q-druckwaechter-teil-4) |
| [`kamera-setup/`](kamera-setup/) | Kamera am Media Carrier aktivieren, Livebild zum Ausrichten, Frames sammeln, Upload zu Edge Impulse | [Serie, Teil 2](https://raspberry.tips/arduino/arduino-uno-q-druckwaechter-teil-2) |
| [`autostart/`](autostart/) | systemd-Unit + Wartescript, damit der Wächter nach einem Reboot von selbst hochkommt | [Serie, Teil 5](https://raspberry.tips/arduino/arduino-uno-q-druckwaechter-teil-5) |
| [`kamera-halterung-v2/`](kamera-halterung-v2/) | **CAD**: Klemmarm an der Z-Säule, Board-Wanne, Pan/Tilt-Adapter — STL + parametrische FreeCAD-Quelle | [Serie, Teil 5](https://raspberry.tips/arduino/arduino-uno-q-druckwaechter-teil-5) |
| [`kamera-halterung/`](kamera-halterung/) | **CAD**: erste Halterungsgeneration + das weiterhin genutzte zweiteilige Kameragehäuse | [Serie, Teil 1](https://raspberry.tips/arduino/arduino-uno-q-druckwaechter-teil-1) |
| [`gehaeuse/`](gehaeuse/) | **CAD**: Stapelgehäuse für UNO Q + UNO Media Carrier (Stülp-Prinzip), STL + 3MF + OpenSCAD | [Zum Artikel](https://raspberry.tips/3d-druck/arduino-uno-q-gehaeuse-3d-druck) |
| [`laufschrift/`](laufschrift/) | Beliebiger Text als Laufschrift auf der 8×13-LED-Matrix – mit eigenem Pixelfont (a–z, 0–9, Satzzeichen) | [Arduino-Serie](https://raspberry.tips/category/arduino) |
| [`labyrinth/`](labyrinth/) | Kugellabyrinth: Board neigen und die Kugel per Modulino Movement (IMU am Qwiic-Port) durch 3 Level balancieren | [Zum Artikel](https://raspberry.tips/arduino/arduino-uno-q-projekt-kugellabyrinth) |

## Verwendung (Arduino App Lab)

1. App Lab öffnen → **My Apps** → **Create new app +**
2. Inhalt von `sketch/sketch.ino` durch den jeweiligen Sketch ersetzen
3. **Run** klicken

Für das Labyrinth wird zusätzlich die Bibliothek **Arduino_Modulino**
benötigt (über den Button „Add Sketch Library“ in der Seitenleiste
hinzufügen) sowie ein **Modulino Movement** am Qwiic-Port.

Der Druckwächter ist eine vollständige App und wird nicht abgetippt, sondern
importiert — siehe [`spaghetti-waechter/README.md`](spaghetti-waechter/).

## Lizenz

Zwei Lizenzen, je nach Art des Materials:

| Material | Lizenz |
|---|---|
| **Code** — Sketches, Python, Shell-Scripts, App-Lab-Apps | **MIT**, siehe [LICENSE](LICENSE) |
| **CAD und 3D-Druckdateien** — `kamera-halterung/`, `kamera-halterung-v2/`, `gehaeuse/` (STL, 3MF, FCStd, SCAD und die zugehörigen Renderings) | **CC BY 4.0** |

Maßgeblich ist jeweils die README im betreffenden Ordner. Die MIT-Lizenz im
Repo-Wurzelverzeichnis gilt ausdrücklich **nicht** für die CAD-Ordner.
