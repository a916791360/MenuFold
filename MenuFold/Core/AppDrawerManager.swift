import AppKit
import Combine

public struct DrawerAppItem: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let bundleIdentifier: String?
    public let rootAppURL: URL
    public let icon: NSImage
    public let isAccessory: Bool
    public let runningApplication: NSRunningApplication
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: DrawerAppItem, rhs: DrawerAppItem) -> Bool {
        lhs.id == rhs.id
    }
}

public class AppDrawerManager: ObservableObject {
    public static let shared = AppDrawerManager()
    
    @Published public var apps: [DrawerAppItem] = []
    @Published public var isLoading: Bool = false
    
    private init() {
        refresh()
    }
    
    public func refresh() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let running = NSWorkspace.shared.runningApplications
            var itemsByPath: [String: DrawerAppItem] = [:]
            let selfBundleID = Bundle.main.bundleIdentifier ?? "com.a916791360.MenuFold"
            
            for app in running {
                guard let bundleID = app.bundleIdentifier else { continue }
                if bundleID == selfBundleID { continue }
                
                // Filter out Apple internal system daemons
                if bundleID.hasPrefix("com.apple.") { continue }
                
                guard let url = app.bundleURL else { continue }
                let path = url.path
                
                let lowerBundle = bundleID.lowercased()
                let lowerName = (app.localizedName ?? "").lowercased()
                
                // Filter out background helpers, plugins, and webkit workers
                if lowerBundle.contains(".helper") ||
                   lowerBundle.contains(".plugin") ||
                   lowerBundle.contains(".xpc") ||
                   lowerBundle.contains("webkit") ||
                   lowerBundle.contains("renderer") {
                    continue
                }
                if lowerName.contains("helper") ||
                   lowerName.contains("daemon") ||
                   lowerName.contains("renderer") ||
                   lowerName.contains("service") {
                    continue
                }
                
                let isAccessory = (app.activationPolicy == .accessory)
                let isRegular = (app.activationPolicy == .regular)
                
                guard isAccessory || isRegular else { continue }
                
                // Resolve root application bundle if inside another .app
                var rootURL = url
                if let range = path.range(of: ".app/Contents/") {
                    let rootPath = String(path[..<range.lowerBound]) + ".app"
                    rootURL = URL(fileURLWithPath: rootPath)
                }
                
                let rootPath = rootURL.path
                let displayName = FileManager.default.displayName(atPath: rootPath)
                let finalName = (displayName.hasSuffix(".app") ? String(displayName.dropLast(4)) : displayName)
                let icon = NSWorkspace.shared.icon(forFile: rootPath)
                
                let newItem = DrawerAppItem(
                    id: rootPath,
                    name: finalName,
                    bundleIdentifier: bundleID,
                    rootAppURL: rootURL,
                    icon: icon,
                    isAccessory: isAccessory,
                    runningApplication: app
                )
                
                // Deduplicate: if already exists, prefer regular app over accessory helper
                if let existing = itemsByPath[rootPath] {
                    if !isAccessory && existing.isAccessory {
                        itemsByPath[rootPath] = newItem
                    }
                } else {
                    itemsByPath[rootPath] = newItem
                }
            }
            
            var result = Array(itemsByPath.values)
            
            // Prioritize menu bar/accessory utilities first, then alphabetical
            result.sort {
                if $0.isAccessory != $1.isAccessory {
                    return $0.isAccessory && !$1.isAccessory
                }
                return $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
            
            DispatchQueue.main.async {
                self?.apps = result
                self?.isLoading = false
            }
        }
    }
    
    public func activate(item: DrawerAppItem) {
        let targetURL = item.rootAppURL
        
        // 1. Unhide running application
        item.runningApplication.unhide()
        
        // 2. Open via modern NSWorkspace.OpenConfiguration
        let config = NSWorkspace.OpenConfiguration()
        config.activates = true
        config.addsToRecentItems = false
        
        NSWorkspace.shared.openApplication(at: targetURL, configuration: config) { app, error in
            DispatchQueue.main.async {
                let activeApp = app ?? item.runningApplication
                activeApp.unhide()
                activeApp.activate(options: [.activateAllWindows])
            }
        }
    }
    
    public func terminate(item: DrawerAppItem) {
        item.runningApplication.terminate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refresh()
        }
    }
    
    public func openInFinder(item: DrawerAppItem) {
        NSWorkspace.shared.activateFileViewerSelecting([item.rootAppURL])
    }
}
