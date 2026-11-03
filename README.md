# MenuFold (菜单折叠)

<p align="center">
  <img src="MenuFold/Resources/Assets.xcassets/AppIcon.appiconset/icon_256x256.png" width="128" height="128" alt="MenuFold Icon">
</p>

<p align="center">
  <strong>专为 MacBook 刘海屏打造的超轻量开源菜单栏折叠与管理工具</strong><br>
  <sub>⌘ 拖拽折叠 · 悬停气泡抽屉 · 找回遮挡图标 · 零权限纯原生 Swift</sub>
</p>

<p align="center">
  <b>简体中文</b> | <a href="README_EN.md">English</a>
</p>

<p align="center">
  <a href="https://github.com/a916791360/MenuFold/releases/latest"><img src="https://img.shields.io/github/v/release/a916791360/MenuFold?color=blue&label=Release" alt="Latest Release"></a>
  <img src="https://img.shields.io/badge/Platform-macOS%2014.0%2B%20%7C%2015.0%2B%20%7C%2016.0%2B-blueviolet" alt="Platform">
  <img src="https://img.shields.io/badge/Architecture-Universal%20(Apple%20Silicon%20%2B%20Intel)-brightgreen" alt="Architecture">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
</p>

---

## 💡 为什么开发 MenuFold？

现在的 MacBook 几乎都配有前置摄像头刘海（Notch）。当我们在菜单栏常驻了较多应用（如微信、飞书、输入法、监控插件、VPN、网盘等）时，左侧的图标极容易**被刘海无情遮挡**，甚至直接被系统挤出屏幕导致无法点击，带来极差的使用体验。

**MenuFold** 提供双重优雅方案，彻底终结刘海遮挡烦恼：
1. **⌘ 拖拽折叠收纳**：按住键盘 **`⌘ (Command)`** 键将图标拖拽至分隔线左侧，点击箭头一键折叠，多余图标立刻收进箭头中，让菜单栏恢复清爽。
2. **常驻应用气泡抽屉 (v1.1.0)**：当常驻软件太多超出屏幕右侧空间时，鼠标**悬停或点击分割线**秒开气泡面板，所有被刘海挤出屏幕的后台小工具（电脑管家、输入法、监控插件等）与标准应用一览无余，支持一键打开与即时搜索！

无需授予危险的辅助功能权限，纯原生 Swift + AppKit 实现，零内存泄漏，极致轻量（~30MB 内存占用，0% 常驻 CPU）。

---

## ✨ 核心特性

- 🎯 **原生 ⌘ + 拖拽收纳**：遵循 macOS 原生菜单栏重排机制，按住 `⌘` 随心拖动排序。
- 🪄 **一键折叠 / 展开**：轻点菜单栏箭头，多余图标立刻折叠，彻底告别刘海屏遮挡。
- 🫧 **常驻应用气泡抽屉 (v1.1.0 新增)**：
  - 即使图标过多超出刘海物理限制，鼠标**悬停或单击分割线**即可秒开应用气泡抽屉！
  - 自动归集所有后台小工具（如腾讯电脑管家、状态监控等）与标准应用。
  - 支持快捷搜索、点击置顶唤醒窗口、右键访达定位与退出管理。
- ⚡ **超轻量与零权限**：无需任何无障碍权限或辅助功能权限，不常驻后台常态守护进程，绿色安全。
- 🚀 **现代架构**：
  - 基于最新 `SMAppService` 原生开机自启，告别传统旧版 Launcher 守护进程。
  - 完美适配 macOS 14 / macOS 15 Sequoia 及更高版本，解决老旧工具内存暴涨问题。
  - 支持全架构 Universal Binary（Apple Silicon M1/M2/M3/M4/M5 + Intel 芯片）。
- ⌨️ **全局快捷键**：支持全局热键 `⌘ + ⌥ + B`（Command + Option + B），键盘随手一击即可收拢展开。
- ⏱️ **智能自动折叠**：支持配置展开后 5s / 10s / 15s / 30s 自动折叠，用完即收，清爽无扰。
- 🔄 **智能自动检查更新**：基于 GitHub Release API 原生检测，支持右键一键检查更新，发现新版本弹窗直达下载。
- 🎨 **外观与灵敏度定制**：
  - 箭头样式自由切换（经典折叠箭头 `< / >`、实心三角 `◀ / ▶`、极简圆环）。
  - 分隔线可选细线 `|`、圆点 `•` 或完全隐藏（Option + 点击箭头快速隐藏/显示分隔符）。
  - 应用气泡抽屉支持自定义悬停灵敏度（灵敏 0.15s / 适中 0.25s / 平缓 0.50s / 仅单击）与触发感应区。
- 🔒 **永久隐藏专区**：可选开启第二道分隔线，将不常用的图标放置其后，即便展开也不会暴露。

---

## 🖥 界面与使用示意

```text
[折叠隐藏区]              [分隔线]  [折叠箭头]       [常驻可见区]
[微信] [网盘] [监控插件]  │   |   │     <     │  [Wi-Fi] [电池] [控制中心] [时间]
───────────────────────────────────────────────────────────────────────
                      ▼ 点击箭头折叠 ▼
[Notch 刘海]                      │     >     │  [Wi-Fi] [电池] [控制中心] [时间]
```

### 3步上手指南：
1. **启动 MenuFold**：菜单栏会出现一个折叠箭头 `<` 和一道细分隔线 `|`。
2. **整理图标**：按住键盘 `⌘` 键，按住鼠标左键拖动菜单栏图标。
   - 拖拽到**分隔线左侧**：归入折叠区，折叠时隐藏。
   - 拖拽到**分隔线右侧**：保持常驻，折叠时不隐藏。
3. **点击折叠**：点击箭头，隐藏区图标立即收纳，箭头变为 `>`；再次点击立即展开。

---

## 📥 下载与安装

### 方式一：下载发布包（推荐）

1. 前往 [GitHub Releases 最新发布页](https://github.com/a916791360/MenuFold/releases/latest)。
2. 下载 `MenuFold.dmg` 或 `MenuFold.zip`。
3. 双击打开 `MenuFold.dmg`，将 **MenuFold.app** 拖动到 **Applications**（应用程序）文件夹即可。
4. **首次打开安全提示说明**：MenuFold 为免费开源软件，未购买苹果付费开发者证书。首次通过浏览器下载打开时，macOS 会提示“无法验证开发者”，按以下操作即可：
   - **方式 A（最推荐）**：打开「系统设置」→「隐私与安全性」，滑到底部安全性区域，点击「**仍要打开**」，输入锁屏密码即可；
   - **方式 B（右键打开）**：按住键盘 `Control` 键不放，鼠标右键点击 `MenuFold.app`，在弹出菜单中点击「打开」，在弹出的确认窗口中点击「打开」；
   - **方式 C（终端一键放行）**：
     ```bash
     xattr -cr /Applications/MenuFold.app
     ```

### 方式二：从源码编译

本项目已包含完整的 Xcode 工程，本地有 Xcode 即可一键构建：

```bash
# 1. 克隆代码仓库
git clone https://github.com/a916791360/MenuFold.git
cd MenuFold

# 2. 一键编译并生成 Release 包 (DMG + ZIP)
./scripts/build_release.sh
```

或者直接在终端或 Xcode 中打开：
```bash
open MenuFold.xcodeproj
```

---

## ⚙️ 快捷操作与小贴士

| 操作 | 效果 |
| :--- | :--- |
| **单击箭头 (`<` / `>`)** | 切换折叠 / 展开状态 |
| **Option + 单击箭头** | 快速切换显示 / 隐藏分隔线 |
| **右键单击箭头或分隔线** | 打开快捷菜单（偏好设置、自动折叠、退出） |
| **⌘ + ⌥ + B (全局快捷键)** | 全局一键收起或展开菜单栏 |
| **按住 ⌘ 拖动图标** | 自定义调整菜单栏各个图标的摆放顺序 |

---

## 🛠 技术细节

- **系统要求**：macOS 14.0 及以上（全兼容 macOS 15 Sequoia 及以上版本）。
- **编程语言**：Swift 5.9 / 6.0。
- **UI 框架**：AppKit (NSStatusBar / NSStatusItem) + SwiftUI (Settings & Onboarding)。
- **架构支持**：Universal Binary (`arm64` + `x86_64`)。
- **开机自启**：基于 macOS 13+ 官方推荐的 `ServiceManagement.SMAppService.mainApp` API。

---

## 📄 开源许可证

本项目采用 [MIT License](LICENSE) 开源协议。欢迎所有人自由使用、修改、分发及提交 PR！

---

<p align="center">
  如果 MenuFold 帮您解决了刘海遮挡的困扰，欢迎在 GitHub 上点一个 ⭐️ <strong>Star</strong> 支持一下！
</p>
