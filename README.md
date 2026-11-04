<a id="english"></a>

# 3D Vision Player — watch YouTube (and other web) 3D videos with NVIDIA 3D Vision

**English** · [Español](#español)

A browser extension (Firefox, Chrome, Chromium, Brave) that sends the video you are watching to [**3dvision-play**](https://github.com/ArturViaderdev/3dvisionvideoplayer), which plays it in 3D with NVIDIA 3D Vision glasses through the [**3dvisionlinux**](https://github.com/ArturViaderdev/Nvidia3dVisionLinux) driver.

- **Toolbar button**: pauses the video on the page and continues it in 3D, full screen, **from the same second**. Format detected automatically (half SBS, full SBS, top-bottom).
- **Right-click menu → 3D Vision** (on the page, on the video or on a link): choose the format: Auto, Half SBS, Full SBS, Half / Full Top-Bottom.
- Works with YouTube and any site supported by **yt-dlp**. Quality up to 4K.

## Requirements

- [3dvisionlinux](https://github.com/ArturViaderdev/Nvidia3dVisionLinux) installed and working, and [`3dvision-play`](https://github.com/ArturViaderdev/3dvisionvideoplayer) (folder `3dvisionvideoplayer`, `./install.sh`).
- `mpv` and a **recent yt-dlp** (YouTube changes often; the distribution package is usually too old):
  ```sh
  sudo apt install mpv ffmpeg
  mkdir -p ~/.local/bin
  curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
  chmod +x ~/.local/bin/yt-dlp        # update later with: yt-dlp -U
  ```

## Installation

```sh
./install.sh
```

It installs the native messaging host (the small program the extension uses to start the player) for every browser and builds the extension in `build/`. Then add the extension:

- **Firefox**: `about:addons` → gear icon → *Install Add-on From File* → `build/3dvision-player-firefox.xpi`. The extension is not signed by Mozilla: on **Firefox ESR / Developer / Nightly** set `xpinstall.signatures.required = false` in `about:config` first (normal Firefox releases do not allow unsigned add-ons; there you can load it temporarily from `about:debugging` → *Load Temporary Add-on*).
- **Chrome / Chromium / Brave**: `chrome://extensions` → enable *Developer mode* → *Load unpacked* → folder `build/chrome`.

## Use

1. Monitor at 120 Hz (`tools/set-120hz.sh` from 3dvisionlinux) and desktop compositing off.
2. Open a 3D video (e.g. search YouTube for "3D SBS") and click the **3D Vision button** (green glasses). If the format is wrong, use the right-click menu → *3D Vision* → *Half SBS* / *Full SBS*...
3. Player keys: **space** pause, **← →** ±5 s, **9 / 0** volume, **q** back to the browser.

Without the extension: `3dvision-play "https://www.youtube.com/watch?v=..."`

## Troubleshooting

- Red **!** on the button: hover it to see the error. *native host not installed* → run `./install.sh` and restart the browser.
- Log: `~/.config/3dvision/logs/online-player.log` (the player's output for each video).
- Video does not start / "Requested format is not available": update yt-dlp (`yt-dlp -U`).
- Firefox from **Snap or Flatpak** cannot start native hosts by default: use the `.deb` Firefox (Debian's `firefox-esr`).

## Files

```
extension/bg.js                  extension logic (shared by both browsers)
extension/manifest.*.json        Firefox and Chrome manifests
native/3dvision_host.py          native messaging host -> 3dvision-play
install.sh / uninstall.sh
```

---

<a id="español"></a>

# 3D Vision Player — ver vídeos 3D de YouTube (y otras webs) con NVIDIA 3D Vision

[English](#english) · **Español**

Extensión de navegador (Firefox, Chrome, Chromium, Brave) que envía el vídeo que estás viendo a [**3dvision-play**](https://github.com/ArturViaderdev/3dvisionvideoplayer), que lo reproduce en 3D con las gafas NVIDIA 3D Vision a través del driver [**3dvisionlinux**](https://github.com/ArturViaderdev/Nvidia3dVisionLinux).

- **Botón en la barra**: pausa el vídeo de la página y lo continúa en 3D, a pantalla completa, **desde el mismo segundo**. El formato se detecta solo (half SBS, SBS completo, arriba/abajo).
- **Menú del botón derecho → 3D Vision** (sobre la página, el vídeo o un enlace): eliges el formato: Auto, Half SBS, Full SBS, Half / Full Top-Bottom.
- Funciona con YouTube y con cualquier web que admita **yt-dlp**. Calidad hasta 4K.

## Requisitos

- [3dvisionlinux](https://github.com/ArturViaderdev/Nvidia3dVisionLinux) instalado y funcionando, y [`3dvision-play`](https://github.com/ArturViaderdev/3dvisionvideoplayer) (carpeta `3dvisionvideoplayer`, `./install.sh`).
- `mpv` y un **yt-dlp reciente** (YouTube cambia a menudo; el paquete de la distribución suele estar viejo):
  ```sh
  sudo apt install mpv ffmpeg
  mkdir -p ~/.local/bin
  curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
  chmod +x ~/.local/bin/yt-dlp        # actualizarlo luego: yt-dlp -U
  ```

## Instalación

```sh
./install.sh
```

Instala el *native messaging host* (el pequeño programa con el que la extensión lanza el reproductor) para todos los navegadores y prepara la extensión en `build/`. Después añade la extensión:

- **Firefox**: `about:addons` → engranaje → *Instalar complemento desde archivo* → `build/3dvision-player-firefox.xpi`. La extensión no está firmada por Mozilla: en **Firefox ESR / Developer / Nightly** pon antes `xpinstall.signatures.required = false` en `about:config` (el Firefox normal no admite complementos sin firmar; ahí se puede cargar temporalmente desde `about:debugging` → *Cargar complemento temporal*).
- **Chrome / Chromium / Brave**: `chrome://extensions` → activar *Modo desarrollador* → *Cargar descomprimida* → carpeta `build/chrome`.

## Uso

1. Monitor a 120 Hz (`tools/set-120hz.sh` de 3dvisionlinux) y compositor desactivado.
2. Abre un vídeo 3D (p. ej. busca en YouTube "3D SBS") y pulsa el **botón 3D Vision** (gafas verdes). Si el formato no es el correcto, usa el botón derecho → *3D Vision* → *Half SBS* / *Full SBS*...
3. Teclas del reproductor: **espacio** pausa, **← →** ±5 s, **9 / 0** volumen, **q** volver al navegador.

Sin la extensión: `3dvision-play "https://www.youtube.com/watch?v=..."`

## Problemas

- **!** rojo en el botón: pasa el ratón por encima para ver el error. *native host not installed* → ejecuta `./install.sh` y reinicia el navegador.
- Registro: `~/.config/3dvision/logs/online-player.log` (la salida del reproductor de cada vídeo).
- El vídeo no arranca / "Requested format is not available": actualiza yt-dlp (`yt-dlp -U`).
- Firefox en **Snap o Flatpak** no puede lanzar programas nativos por defecto: usa el Firefox en `.deb` (el `firefox-esr` de Debian).

## Archivos

```
extension/bg.js                  lógica de la extensión (común a los dos navegadores)
extension/manifest.*.json        manifiestos de Firefox y Chrome
native/3dvision_host.py          programa puente -> 3dvision-play
install.sh / uninstall.sh
```
