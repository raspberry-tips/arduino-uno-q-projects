// lib_gopro.scad — GoPro-kompatibles Mount-System (gemeinsame Module)
// Spaghetti-Waechter / raspberry.tips — v0.1 (21.08.2026)
// Alle Masse in mm, FDM 0.4-Duese, PLA. Toleranzen bewusst grosszuegig.
//
// Standard: male = 2 Finger (9.4 mm), female = 3 Finger (15.8 mm),
// M5-Schraube + Fluegelmutter. v0.1 OHNE Verzahnung (Reibschluss wie beim
// Original — Verzahnung ist v2-Idee, siehe README).

$fn = $preview ? 32 : 96;

// ── Kernparameter ─────────────────────────────────────────────
gp_prong_t   = 3.0;   // Fingerdicke male
gp_slot_t    = 3.4;   // Schlitzbreite female (0.4 Spiel)
gp_hole_d    = 5.4;   // M5-Durchgang
gp_knuckle_d = 15.0;  // Augen-Aussendurchmesser
gp_height    = 13.0;  // Lochmitte ueber Basisflaeche
gp_base_w    = 16.0;  // Fussbreite der Finger

// male-Paket: 2 Finger + 1 Luecke
function gp_male_w()   = 2*gp_prong_t + gp_slot_t;            // 9.4
// female-Paket: 3 Finger + 2 Luecken
function gp_female_w() = 3*gp_prong_t + 2*gp_slot_t;          // 15.8

// ── Ein einzelner Finger (liegt in XY, Dicke in Z) ────────────
module gp_finger(t = gp_prong_t) {
    difference() {
        union() {
            translate([-gp_base_w/2, 0, 0]) cube([gp_base_w, gp_height, t]);
            translate([0, gp_height, 0])    cylinder(d = gp_knuckle_d, h = t);
        }
        translate([0, gp_height, -0.5]) cylinder(d = gp_hole_d, h = t + 1);
    }
}

// ── Male-Tab: 2 Finger, Gesamtdicke 9.4 ───────────────────────
module gp_male() {
    for (i = [0, 1])
        translate([0, 0, i * (gp_prong_t + gp_slot_t)]) gp_finger();
}

// ── Female-Mount: 3 Finger, Gesamtdicke 15.8 ──────────────────
module gp_female() {
    for (i = [0, 1, 2])
        translate([0, 0, i * (gp_prong_t + gp_slot_t)]) gp_finger();
}

// ── Fluegelmutter: M5-Sechskant-Tasche (SW8), Ø22-Knauf ────────
// Passt fuer M5-Mutter UND M5-Sechskantkopf (beide SW8).
module gp_thumbnut(knob_d = 22, knob_h = 10, hex_sw = 8.2, hex_h = 4.2) {
    difference() {
        union() {
            cylinder(d = knob_d, h = knob_h);
            // Griffnoppen
            for (i = [0 : 7])
                rotate([0, 0, i * 45])
                    translate([knob_d/2, 0, 0]) cylinder(d = 4, h = knob_h);
        }
        // Sechskant-Tasche von unten
        translate([0, 0, -0.5])
            cylinder(d = hex_sw / cos(30), h = hex_h + 0.5, $fn = 6);
        // M5-Durchgang
        translate([0, 0, -0.5]) cylinder(d = gp_hole_d, h = knob_h + 1);
    }
}
