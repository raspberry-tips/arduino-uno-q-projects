// camarm.scad — Einstellbare Kamerahalterung fuer Pi Camera Module 2
// Spaghetti-Waechter / raspberry.tips — v0.1 (21.08.2026)
//
// System: GoPro-Standard (lib_gopro.scad). Teile einzeln rendern:
//   openscad -D part=\"cam_back\" -o cam_back.stl camarm.scad
//   Teile: cam_back | cam_front | arm40 | arm80 | twist90 |
//          foot_clamp | foot_plate | thumbnut | preview
//
// Verbindungslogik: Arme enden beidseitig MALE (2 Finger), alle
// Aufnahmen (Kamera, Fuesse, Adapter) sind FEMALE (3 Finger) —
// dadurch ist jede Kombination steckbar. M5x30 + Fluegelmutter je Gelenk.
//
// Kamera-Masse OFFIZIELL (RPi Mechanical Drawing RPI-CAM-V2_1):
//   Platine 25 x 23.862, R2-Ecken, 4x Ø2.2 im Raster 21 x 12.5.
// Linsenposition 26.08. VERMESSEN aus Referenz-Case Printables 983982
// (STL via API geladen, Geometrie analysiert): 9x9-Fenster, horizontal
// zentriert, Mitte 8.75 ueber der Flex-Kante. V1 damit erledigt.
// Restannahmen: V2 Lochreihen 9.362/21.862 (Loecher passen laut Testfit),
// V3 Platinendicke 1.1

include <lib_gopro.scad>;

part = "preview";

// ── Kamera-Parameter ──────────────────────────────────────────
cam_w      = 25.0;
cam_h      = 23.862;
hole_x     = [2, 23];
hole_y     = [9.362, 21.862];   // V2
lens_x     = 12.5;   // 26.08.: aus Referenz-Case Printables 983982 vermessen —
lens_y     = 8.75;    // horizontal zentriert, nahe der Flex-Kante (Fenster dort
lens_win   = 9.4;     // 9x9 Quadrat, Mitte Platte-x/y 13.97/10.8 → PCB 12.5/8.75)

wall   = 2.4;
clr    = 0.4;
post_d = 5.0;
post_hole = 1.8;                // M2 selbstschneidend
box_w  = cam_w + 2*clr + 2*wall;    // 30.6
box_h  = cam_h + 2*clr + 2*wall;    // 29.5
back_depth = 6;                     // Innenraum hinter Platine (Flex-Bogen)
front_t    = 2.4;

p0 = [wall + clr, wall + clr];      // Platinen-Nullpunkt

// ── Teil 1: Rueckschale — GoPro-Tab unter der Unterkante ──────
// Druck: Rueckseite auf dem Bett, Tab liegt flach mit (kein Support).
// Gelenkachse zeigt nach hinten → Roll; Tilt/Pan kommen aus Arm+Fuss.
module cam_back() {
    box_t = wall + back_depth;      // 8.4
    difference() {
        cube([box_w, box_h, box_t]);
        translate([wall, wall, wall])
            cube([box_w - 2*wall, box_h - 2*wall, back_depth + 1]);
        // Flex-Schlitz unten (Kabel ~16 breit)
        translate([box_w/2 - 9, -0.5, wall + back_depth - 2.6])
            cube([18, wall + 1, 3.1]);
    }
    // 4 Dome: 2 diagonale mit Zentrier-Pin (tool-less), 2 mit M2-Loch
    // als optionale Schraub-Reserve (26.08.)
    for (hx = hole_x, hy = hole_y) {
        pin = (hx == hole_x[0] && hy == hole_y[0]) || (hx == hole_x[1] && hy == hole_y[1]);
        translate([p0[0] + hx, p0[1] + hy, 0])
            if (pin) {
                cylinder(d = post_d, h = box_t);
                translate([0, 0, box_t]) cylinder(d = 1.7, h = 2.0);
            } else {
                difference() {
                    cylinder(d = post_d, h = box_t);
                    translate([0, 0, wall]) cylinder(d = post_hole, h = back_depth + 1);
                }
            }
    }
    // Schnapp-Nocken aussen auf beiden x-Waenden (Diamantprofil,
    // rastet in die Fenster der Frontblenden-Schuerze)
    for (xo = [0, box_w])
        translate([xo, box_h/2, 5.75])
            rotate([0, 45, 0]) cube([1.0, 4, 1.0], center = true);
    // Male-Tab unter der Unterkante, buendig mit Rueckseite (9.4 ≈ box_t+1)
    translate([box_w/2, 0.1, 0]) rotate([0, 0, 180]) gp_male();
}

// ── Teil 2: Frontblende — TOOL-LESS (26.08.): 3-seitige Schuerze
// klipst auf die cam_back-Nocken; die Platte drueckt die Platine auf
// die Dome, die Zentrier-Pins fassen durch PCB + Plattenloecher.
// y0-Seite bleibt schuerzenfrei (GoPro-Tab). M2-Loecher = Reserve.
sk_t = 1.8;    // Schuerzendicke
sk_d = 6.0;    // Schuerzentiefe
sk_c = 0.3;    // Spiel zur Box je Seite

module cam_front() {
    px0 = -(sk_c + sk_t);              // Plattenrand links
    pw  = box_w + 2*(sk_c + sk_t);     // Plattenbreite
    ph  = box_h + sk_c + sk_t;         // Plattenhoehe (y0 buendig)
    difference() {
        union() {
            translate([px0, 0, 0]) cube([pw, ph, front_t]);
            // Schuerze: links, rechts, y-max
            translate([px0, 0, front_t]) cube([sk_t, ph, sk_d]);
            translate([box_w + sk_c, 0, front_t]) cube([sk_t, ph, sk_d]);
            translate([px0, box_h + sk_c, front_t]) cube([pw, sk_t, sk_d]);
        }
        // Linsenfenster QUADRATISCH wie Referenz-Case 983982 (Halter
        // ist ~8x8 eckig — ein rundes Fenster klemmt an den Ecken)
        translate([p0[0] + lens_x - lens_win/2, p0[1] + lens_y - lens_win/2, -0.5])
            cube([lens_win, lens_win, front_t + 1]);
        // 4 Loecher: 2 nehmen die Zentrier-Pins auf, 2 = M2-Reserve;
        // Senkung auf der AUSSENSEITE (z0 = Sichtseite nach Montage-Flip)
        for (hx = hole_x, hy = hole_y)
            translate([p0[0] + hx, p0[1] + hy, -0.5]) {
                cylinder(d = 2.4, h = front_t + 1);
                cylinder(d = 4.4, h = 1.4);
            }
        // Schnapp-Fenster in beiden x-Schuerzen (Nocke box-z 5.75 →
        // lokal z = front_t + (box_t + 1.1 - 5.75) ≈ 6.15)
        for (xo = [px0 - 0.5, box_w + sk_c - 0.5])
            translate([xo, box_h/2 - 2.5, 4.9])
                cube([sk_t + 1, 5, 2.5]);
    }
}

// ── Teil 3: Arme — beidseitig male, flach druckbar ────────────
module arm_layer(len, t) {
    difference() {
        hull() {
            translate([0, 0, 0])   cylinder(d = gp_knuckle_d, h = t);
            translate([len, 0, 0]) cylinder(d = gp_knuckle_d, h = t);
        }
        for (x = [0, len])
            translate([x, 0, -0.5]) cylinder(d = gp_hole_d, h = t + 1);
    }
}
module arm(len = 40) {
    for (zi = [0, gp_prong_t + gp_slot_t])
        translate([0, 0, zi]) arm_layer(len, gp_prong_t);
    // Mittelsteg fuellt die Fingerluecke ausserhalb der Gelenke
    translate([gp_knuckle_d/2 + 2, -5, 0])
        cube([len - gp_knuckle_d - 4, 10, gp_male_w()]);
}
module arm40() { arm(40); }
module arm80() { arm(80); }

// ── Teil 4: 90°-Adapter (wechselt die Gelenkachse) ────────────
module twist90() {
    base_t = gp_male_w();           // 9.4
    difference() {
        translate([-13, -12, 0]) cube([26, 24, base_t]);
        // Gewichtsersparnis
        translate([0, 0, -0.5]) cylinder(d = 10, h = base_t + 1);
    }
    // Female-Gabel aufrecht (Achse horizontal, quer)
    translate([0, gp_female_w()/2, base_t]) rotate([90, 0, 0]) gp_female();
    // Male-Tab flach seitlich (Achse vertikal)
    translate([13, 0, 0]) rotate([0, 0, -90])
        translate([-0, 0.1, 0]) rotate([0, 0, 180]) gp_male();
}

// ── Teil 5: Fuss A — Klemme fuer Alu-Profil ───────────────────
// ANNAHME V4: 2020-V-Slot (Neptune 4 Plus MESSEN — Punkt M5!)
profile_w  = 20.2;
profile_d  = 20.2;
clamp_wall = 5;
clamp_len  = 25;

module foot_clamp() {
    ow = profile_w + 2*clamp_wall;
    od = profile_d + clamp_wall + 3;
    difference() {
        cube([ow, od, clamp_len]);
        // Profilkanal, nach vorn (y=0) offen
        translate([clamp_wall, -0.5, -0.5])
            cube([profile_w, profile_d + 0.5, clamp_len + 1]);
        // Klemmschraube M5 quer durch die Rueckwand-Zone
        translate([-0.5, profile_d + (clamp_wall + 3)/2, clamp_len/2]) {
            rotate([0, 90, 0]) cylinder(d = 5.4, h = ow + 1);
            rotate([0, 90, 0]) cylinder(d = 8.2/cos(30), h = 4.5, $fn = 6);
        }
    }
    translate([ow/2, od/2 + gp_female_w()/2, clamp_len])
        rotate([90, 0, 0]) gp_female();
}

// ── Teil 6: Fuss B — Universal-Schraubplatte (Langloecher) ────
module foot_plate() {
    difference() {
        hull()
            for (x = [6, 44], y = [6, 24])
                translate([x, y, 0]) cylinder(d = 12, h = 4);
        for (x = [8, 36])
            hull() {
                translate([x, 15, -0.5])     cylinder(d = 5.4, h = 5);
                translate([x + 6, 15, -0.5]) cylinder(d = 5.4, h = 5);
            }
    }
    translate([25, 15 + gp_female_w()/2, 4]) rotate([90, 0, 0]) gp_female();
}

// ── Teil 7: Fluegelmutter (M5-Mutter oder -Sechskantkopf) ─────
module thumbnut() { gp_thumbnut(); }

// ── Teil 8: Standfuss — freistehend neben dem Drucker ─────────
// (Variante 1, entschieden 23.08.: druckerunabhaengig, nichts am
//  Leihgeraet. Bodenplatte optional mit 4 Holzschrauben auf ein
//  Brett; Mast steckt im Schacht, M5 klemmt ihn.)
mast_h = 250;    // ⚠️ VOR DEM DRUCK anpassen: Zielhoehe Kameramitte
                 // = (Betthoehe ueber Tisch) + 100..200 − 48 (Schacht)
mast_w = 24.6;   // Mastquerschnitt
sock_w = 25.0;   // Schacht stramme Achse (0.4 Spiel)
sock_d = 27.8;   // Schacht Keil-Achse: Mast + 3.2 Keiltasche (26.08. tool-less)
base_w = 150;    // Bodenplatte

module stand_base() {
    // Platte mit 4 Senkloechern fuer Holzschrauben
    difference() {
        hull()
            for (x = [14, base_w - 14], y = [14, base_w - 14])
                translate([x, y, 0]) cylinder(d = 28, h = 8);
        for (x = [16, base_w - 16], y = [16, base_w - 16])
            translate([x, y, -0.5]) {
                cylinder(d = 4.6, h = 9);
                translate([0, 0, 5.5]) cylinder(d1 = 4.6, d2 = 9.5, h = 3.1);
            }
    }
    // Steckschacht mittig — Mast liegt an der Rueckwand an, vorn 3.2er
    // Keiltasche (tool-less; M5-Bohrung bleibt als Reserve)
    translate([base_w/2, base_w/2, 0])
        difference() {
            translate([-sock_w/2 - 5, -sock_d/2 - 5, 0])
                cube([sock_w + 10, sock_d + 10, 48]);
            translate([-sock_w/2, -sock_d/2, 8])
                cube([sock_w, sock_d, 48]);
            // M5-Reserve
            translate([-sock_w/2 - 6, 0, 30])
                rotate([0, 90, 0]) cylinder(d = 4.6, h = sock_w + 12);
        }
}

module stand_mast(h = mast_h) {
    translate([-mast_w/2, -mast_w/2, 0]) cube([mast_w, mast_w, h]);
    // Female-Gabel oben (Kippachse horizontal)
    translate([0, gp_female_w()/2, h]) rotate([90, 0, 0]) gp_female();
}

// ── Teil 9: Klebe-Standfuss (26.08., korrigiert): STEHT wie der
// Standfuss, aber schmale Platte 50 x 100 zum Festkleben (doppelseitiges
// Band unter der planen Druckbett-Unterseite). Mast-Schacht an EINEM Ende,
// gleicher Mast wie stand_base. 2 Senkloecher am freien Ende als Option.
tm_w = 50;     // Plattenbreite
tm_l = 100;    // Plattenlaenge
tm_t = 6;      // Plattendicke

module tape_mount() {
    difference() {
        union() {
            // Platte, abgerundet
            hull()
                for (x = [6, tm_w - 6], y = [6, tm_l - 6])
                    translate([x, y, 0]) cylinder(d = 12, h = tm_t);
            // Schacht-Block am Platten-Ende (y-min-Seite)
            translate([tm_w/2 - sock_w/2 - 5, 4, 0])
                cube([sock_w + 10, sock_d + 10, 48]);
        }
        // Mast-Kanal mit Keiltasche vorn (Boden bei z 12, tool-less)
        translate([tm_w/2 - sock_w/2, 9, 12])
            cube([sock_w, sock_d, 48]);
        // M5-Reserve durch die Frontwand
        translate([tm_w/2, 9 + sock_d + 2.5, 30])
            rotate([-90, 0, 0]) cylinder(d = 4.6, h = 8, center = true);
        // 2 optionale Senk-Schraubloecher am freien Ende
        for (y = [tm_l - 12, tm_l - 30])
            translate([tm_w/2, y, -0.5]) {
                cylinder(d = 4.2, h = tm_t + 1);
                translate([0, 0, tm_t - 1.4]) cylinder(d1 = 4.2, d2 = 8.5, h = 1.5);
            }
    }
}

// ── Teil 10: Mast-Keil (26.08.) — verkeilt den Mast im Schacht,
// selbsthemmend und toleranz-unabhaengig (klemmt bei 1.4–4.2 mm Spalt).
// Zum Loesen am Griff nach oben ziehen. Flach drucken.
module mast_keil() {
    hull() {
        cube([20, 1.4, 1]);
        translate([0, 0, 43]) cube([20, 4.2, 1]);
    }
    translate([0, -2, 44]) cube([20, 8.2, 4]);   // Griffplatte
}

// ── Teil 11: FF-Adapter (26.08.) — zwei Female-Gabeln Ruecken an
// Ruecken (parallele Achsen = Ellbogen). Noetig, weil Arme beidseitig
// male enden und die Kamera ebenfalls male ist. Flach drucken,
// Support nur in den Fingerluecken (wie bei allen Male-Tabs).
module ff_adapter() {
    fb = 8;
    translate([0, fb/2, 0]) gp_female();
    translate([0, -fb/2, 0]) rotate([0, 0, 180]) gp_female();
    translate([-gp_base_w/2, -fb/2, 0]) cube([gp_base_w, fb, gp_female_w()]);
}

// ── Auswahl ───────────────────────────────────────────────────
if (part == "cam_back")   cam_back();
if (part == "cam_front")  cam_front();
if (part == "arm40")      arm40();
if (part == "arm80")      arm80();
if (part == "twist90")    twist90();
if (part == "foot_clamp") foot_clamp();
if (part == "foot_plate") foot_plate();
if (part == "thumbnut")   thumbnut();
if (part == "stand_base") stand_base();
if (part == "tape_mount") tape_mount();
if (part == "mast_keil") mast_keil();
if (part == "ff_adapter") ff_adapter();
if (part == "stand_mast") stand_mast();
if (part == "preview") {
    cam_back();
    translate([40, 10, 0])   cam_front();
    translate([10, -30, 0])  arm40();
    translate([0, 50, 0])    foot_clamp();
    translate([50, 50, 0])   foot_plate();
    translate([95, -25, 0])  twist90();
    translate([130, -25, 0]) thumbnut();
}
