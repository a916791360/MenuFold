import Foundation
import AppKit

public enum ArrowStyle: String, CaseIterable, Identifiable, Codable {
    case chevron = "chevron"
    case triangle = "triangle"
    case circle = "circle"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .chevron:
            return NSLocalizedString("Classic Chevron", comment: "Classic Chevron")
        case .triangle:
            return NSLocalizedString("Filled Triangle", comment: "Filled Triangle")
        case .circle:
            return NSLocalizedString("Circle Chevron", comment: "Circle Chevron")
        }
    }
    
    public func icon(forCollapsed collapsed: Bool) -> NSImage? {
        let symbolName: String
        switch self {
        case .chevron:
            symbolName = collapsed ? "chevron.left" : "chevron.right"
        case .triangle:
            symbolName = collapsed ? "arrowtriangle.left.fill" : "arrowtriangle.right.fill"
        case .circle:
            symbolName = collapsed ? "chevron.left.circle.fill" : "chevron.right.circle.fill"
        }
        
        let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        let img = NSImage(systemSymbolName: symbolName, accessibilityDescription: "MenuFold Toggle")?.withSymbolConfiguration(config)
        img?.isTemplate = true
        return img
    }
}

public enum SeparatorStyle: String, CaseIterable, Identifiable, Codable {
    case line = "line"
    case dot = "dot"
    case hidden = "hidden"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .line:
            return NSLocalizedString("Subtle Line (|)", comment: "Subtle Line")
        case .dot:
            return NSLocalizedString("Subtle Dot (•)", comment: "Subtle Dot")
        case .hidden:
            return NSLocalizedString("Completely Hidden", comment: "Completely Hidden")
        }
    }
    
    public var visibleLength: CGFloat {
        switch self {
        case .line:
            return 16
        case .dot:
            return 16
        case .hidden:
            return 1
        }
    }
    
    public func icon() -> NSImage? {
        switch self {
        case .line:
            let img = NSImage(size: NSSize(width: 14, height: 18))
            img.lockFocus()
            let path = NSBezierPath(roundedRect: NSRect(x: 6, y: 3, width: 2, height: 12), xRadius: 1, yRadius: 1)
            NSColor.labelColor.setFill()
            path.fill()
            img.unlockFocus()
            img.isTemplate = true
            return img
        case .dot:
            let img = NSImage(size: NSSize(width: 14, height: 18))
            img.lockFocus()
            let path = NSBezierPath(ovalIn: NSRect(x: 5, y: 7, width: 4, height: 4))
            NSColor.labelColor.setFill()
            path.fill()
            img.unlockFocus()
            img.isTemplate = true
            return img
        case .hidden:
            return nil
        }
    }
}

public enum AutoCollapseDuration: Int, CaseIterable, Identifiable {
    case never = 0
    case fiveSeconds = 5
    case tenSeconds = 10
    case fifteenSeconds = 15
    case thirtySeconds = 30
    
    public var id: Int { rawValue }
    
    public var localizedName: String {
        switch self {
        case .never:
            return NSLocalizedString("Never (Manual Only)", comment: "Never")
        case .fiveSeconds:
            return NSLocalizedString("5 Seconds", comment: "5 Seconds")
        case .tenSeconds:
            return NSLocalizedString("10 Seconds", comment: "10 Seconds")
        case .fifteenSeconds:
            return NSLocalizedString("15 Seconds", comment: "15 Seconds")
        case .thirtySeconds:
            return NSLocalizedString("30 Seconds", comment: "30 Seconds")
        }
    }
}
