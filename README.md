# Arduino UNO Q – Projekte von raspberry.tips

Sketches und Projekte aus unserer [Arduino-UNO-Q-Artikelserie](https://raspberry.tips/category/arduino)
auf [raspberry.tips](https://raspberry.tips).

> ## 📦 Der KI-Druckwächter ist umgezogen
>
> Das komplette Projekt „Spaghetti Watchdog" — App Lab App, CAD der Kamerahalterung,
> Kamera-Setup und Autostart — liegt jetzt in einem eigenen Repository:
>
> ### → [raspberry-tips/uno-q-3d-print-watchdog](https://github.com/raspberry-tips/uno-q-3d-print-watchdog)
>
> Dort ist auch das README auf Englisch. Die früheren Ordner `spaghetti-waechter/`,
> `kamera-setup/`, `kamera-halterung/` und `kamera-halterung-v2/` gibt es hier
> nicht mehr; die Artikel der Serie verlinken auf das neue Repo.

## Projekte

| Projekt | Beschreibung | Artikel |
|---|---|---|
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

## Lizenz

| Material | Lizenz |
|---|---|
| **Code** — Sketches, Python, Shell-Scripts | **MIT**, siehe [LICENSE](LICENSE) |
| **CAD und 3D-Druckdateien** in [`gehaeuse/`](gehaeuse/) (STL, 3MF, SCAD, Renderings) | **CC BY 4.0** |

Maßgeblich ist jeweils die README im betreffenden Ordner. Die MIT-Lizenz im
Repo-Wurzelverzeichnis gilt ausdrücklich **nicht** für die CAD-Ordner.
