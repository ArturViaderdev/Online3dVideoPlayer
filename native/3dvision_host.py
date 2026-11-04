#!/usr/bin/env python3
# Native messaging host of the "3D Vision Player" browser extension: receives
# {"url": ..., "layout": "auto|half|full|tab|htab", "start": seconds} and starts 3dvision-play.
import json
import os
import shutil
import struct
import subprocess
import sys

PLAYER = "@PLAYER@"  # filled in by install.sh
LAYOUTS = {"auto", "half", "full", "tab", "htab"}


def read_msg():
    raw = sys.stdin.buffer.read(4)
    if len(raw) < 4:
        sys.exit(0)
    n = struct.unpack("=I", raw)[0]
    return json.loads(sys.stdin.buffer.read(n).decode("utf-8"))


def send(obj):
    data = json.dumps(obj).encode("utf-8")
    sys.stdout.buffer.write(struct.pack("=I", len(data)) + data)
    sys.stdout.buffer.flush()


def main():
    msg = read_msg()
    url = str(msg.get("url", ""))
    layout = str(msg.get("layout", "auto"))
    try:
        start = float(msg.get("start", 0) or 0)
    except (TypeError, ValueError):
        start = 0.0
    if not (url.startswith("http://") or url.startswith("https://")) or any(c in url for c in "\n\r\0"):
        send({"ok": False, "error": "not a web URL"})
        return
    if layout not in LAYOUTS:
        layout = "auto"
    home = os.path.expanduser("~")
    player = PLAYER if os.path.isfile(PLAYER) else (
        shutil.which("3dvision-play") or os.path.join(home, ".local/bin/3dvision-play"))
    if not os.path.isfile(player):
        send({"ok": False, "error": "3dvision-play not installed"})
        return
    args = [player]
    if layout != "auto":
        args.append("--" + layout)
    if start > 2:
        args.append("--start=%d" % int(start))
    args.append(url)  # argument list, no shell: the URL is never interpreted
    env = os.environ.copy()
    env["PATH"] = os.path.join(home, ".local/bin") + ":" + env.get("PATH", "/usr/bin:/bin")
    logdir = os.path.join(os.environ.get("XDG_CONFIG_HOME", os.path.join(home, ".config")), "3dvision", "logs")
    os.makedirs(logdir, exist_ok=True)
    log = open(os.path.join(logdir, "online-player.log"), "a")
    log.write("\n== %s\n" % " ".join(args))
    log.flush()
    subprocess.Popen(args, stdin=subprocess.DEVNULL, stdout=log, stderr=log, env=env, start_new_session=True)
    send({"ok": True})


if __name__ == "__main__":
    main()
