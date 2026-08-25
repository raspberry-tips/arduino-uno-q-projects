# Gehäuse für Arduino UNO Q + UNO Media Carrier

Zweiteiliges, komplett schraubloses 3D-Druck-Gehäuse für den Arduino UNO Q
mit aufgestecktem UNO Media Carrier (ASX00083) — nach unserem Wissen das
erste Gehäuse für diesen Stack.

**Anleitung, Designprozess und Druck-Learnings:**
https://raspberry.tips/3d-druck/arduino-uno-q-gehaeuse-3d-druck

## Dateien

| Datei | Zweck |
|---|---|
| `boden.stl` / `haube.stl` | druckfertig orientiert, support-frei |
| `boden.3mf` / `haube.3mf` | ELEGOO-Slicer-Projekte mit erprobten Einstellungen |
| `stack_case.scad` + `lib_gopro.scad` | parametrische OpenSCAD-Quellen |
| `haube_overlay.png` | Foto-Overlay-Verifikation der Öffnungen |

## Druck

PLA (Matte), 0,4-mm-Düse, 0,16 mm Schichthöhe, Brim 5 mm, **kein Support**.
Boden flach, Haube mit der Deckplatte nach unten (liegt in den Dateien so).

## Funktionsprinzip

Stack auf vier Eck-Auflagen legen (der Carrier hat keine Montagelöcher!),
Haube überstülpen — die unten offenen Port-Ausschnitte gleiten über die
überstehenden Buchsen — und an den Ecken einklipsen. Vier Niederhalter-
Säulen mit Zentrier-Zapfen fixieren den UNO Q. Öffnen: Haube gerade
nach oben abziehen.

## Lizenz

CC BY 4.0 — raspberry.tips
