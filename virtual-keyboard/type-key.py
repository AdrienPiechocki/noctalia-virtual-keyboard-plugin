import subprocess
import sys
import time
import re
import os
import json
import glob

# ---------- CONSTANTS ----------
SPECIAL_KEYS = {
    "return": 28, "space": 57, "tab": 15, "backspace": 14, "esc": 1,
    "left": 105, "up": 103, "right": 106, "down": 108, "caps": 58, "*": 55,
    "backslash": 43, "grave": 41
}

MODIFIER_KEYS = {
    "shift": 42, "ctrl": 29, "alt": 56, "super": 125
}

AZERTY_TO_QWERTY = {
    "a":"q","z":"w","q":"a","w":"z","m":";",
    "&":"1","é":"2",'"':"3","'":"4","(":"5","-":"6","è":"7","_":"8","ç":"9","à":"0",
    ")":"-","^":"[","$":"]","ù":"'",",":"m",";":",",":":".","!":"/"
}

# ---------- SYSTEM HELPERS ----------
def run(cmd):
    subprocess.run(cmd, capture_output=False)

def check_ydotool_service():
    try:
        status = subprocess.run(
            ["systemctl", "--user", "is-active", "ydotool.service"],
            capture_output=True, text=True
        ).stdout.strip()
        if status != "active":
            print("[INFO] Starting ydotool service...")
            run(["systemctl", "--user", "start", "ydotool.service"])
            time.sleep(1)
    except:
        sys.exit("[ERROR] Could not manage ydotool service")

# ---------- KEY ACTIONS ----------
def press_key(code, down=True):
    run(["ydotool", "key", f"{code}:{1 if down else 0}"])

def apply_layout(key, layout):
    return AZERTY_TO_QWERTY.get(key.lower(), key) if layout == "azerty" else key

# ---------- SEND KEY ----------
def send_key(layout, key, modifiers):
    _key = apply_layout(key, layout)

    # Press modifiers
    for m in modifiers:
        if m in MODIFIER_KEYS:
            press_key(MODIFIER_KEYS[m], True)

    # Special key
    if _key in SPECIAL_KEYS:
        code = SPECIAL_KEYS[_key]
        press_key(code, True)
        press_key(code, False)
    else:
        # Regular text
        run(["ydotool", "type", _key])

    print(f"Sent: {' '.join(modifiers)} {_key}")

    # Release modifiers
    for m in reversed(modifiers):
        if m in MODIFIER_KEYS:
            press_key(MODIFIER_KEYS[m], False)

# ---------- RESET ----------
def reset():

    # Release all toggled modifiers
    for key, value in MODIFIER_KEYS.items():
        press_key(value, False)

    # Reset CapsLock LED if needed
    caps_paths = glob.glob("/sys/class/leds/input*::capslock/brightness")
    if not caps_paths:
        return

    caps_file = caps_paths[0]
    if open(caps_file).read().strip() == "1":
        press_key(SPECIAL_KEYS["caps"], True)
        press_key(SPECIAL_KEYS["caps"], False)

# ---------- MAIN ----------
if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python type-key.py <layout> <key_or_text> [modifiers...]")
        sys.exit(1)

    layout = sys.argv[1]
    key = sys.argv[2]
    mods = [m.lower() for m in sys.argv[3:]]

    if key == "reset":
        reset()
        sys.exit(0)

    check_ydotool_service()
    send_key(layout, key.lower(), mods)
