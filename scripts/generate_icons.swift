import AppKit
import CoreGraphics

func createIcon(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()
    guard let ctx = NSGraphicsContext.current?.cgContext else {
        image.unlockFocus()
        return image
    }
    
    let scale = size / 512.0
    
    // Background Squircle
    let rect = CGRect(x: 32 * scale, y: 32 * scale, width: 448 * scale, height: 448 * scale)
    let cornerRadius: CGFloat = 100 * scale
    let path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
    
    ctx.saveGState()
    ctx.addPath(path)
    ctx.clip()
    
    // Background Gradient (Deep Space Navy to Vibrant Indigo)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colors = [
        NSColor(red: 0.08, green: 0.12, blue: 0.22, alpha: 1.0).cgColor,
        NSColor(red: 0.14, green: 0.22, blue: 0.40, alpha: 1.0).cgColor,
        NSColor(red: 0.22, green: 0.35, blue: 0.65, alpha: 1.0).cgColor
    ] as CFArray
    let locations: [CGFloat] = [0.0, 0.5, 1.0]
    if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) {
        ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: size), end: CGPoint(x: size, y: 0), options: [])
    }
    ctx.restoreGState()
    
    // Draw Subtle Outer Border
    ctx.saveGState()
    ctx.addPath(path)
    ctx.setStrokeColor(NSColor.white.withAlphaComponent(0.2).cgColor)
    ctx.setLineWidth(4 * scale)
    ctx.strokePath()
    ctx.restoreGState()
    
    // Draw Menu Bar Graphic Strip
    let barRect = CGRect(x: 56 * scale, y: 340 * scale, width: 400 * scale, height: 50 * scale)
    let barPath = CGPath(roundedRect: barRect, cornerWidth: 14 * scale, cornerHeight: 14 * scale, transform: nil)
    ctx.saveGState()
    ctx.addPath(barPath)
    ctx.setFillColor(NSColor.white.withAlphaComponent(0.12).cgColor)
    ctx.fillPath()
    
    // Menu bar notch in the center
    let notchRect = CGRect(x: 236 * scale, y: 354 * scale, width: 40 * scale, height: 36 * scale)
    let notchPath = CGPath(roundedRect: notchRect, cornerWidth: 6 * scale, cornerHeight: 6 * scale, transform: nil)
    ctx.addPath(notchPath)
    ctx.setFillColor(NSColor(red: 0.05, green: 0.08, blue: 0.15, alpha: 1.0).cgColor)
    ctx.fillPath()
    ctx.restoreGState()
    
    // Draw Status Dots on the menu bar
    ctx.saveGState()
    let dotColors: [NSColor] = [
        NSColor.systemGreen.withAlphaComponent(0.8),
        NSColor.systemYellow.withAlphaComponent(0.8),
        NSColor.systemRed.withAlphaComponent(0.8)
    ]
    for (i, c) in dotColors.enumerated() {
        let dotX = (76 + CGFloat(i * 18)) * scale
        let dotRect = CGRect(x: dotX, y: 358 * scale, width: 10 * scale, height: 10 * scale)
        ctx.addEllipse(in: dotRect)
        ctx.setFillColor(c.cgColor)
        ctx.fillPath()
    }
    ctx.restoreGState()
    
    // Draw Big Folding Chevron / Fold Symbol in center
    ctx.saveGState()
    let chevronPath = CGMutablePath()
    let cx = 256 * scale
    let cy = 200 * scale
    
    // Left bracket <
    chevronPath.move(to: CGPoint(x: (cx - 40 * scale), y: (cy + 70 * scale)))
    chevronPath.addLine(to: CGPoint(x: (cx - 100 * scale), y: cy))
    chevronPath.addLine(to: CGPoint(x: (cx - 40 * scale), y: (cy - 70 * scale)))
    
    ctx.addPath(chevronPath)
    ctx.setLineCap(.round)
    ctx.setLineJoin(.round)
    ctx.setLineWidth(24 * scale)
    ctx.setStrokeColor(NSColor(red: 0.28, green: 0.65, blue: 1.0, alpha: 1.0).cgColor)
    ctx.setShadow(offset: CGSize(width: 0, height: -4 * scale), blur: 18 * scale, color: NSColor(red: 0.28, green: 0.65, blue: 1.0, alpha: 0.8).cgColor)
    ctx.strokePath()
    ctx.restoreGState()
    
    // Vertical separator bar
    ctx.saveGState()
    let sepRect = CGRect(x: (cx + 30 * scale), y: (cy - 70 * scale), width: 14 * scale, height: 140 * scale)
    let sepPath = CGPath(roundedRect: sepRect, cornerWidth: 7 * scale, cornerHeight: 7 * scale, transform: nil)
    ctx.addPath(sepPath)
    ctx.setFillColor(NSColor.white.withAlphaComponent(0.85).cgColor)
    ctx.setShadow(offset: CGSize(width: 0, height: -2 * scale), blur: 10 * scale, color: NSColor.white.withAlphaComponent(0.5).cgColor)
    ctx.fillPath()
    ctx.restoreGState()
    
    // Collapsing items dots to the left of separator
    ctx.saveGState()
    let iconsX = [cx + 80 * scale, cx + 120 * scale]
    for x in iconsX {
        let iconRect = CGRect(x: x, y: (cy - 12 * scale), width: 24 * scale, height: 24 * scale)
        let iconPath = CGPath(roundedRect: iconRect, cornerWidth: 6 * scale, cornerHeight: 6 * scale, transform: nil)
        ctx.addPath(iconPath)
        ctx.setFillColor(NSColor.white.withAlphaComponent(0.4).cgColor)
        ctx.fillPath()
    }
    ctx.restoreGState()
    
    image.unlockFocus()
    return image
}

func savePNG(image: NSImage, path: String) {
    if let tiff = image.tiffRepresentation,
       let rep = NSBitmapImageRep(data: tiff),
       let png = rep.representation(using: .png, properties: [:]) {
        try? png.write(to: URL(fileURLWithPath: path))
    }
}

let sizes: [(String, CGFloat)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024)
]

let iconsetDir = "/tmp/AppIcon.iconset"
try? FileManager.default.removeItem(atPath: iconsetDir)
try? FileManager.default.createDirectory(atPath: iconsetDir, withIntermediateDirectories: true)

let assetDir = "MenuFold/Resources/Assets.xcassets/AppIcon.appiconset"

for (filename, s) in sizes {
    let img = createIcon(size: s)
    savePNG(image: img, path: "\(iconsetDir)/\(filename)")
    savePNG(image: img, path: "\(assetDir)/\(filename)")
}

let task = Process()
task.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
task.arguments = ["-c", "icns", iconsetDir, "-o", "MenuFold/Resources/AppIcon.icns"]
try? task.run()
task.waitUntilExit()

print("Icons generated successfully!")
