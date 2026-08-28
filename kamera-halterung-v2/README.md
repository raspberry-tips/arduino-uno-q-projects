# Kamerahalterung v2: Spaghetti-Wächter am 3D-Drucker

Zweite Generation der Halterung für den KI-Druckwächter auf dem Arduino UNO Q
(Artikelserie auf [raspberry.tips](https://raspberry.tips/category/arduino)).
Die v1-Klammer saß am Gehäuse und ließ sich zu leicht verschieben — und
verschiebt man die Kamera, ist das Anomalie-Modell wertlos, weil es die Szene
mitgelernt hat. Deshalb v2: ein steifer Arm, der an der **Z-Säule** klemmt,
mit aufsteckbarer Wanne für das Board und einem Kamera-Adapter, der sich
horizontal und vertikal ausrichten lässt.

![Alle drei Teile](renderings/alle-teile.png)

## Die Teile

| Datei | Teil | Maße | Druck-Hinweis |
|---|---|---|---|
| `stl/halterung-arm.stl` | Klemmarm mit Maul (27,3 mm Weite, 31,4 mm tief) | 160 × 43,3 × 24 mm | flach aufs Bett (Profil unten), **kein Support**, 4–5 Wandlinien |
| `stl/uno-q-wanne.stl` | Wanne fürs Board, wird seitlich aufgesteckt | 85 × 94 × 16,5 mm | Boden aufs Bett, **Support nötig** — die zwei Haltezapfen ragen waagerecht ab |
| `stl/kamera-adapter.stl` | Pan/Tilt-Adapter für das Kameragehäuse | 36 × 24 × 25,5 mm | Platte aufs Bett, kein Support |

**Support für die Wanne:** Nur die beiden Zapfen an der Rückwand schweben
(Achse waagerecht, 3,8 mm über dem Bett). Im Slicer „Support: überall" mit
Standard-Schwellenwinkel genügt — es entsteht nur an diesen zwei Stellen
welcher und lässt sich mit den Fingern abbrechen.

⚠️ **Passung Wanne:** Im Testdruck saß das UNO Q etwas stramm — es geht, aber
ohne Luft. Wer lieber Spiel hat, öffnet `build_freecad.py` und erhöht `WL_`
(80) und `WB_` (65) im Abschnitt „Masse" um 0,5–1 mm, dann `export_stl.py`
laufen lassen. Die hier abgelegten STLs sind der Stand, der real montiert ist.

## Zusammenbau

![Montage](renderings/montage-seite.png)

1. Arm mit dem Maul auf die Z-Säule schieben.
2. Wanne von der Seite auf die zwei Zapfen-Löcher (Ø 4,3 mm) stecken — die
   Zunge legt sich dabei bündig unter den Balken und stützt die Wanne.
3. Kamera-Adapter mit einer **1/4-Zoll-Schraube** (Stativgewinde) durch das
   Loch im Balken schrauben; die Senkung Ø 14,5 mm nimmt den Kopf auf.
   Lösen, drehen, wieder anziehen = Schwenk (Pan).
4. Kameragehäuse mit **M5-Schraube + Mutter** in die Gabel des Adapters —
   das ist die Neigung (Tilt). Beides Reibschluss, kein Rastwerk.

Kaufteile: 1 × 1/4"-20-Schraube (Stativschraube, ca. 20 mm), 1 × M5 × 25 mit
Mutter. Kameragehäuse (`cam_back.stl` / `cam_front.stl`) liegt unverändert
in [`../kamera-halterung/`](../kamera-halterung/).

## Quellen bearbeiten

Alles ist parametrisch in FreeCAD 1.1 gebaut — die Maße stehen in einem
Tabellenblatt „Parameter" im Dokument:

| Datei | Zweck |
|---|---|
| `Halterung-v2.FCStd` | das Modell, alle drei Körper in Drucklage |
| `build_freecad.py` | baut das Dokument von Null neu (`freecadcmd build_freecad.py`) |
| `export_stl.py` | exportiert die drei Körper nach `stl/` |
| `render_stl.py` | erzeugt die Bilder in `renderings/` (trimesh + matplotlib) |

Die Scripts laufen headless, brauchen also keine FreeCAD-Oberfläche. Wer
lieber klickt: Doppelklick auf eine Skizze im Baum zeigt alle Bemaßungen.

## Lizenz

CC BY 4.0 — raspberry.tips
