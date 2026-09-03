# Kamerahalterung: Spaghetti-Waechter am 3D-Drucker

> 📦 **Der KI-Druckwächter hat ein eigenes Repo:**
> [raspberry-tips/uno-q-3d-print-watchdog](https://github.com/raspberry-tips/uno-q-3d-print-watchdog) — dort liegen
> App, CAD, Kamera-Setup und Autostart zusammen, mit englischem README.
> Dieser Ordner bleibt bestehen, weil die Artikel der Serie darauf verlinken.

Werkzeuglose Kamerahalterung fuer eine IMX219-Kamera (Arducam/Pi Cam 2) am
Arduino UNO Q — Teil der Artikelserie auf https://raspberry.tips (Arduino UNO Q
Druckwaechter). Klemmt am Druckergehaeuse, nichts wird gebohrt oder geklebt.

> **Es gibt eine neuere Version:** [`../kamera-halterung-v2/`](../kamera-halterung-v2/) — steifer Arm, der an der Z-Saeule klemmt, mit aufsteckbarer Board-Wanne und Pan/Tilt-Adapter. Diese Teile hier bleiben unveraendert, weil die Artikel darauf verweisen.

| Datei | Teil | Druck-Hinweis |
|---|---|---|
| `klammer_gehaeuse_uno.stl` | Klammer mit UNO-Q-Halter (Schenkelabstand 42,5 mm — an die eigene Gehaeusekante anpassen) | auf die Seite legen (Taste F im Slicer), 4-6 Wandlinien |
| `cam_back.stl` | Kamera-Rueckschale, schraublos (4 Zentrier-Pins, Schnapper) | Ruecken aufs Bett, kein Support |
| `cam_front.stl` | Frontblende, klipst auf die Rueckschale | Aussenseite aufs Bett, kein Support |
| `adapter45.stl` | 45-Grad-Gelenkadapter, M5-Muttern versenkt | flach, kein Support |

Kaufteile: 2x M5x20-30 + 2x M5-Mutter. PLA, 0,16 mm, support-frei.
Die parametrischen OpenSCAD-Quellen liegen in `../gehaeuse/scad/camarm.scad`.

Lizenz: CC BY 4.0 — raspberry.tips
