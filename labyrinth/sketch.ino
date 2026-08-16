/*
 * Kugellabyrinth auf dem Arduino UNO Q
 * ------------------------------------
 * Neigt das Board, um die Kugel durch das Labyrinth auf der
 * 8x13-LED-Matrix zu balancieren - vorbei an den Loechern bis zum Ziel.
 * Der Modulino Movement (IMU am Qwiic-Port) liefert die Neigung,
 * der STM32 rechnet Physik und Anzeige in Echtzeit.
 *
 * Anzeige (8 Helligkeitsstufen):
 *   Wand   = gedimmt dauerhaft an
 *   Loch   = pulsiert schwach
 *   Ziel   = pulsiert hell
 *   Kugel  = volle Helligkeit
 *
 * Hardware: Arduino UNO Q + Modulino Movement am Qwiic-Kabel.
 *
 * Verwendung in Arduino App Lab:
 *   My Apps -> "Create new app +" -> Inhalt von sketch/sketch.ino ersetzen.
 *   WICHTIG: Die Bibliothek Arduino_Modulino muss ins Build-Profil der App -
 *   dazu in sketch/sketch.yaml unter dem default-Profil den libraries-Block
 *   aus der README dieses Ordners ergaenzen (oder ueber die Sketch
 *   Libraries der App hinzufuegen). Dann Run.
 *
 * Kalibrierung: Rollt die Kugel in die falsche Richtung, unten bei
 * INVERT_X / INVERT_Y / SWAP_AXES die Werte anpassen.
 */

#include <Arduino_LED_Matrix.h>
#include <Arduino_Modulino.h>

Arduino_LED_Matrix matrix;
ModulinoMovement movement;

// ------------------------- Kalibrierung ------------------------------------
const bool SWAP_AXES = false;  // true, wenn links/rechts und vor/zurueck vertauscht sind
const int  INVERT_X  = 1;      // -1, wenn die Kugel spiegelverkehrt nach links/rechts rollt
const int  INVERT_Y  = 1;      // -1, wenn vor/zurueck vertauscht ist

// ------------------------- Spiel-Tuning ------------------------------------
const float ACCEL    = 0.045;  // Beschleunigung pro g und Tick
const float FRICTION = 0.90;   // Reibung (naeher an 1 = rutschiger)
const float VMAX     = 0.40;   // Maximaltempo (Zellen pro Tick)
const float DEADZONE = 0.03;   // g-Werte darunter ignorieren
const int   TICK_MS  = 20;     // 50 Physik-Ticks pro Sekunde

// ------------------------- Level -------------------------------------------
// 13 Spalten x 8 Zeilen: S=Start, G=Ziel, #=Wand, O=Loch, .=frei
const char* LEVELS[][8] = {
  {
    "S............",
    ".....#.......",
    ".....#...O...",
    ".....#.......",
    "..O..#....##.",
    ".....#.......",
    ".....#...#...",
    ".........#.G.",
  },
  {
    "S...#........",
    "..O.#..O.#...",
    "....#....#.O.",
    ".#..#.##.#...",
    ".#....#..#...",
    ".#.O..#..#.O.",
    ".#....#......",
    "....O.#....G.",
  },
  {
    "S.#......O...",
    "..#.####.....",
    "....#..#.###.",
    ".##.#.O#...#.",
    "..#.#..###...",
    "O.#.#.....#..",
    "..#.###.##.#.",
    "......O....G.",
  },
};
const int NUM_LEVELS = sizeof(LEVELS) / sizeof(LEVELS[0]);

// ------------------------- Helligkeiten (0-7) ------------------------------
const uint8_t B_WALL = 2;
const uint8_t B_BALL = 7;

const int COLS = 13;
const int ROWS = 8;

int   level = 0;
char  grid[ROWS][COLS];
float px, py, vx, vy;     // Position/Geschwindigkeit der Kugel (Zellen)
int   startX, startY;
uint32_t tick = 0;

uint8_t frame[ROWS * COLS];

void loadLevel(int n) {
  for (int y = 0; y < ROWS; y++) {
    for (int x = 0; x < COLS; x++) {
      char c = LEVELS[n][y][x];
      if (c == 'S') { startX = x; startY = y; c = '.'; }
      grid[y][x] = c;
    }
  }
  px = startX; py = startY; vx = 0; vy = 0;
}

bool isWall(int x, int y) {
  if (x < 0 || x >= COLS || y < 0 || y >= ROWS) return true;  // Rand = Wand
  return grid[y][x] == '#';
}

void render(bool showBall) {
  uint8_t pulse  = (tick / 12) % 2;                 // langsames Pulsieren
  uint8_t goalB  = 3 + ((tick / 6) % 5);            // Ziel: 3..7
  for (int y = 0; y < ROWS; y++) {
    for (int x = 0; x < COLS; x++) {
      uint8_t b = 0;
      char c = grid[y][x];
      if (c == '#') b = B_WALL;
      else if (c == 'O') b = pulse;                 // Loch blinkt schwach
      else if (c == 'G') b = goalB;
      frame[y * COLS + x] = b;
    }
  }
  if (showBall) frame[(int)(py + 0.5f) * COLS + (int)(px + 0.5f)] = B_BALL;
  matrix.draw(frame);
}

void animBlinkBall(int times) {                     // Kugel gefallen
  for (int i = 0; i < times; i++) {
    render(false); delay(140);
    render(true);  delay(140);
  }
}

void animWin() {                                    // Ziel erreicht: Welle
  for (int x = 0; x < COLS + 8; x++) {
    for (int y = 0; y < ROWS; y++) {
      for (int c = 0; c < COLS; c++) {
        int d = x - c - y;
        frame[y * COLS + c] = (d >= 0 && d < 3) ? 7 : 0;
      }
    }
    matrix.draw(frame);
    delay(35);
  }
}

void setup() {
  Serial.begin(115200);
  matrix.begin();
  matrix.setGrayscaleBits(3);     // 8 Helligkeitsstufen
  Modulino.begin(Wire1);          // Qwiic-Port des UNO Q haengt an Wire1
  movement.begin();
  loadLevel(level);
}

void loop() {
  movement.update();
  float ax = movement.getX();
  float ay = movement.getY();
  if (SWAP_AXES) { float t = ax; ax = ay; ay = t; }
  ax *= INVERT_X;
  ay *= INVERT_Y;
  if (ax > -DEADZONE && ax < DEADZONE) ax = 0;
  if (ay > -DEADZONE && ay < DEADZONE) ay = 0;

  // Physik
  vx = (vx + ax * ACCEL) * FRICTION;
  vy = (vy + ay * ACCEL) * FRICTION;
  vx = constrain(vx, -VMAX, VMAX);
  vy = constrain(vy, -VMAX, VMAX);

  // Achsenweise bewegen, Waende stoppen (kleiner Abpraller)
  float nx = px + vx;
  if (isWall((int)(nx + 0.5f), (int)(py + 0.5f))) { vx = -vx * 0.3f; }
  else { px = nx; }
  float ny = py + vy;
  if (isWall((int)(px + 0.5f), (int)(ny + 0.5f))) { vy = -vy * 0.3f; }
  else { py = ny; }

  int cx = (int)(px + 0.5f);
  int cy = (int)(py + 0.5f);
  char cell = grid[cy][cx];

  if (cell == 'O') {                       // ins Loch gefallen
    animBlinkBall(3);
    px = startX; py = startY; vx = 0; vy = 0;
  } else if (cell == 'G') {                // Ziel!
    animWin();
    level = (level + 1) % NUM_LEVELS;
    loadLevel(level);
  }

  render(true);
  tick++;
  delay(TICK_MS);
}
