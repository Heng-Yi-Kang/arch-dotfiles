#!/usr/bin/env python3
"""Show basic active network details in a desktop notification."""

import subprocess


def nmcli(*args):
    result = subprocess.run(
        ["nmcli", "-t", "--escape", "no", *args],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        return ""
    return result.stdout.strip()


def main():
    devices = []
    for line in nmcli("-f", "DEVICE,TYPE,STATE,CONNECTION", "device", "status").splitlines():
        fields = line.split(":", 3)
        if len(fields) == 4 and fields[2] == "connected":
            devices.append(fields)

    # Prefer Wi-Fi when it is active; otherwise report another active connection.
    active = next((device for device in devices if device[1] == "wifi"), None)
    if active is None and devices:
        active = devices[0]

    if active is None:
        title = "Network disconnected"
        message = "No active network connection"
    else:
        device, kind, _state, connection = active
        address = nmcli("-g", "IP4.ADDRESS", "device", "show", device).splitlines()
        gateway = nmcli("-g", "IP4.GATEWAY", "device", "show", device).splitlines()
        details = [f"Interface: {device}"]
        if address and address[0]:
            details.append(f"IP address: {address[0]}")
        if gateway and gateway[0]:
            details.append(f"Gateway: {gateway[0]}")

        icon = "network-wired"
        if kind == "wifi":
            icon = "network-wireless"
            ssid = ""
            for line in nmcli("-f", "IN-USE,SSID,SIGNAL", "device", "wifi").splitlines():
                fields = line.split(":")
                if fields[0] == "*" and len(fields) >= 3:
                    ssid = ":".join(fields[1:-1])
                    details.insert(0, f"Signal: {fields[-1]}%")
                    break
            title = f"Wi-Fi · {ssid or connection or 'Connected'}"
        else:
            title = f"Network · {connection or 'Connected'}"
        message = "\n".join(details)

    subprocess.run(
        ["notify-send", "--app-name=Waybar", f"--icon={icon if active else 'network-offline'}", title, message],
        check=False,
    )


if __name__ == "__main__":
    main()
