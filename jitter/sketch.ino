/*
 * 1-kHz-Puls-Test fuer den STM32U585 des Arduino UNO Q
 * -----------------------------------------------------
 * Misst, wie puenktlich der Mikrocontroller seine Schleife im
 * Millisekundentakt ausfuehrt. Alle 5 Sekunden erscheint eine
 * Statistik im Serial Monitor (App Lab, Tab "Serial Monitor").
 *
 * Fuer den Lasttest: waehrend der Sketch laeuft, im Linux-Terminal
 * des UNO Q (App Lab, >_-Symbol) starten:
 *     stress-ng --cpu 4 --timeout 60s
 * -> Die Linux-Seite ackert auf 100 %, die Werte des STM32
 *    bleiben unveraendert. Genau das ist Echtzeit.
 *
 * Verwendung: App Lab -> neue App -> sketch/sketch.ino ersetzen -> Run.
 */

const uint32_t PERIOD_US = 1000;   // 1 ms Soll-Intervall

uint32_t next_us;
uint32_t count = 0;
uint32_t maxDev = 0;
uint64_t sumDev = 0;
uint32_t lastReport;

void setup() {
  Serial.begin(115200);
  next_us = micros() + PERIOD_US;
  lastReport = millis();
}

void loop() {
  while ((int32_t)(micros() - next_us) < 0) { }   // bis zum Soll-Zeitpunkt warten
  uint32_t dev = micros() - next_us;              // Verspaetung in us
  next_us += PERIOD_US;

  if (dev > maxDev) maxDev = dev;
  sumDev += dev;
  count++;

  if (millis() - lastReport >= 5000) {
    Serial.print("Ticks: ");
    Serial.print(count);
    Serial.print("   Jitter avg: ");
    Serial.print((float) sumDev / count, 2);
    Serial.print(" us   max: ");
    Serial.print(maxDev);
    Serial.println(" us");
    count = 0; sumDev = 0; maxDev = 0;
    lastReport = millis();
  }
}
