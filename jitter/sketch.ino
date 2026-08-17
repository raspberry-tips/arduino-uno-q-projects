/*
 * 1-kHz-Puls-Test fuer den STM32U585 des Arduino UNO Q (v2)
 * ---------------------------------------------------------
 * Misst, wie puenktlich der Mikrocontroller einen 1-ms-Takt haelt.
 * Alle 5 Sekunden erscheint eine Statistik im Serial Monitor.
 *
 * WICHTIG (Lehre aus v1): Der Arduino-Unterbau auf Zephyr goennt sich
 * zwischen zwei loop()-Aufrufen rund eine Millisekunde. Ein Takt pro
 * loop()-Durchlauf kann deshalb nie 1 kHz erreichen. v2 misst darum
 * ein komplettes 5-Sekunden-Fenster INNERHALB eines loop()-Aufrufs
 * und gibt erst danach den Unterbau wieder frei.
 *
 * Lasttest: waehrend der Sketch laeuft, im Linux-Terminal des UNO Q:
 *     stress-ng --cpu 4 --timeout 60s
 *
 * Verwendung: App Lab -> neue App -> sketch/sketch.ino ersetzen -> Run.
 */

const uint32_t PERIOD_US = 1000;    // 1 ms Soll-Intervall
const uint32_t WINDOW_MS = 5000;    // Messfenster

void setup() {
  Serial.begin(115200);
}

void loop() {
  uint32_t count = 0;
  uint32_t maxDev = 0;
  uint64_t sumDev = 0;
  uint32_t windowEnd = millis() + WINDOW_MS;
  uint32_t next = micros() + PERIOD_US;

  while ((int32_t)(millis() - windowEnd) < 0) {
    while ((int32_t)(micros() - next) < 0) { }   // bis zum Soll-Zeitpunkt warten
    uint32_t dev = micros() - next;              // Verspaetung in us
    next += PERIOD_US;
    if (dev > maxDev) maxDev = dev;
    sumDev += dev;
    count++;
  }

  Serial.print("Ticks: ");
  Serial.print(count);
  Serial.print("   Jitter avg: ");
  Serial.print((float) sumDev / count, 2);
  Serial.print(" us   max: ");
  Serial.print(maxDev);
  Serial.println(" us");
}
