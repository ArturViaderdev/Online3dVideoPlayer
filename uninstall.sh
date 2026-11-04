#!/bin/sh
HOSTNAME=com.arturviader.threedvision
rm -f "$HOME/.mozilla/native-messaging-hosts/$HOSTNAME.json"
for d in "$HOME/.config/google-chrome" "$HOME/.config/chromium" "$HOME/.config/BraveSoftware/Brave-Browser"; do
  rm -f "$d/NativeMessagingHosts/$HOSTNAME.json"
done
rm -rf "$HOME/.local/lib/3dvision/online"
echo "Native host removed. Remove the extension from the browser's add-on page."
