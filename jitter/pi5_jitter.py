# -*- coding: utf-8 -*-
"""1-kHz-Puls-Test fuer den Raspberry Pi (Userspace/Python).

Misst, wie puenktlich eine Schleife im Millisekundentakt laeuft.
Ausfuehren:
    python3 pi5_jitter.py          # Leerlauf
    stress-ng --cpu 4 --timeout 60s &   # in zweitem Terminal, dann:
    python3 pi5_jitter.py          # unter Volllast
"""
import time

PERIOD_NS = 1_000_000          # 1 ms Soll-Intervall
DURATION_S = 20

devs = []
next_t = time.perf_counter_ns() + PERIOD_NS
end = time.perf_counter_ns() + DURATION_S * 1_000_000_000
while time.perf_counter_ns() < end:
    remaining = next_t - time.perf_counter_ns()
    if remaining > 0:
        time.sleep(remaining / 1e9)     # so wartet ein normales Programm
    now = time.perf_counter_ns()
    devs.append(max(0, now - next_t))   # Verspaetung gegenueber Soll
    next_t += PERIOD_NS

devs_us = sorted(d / 1000 for d in devs)
n = len(devs_us)
print(f"Ticks:  {n}")
print(f"Jitter Durchschnitt: {sum(devs_us)/n:8.1f} us")
print(f"Jitter p99:          {devs_us[int(n*0.99)]:8.1f} us")
print(f"Jitter Maximum:      {devs_us[-1]:8.1f} us")
