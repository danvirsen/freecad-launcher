#!/usr/bin/env bash
# Build "FreeCAD Smart Launcher.app" and a .dmg with PyInstaller.
# Run on a Mac. The .app matches the CPU architecture of the Python you use
# (build on Apple Silicon for arm64, on an Intel Mac / Rosetta Python for x86_64).
#
# Optional variables: VERSION=0.0.2  ICON_SRC=icon.png
set -euo pipefail
cd "$(dirname "$0")"

APP_NAME="FreeCAD Smart Launcher"
VERSION="${VERSION:-dev}"
ICON_SRC="${ICON_SRC:-icon.png}"
ARCH="$(uname -m)"
VENV=".build-venv"

python3 -m venv "$VENV"
# shellcheck disable=SC1091
source "$VENV/bin/activate"
pip install --upgrade pip >/dev/null
pip install PySide6-Essentials pyinstaller certifi

# .icns from the PNG icon
ICON_ARGS=()
if [ -f "$ICON_SRC" ]; then
  rm -rf build/icon.iconset && mkdir -p build/icon.iconset
  for s in 16 32 128 256 512; do
    sips -z $s $s "$ICON_SRC" --out "build/icon.iconset/icon_${s}x${s}.png" >/dev/null
    sips -z $((s*2)) $((s*2)) "$ICON_SRC" --out "build/icon.iconset/icon_${s}x${s}@2x.png" >/dev/null
  done
  iconutil -c icns build/icon.iconset -o build/icon.icns
  ICON_ARGS=(--icon build/icon.icns --add-data "$ICON_SRC:.")
fi

pyinstaller --noconfirm --clean --windowed \
  --name "$APP_NAME" \
  --osx-bundle-identifier org.deltahedra.freecad-launcher \
  --collect-data certifi \
  "${ICON_ARGS[@]}" \
  freecad_smart_launcher.py

# Ad-hoc signature so Apple Silicon will run it (not notarized)
codesign --force --deep --sign - "dist/$APP_NAME.app"

DMG="dist/FreeCAD_Smart_Launcher-${VERSION}-macOS-${ARCH}.dmg"
rm -f "$DMG"
STAGE="$(mktemp -d)"
cp -R "dist/$APP_NAME.app" "$STAGE/"
ln -s /Applications "$STAGE/Applications"
hdiutil create -volname "$APP_NAME" -srcfolder "$STAGE" -ov -format UDZO "$DMG" >/dev/null
rm -rf "$STAGE"

echo "Built: dist/$APP_NAME.app"
echo "Built: $DMG"
