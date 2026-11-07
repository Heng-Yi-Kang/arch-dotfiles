#!/usr/bin/env python3
"""Display the connected Wi-Fi SSID as a fixed-width scrolling marquee."""

import json
import subprocess
import sys
import time

VISIBLE_CHARS = 16
FRAME_DELAY = 0.3
NETWORK_CHECK_INTERVAL = 2.0

ssid = ""
last_check = 0.0
offset = 0

while True:
    now = time.monotonic()
    if now - last_check >= NETWORK_CHECK_INTERVAL:
        last_check = now
        try:
            result = subprocess.run(
                ["nmcli", "-t", "--escape", "no", "-f", "IN-USE,SSID", "device", "wifi"],
                capture_output=True,
                text=True,
                check=False,
            )
            connected = next(
                (line.split(":", 1)[1] for line in result.stdout.splitlines() if line.startswith("*:")),
                "",
            )
        except (OSError, IndexError):
            connected = ""

        if connected != ssid:
            ssid = connected
            offset = 0

    if len(ssid) <= VISIBLE_CHARS:
        text = ssid
    else:
        loop = ssid + "   "
        text = (loop + loop)[offset : offset + VISIBLE_CHARS]
        offset = (offset + 1) % len(loop)

    print(json.dumps({"text": text}), flush=True)
    time.sleep(FRAME_DELAY)
