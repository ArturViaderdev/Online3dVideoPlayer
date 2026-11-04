#!/bin/sh
# Installs the native messaging host for Firefox / Chrome / Chromium / Brave and builds the
# browser extension in build/. Needs 3dvision-play (3dvisionvideoplayer) and the 3D Vision layer.
set -e
cd "$(dirname "$0")"
HOSTNAME=com.arturviader.threedvision
CHROME_ID=coknhafbjcjbcfdihfjffhcemngbkjek
DEST="$HOME/.local/lib/3dvision/online"
PLAYER="$HOME/.local/bin/3dvision-play"
mkdir -p "$DEST"
sed "s#@PLAYER@#$PLAYER#" native/3dvision_host.py > "$DEST/3dvision_host.py"
chmod +x "$DEST/3dvision_host.py"

# Firefox
mkdir -p "$HOME/.mozilla/native-messaging-hosts"
cat > "$HOME/.mozilla/native-messaging-hosts/$HOSTNAME.json" <<EOT
{
  "name": "$HOSTNAME",
  "description": "3D Vision Player (3dvision-play)",
  "path": "$DEST/3dvision_host.py",
  "type": "stdio",
  "allowed_extensions": ["3dvision@arturviader"]
}
EOT
# Chrome / Chromium / Brave
for d in "$HOME/.config/google-chrome" "$HOME/.config/chromium" "$HOME/.config/BraveSoftware/Brave-Browser"; do
  mkdir -p "$d/NativeMessagingHosts"
  cat > "$d/NativeMessagingHosts/$HOSTNAME.json" <<EOT
{
  "name": "$HOSTNAME",
  "description": "3D Vision Player (3dvision-play)",
  "path": "$DEST/3dvision_host.py",
  "type": "stdio",
  "allowed_origins": ["chrome-extension://$CHROME_ID/"]
}
EOT
done

# extension: build/chrome (unpacked) and build/3dvision-player-firefox.xpi
rm -rf build && mkdir -p build/chrome build/firefox
for b in chrome firefox; do
  cp -r extension/icons extension/bg.js "build/$b/"
  cp "extension/manifest.$b.json" "build/$b/manifest.json"
done
python3 - <<'EOT'
import os, zipfile
with zipfile.ZipFile("build/3dvision-player-firefox.xpi", "w", zipfile.ZIP_DEFLATED) as z:
    for root, _, files in os.walk("build/firefox"):
        for f in files:
            p = os.path.join(root, f)
            z.write(p, os.path.relpath(p, "build/firefox"))
EOT

echo "Native host -> $DEST/3dvision_host.py"
[ -x "$PLAYER" ] || echo "WARNING: $PLAYER not found: run ./install.sh in 3dvisionvideoplayer"
command -v yt-dlp >/dev/null || [ -x "$HOME/.local/bin/yt-dlp" ] || echo "WARNING: yt-dlp missing (see README)"
cat <<EOT

Extension:
  Firefox:  about:addons -> gear -> "Install Add-on From File" -> $(pwd)/build/3dvision-player-firefox.xpi
            (Firefox ESR / Developer: first set xpinstall.signatures.required = false in about:config)
  Chrome / Chromium / Brave: chrome://extensions -> Developer mode -> "Load unpacked" -> $(pwd)/build/chrome
EOT
