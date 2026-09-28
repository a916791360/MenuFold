# MenuFold

<p align="center">
  <img src="MenuFold/Resources/Assets.xcassets/AppIcon.appiconset/icon_256x256.png" width="128" height="128" alt="MenuFold Icon">
</p>

<p align="center">
  <strong>An ultra-light, open-source macOS menu bar organizer designed for MacBook notch screens</strong>
</p>

<p align="center">
  <a href="https://github.com/a916791360/MenuFold/releases/latest"><img src="https://img.shields.io/github/v/release/a916791360/MenuFold?color=blue&label=Release" alt="Latest Release"></a>
  <img src="https://img.shields.io/badge/Platform-macOS%2014.0%2B%20%7C%2015.0%2B%20%7C%2016.0%2B-blueviolet" alt="Platform">
  <img src="https://img.shields.io/badge/Architecture-Universal%20(Apple%20Silicon%20%2B%20Intel)-brightgreen" alt="Architecture">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
  <a href="README.md"><img src="https://img.shields.io/badge/Language-%E4%B8%AD%E6%96%87-blue" alt="Chinese"></a>
</p>

---

## 💡 Why MenuFold?

Modern MacBooks feature a camera notch in the top center of the display. When numerous menu bar items accumulate (messaging apps, cloud drives, system monitors, VPNs), icons on the left are frequently **occluded by the notch** or pushed completely off-screen, making them unreachable.

**MenuFold** provides a minimalist, native fold-away solution:
1. After launching, a folding arrow `<` and a separator `|` appear in your menu bar.
2. Hold **`⌘ (Command)`** on your keyboard and drag any icon you want to hide to the left of the separator.
3. Click the arrow: all icons to its left instantly tuck away into the arrow. Click again anytime to expand them!

Zero dangerous accessibility permissions needed, pure Swift + AppKit, no memory leaks, ultra-lightweight (~30MB memory, 0% idle CPU).

---

## ✨ Features

- 🎯 **Native ⌘ + Drag Organization**: Uses macOS native menu bar arrangement (`⌘` + drag).
- 🪄 **One-Click Fold & Unfold**: Instantly collapse excess items behind the arrow to eliminate notch occlusion.
- ⚡ **Zero Permissions & Ultra-Light**: No accessibility or screen recording permissions required; safe and non-intrusive.
- 🚀 **Modern macOS 15+ Architecture**:
  - Uses modern `SMAppService` for launch-at-login (no legacy helper daemons).
  - Fully compatible with macOS 14, macOS 15 Sequoia, and newer.
  - Universal binary (`arm64` Apple Silicon + `x86_64` Intel).
- ⌨️ **Global Shortcut**: Press `⌘ + ⌥ + B` anywhere to quickly toggle menu bar fold state.
- ⏱️ **Auto-Collapse Timer**: Optionally auto-collapse after 5s, 10s, 15s, or 30s.
- 🎨 **Appearance Customization**:
  - Arrow styles: Classic Chevron (`< / >`), Filled Triangle (`◀ / ▶`), Circle Badge.
  - Separators: Subtle Line, Dot, or Completely Hidden (Option-click arrow to toggle).
- 🔒 **Always-Hidden Section**: Optional second separator for items you want to keep permanently hidden.

---

## 📥 Installation

### Option 1: Download Release (Recommended)

1. Go to the [GitHub Releases Page](https://github.com/a916791360/MenuFold/releases/latest).
2. Download `MenuFold.dmg` or `MenuFold.zip`.
3. Open `MenuFold.dmg` and drag **MenuFold.app** to your **Applications** folder.
4. **Gatekeeper Notice**: As a free and open-source project without Apple's paid Developer Certificate, macOS may prompt "Cannot verify developer" on first launch:
   - **Option A (System Settings)**: Open `System Settings` → `Privacy & Security`, scroll down to Security, and click **"Open Anyway"**.
   - **Option B (Right-Click Open)**: Hold `Control` and right-click `MenuFold.app`, select "Open", and click "Open" in the dialog.
   - **Option C (Terminal)**:
     ```bash
     xattr -cr /Applications/MenuFold.app
     ```

### Option 2: Build from Source

```bash
git clone https://github.com/a916791360/MenuFold.git
cd MenuFold

# Build release artifacts (DMG + ZIP)
./scripts/build_release.sh
```

Or open directly in Xcode:
```bash
open MenuFold.xcodeproj
```

---

## ⚙️ Shortcuts & Tips

| Action | Function |
| :--- | :--- |
| **Click Arrow (`<` / `>`)** | Toggle Fold / Expand |
| **Option + Click Arrow** | Quickly Show / Hide Separator line |
| **Right-click Arrow or Separator** | Open Context Menu (Preferences, Auto-collapse, Quit) |
| **⌘ + ⌥ + B** | Global hotkey to toggle fold state anywhere |
| **Hold ⌘ and Drag** | Rearrange any status bar item |

---

## 📄 License

This project is licensed under the [MIT License](LICENSE). Contributions, bug reports, and pull requests are welcome!
