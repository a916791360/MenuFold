#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$DIR"

echo "==> 1. Generating App Icons..."
swift scripts/generate_icons.swift

echo "==> 2. Regenerating Xcode Project..."
swift scripts/generate_project.swift

echo "==> 3. Cleaning previous builds..."
rm -rf build release MenuFold.dmg MenuFold.zip

echo "==> 4. Building MenuFold (Universal Binary Release)..."
xcodebuild -project MenuFold.xcodeproj -target MenuFold -configuration Release build > /dev/null

APP_PATH="build/Release/MenuFold.app"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: App build failed!"
    exit 1
fi

mkdir -p release

echo "==> 5. Creating ZIP archive..."
ditto -c -k --keepParent "$APP_PATH" release/MenuFold.zip
cp release/MenuFold.zip MenuFold.zip

echo "==> 6. Creating DMG Installer..."
DMG_TMP="build/dmg_temp"
rm -rf "$DMG_TMP"
mkdir -p "$DMG_TMP"
cp -R "$APP_PATH" "$DMG_TMP/"
ln -s /Applications "$DMG_TMP/Applications"

hdiutil create -volname "MenuFold" -srcfolder "$DMG_TMP" -ov -format UDZO release/MenuFold.dmg > /dev/null
cp release/MenuFold.dmg MenuFold.dmg
rm -rf "$DMG_TMP"

echo "==> 7. Release Artifacts Generated:"
ls -lh release/

echo "==> Checksums:"
shasum -a 256 release/*

echo "==> Build complete!"
