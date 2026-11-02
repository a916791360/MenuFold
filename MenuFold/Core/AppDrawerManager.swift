import AppKit
import Combine

public struct DrawerAppItem: Identifiable, Hashable {
    public let id: pid_t
    public let name: String
    public let bundleIdentifier: String?
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
            var result: [DrawerAppItem] = []
            let selfBundleID = Bundle.main.bundleIdentifier ?? "com.a916791360.MenuFold"
            
            for app in running {
                guard let bundleID = app.bundleIdentifier else { continue }
                if bundleID == selfBundleID { continue }
                
                // Filter out Apple internal system daemons
                if bundleID.hasPrefix("com.apple.") { continue }
                
                let lowerBundle = bundleID.lowercased()
                let lowerName = (app.localizedName ?? "").lowercased()
                
                // Filter out background helpers, plugins, and webkit workers
                if lowerBundle.contains(".helper") ||
                   lowerBundle.contains(".plugin") ||
                   lowerBundle.contains(".xpc") ||
                   lowerBundle.contains("webkit") {
                    continue
                }
                if lowerName.contains("helper") ||
                   lowerName.contains("daemon") ||
                   lowerName.contains("service") {
                    continue
                }
                
                let isAccessory = (app.activationPolicy == .accessory)
                let isRegular = (app.activationPolicy == .regular)
                
                // Show both menu bar accessory items and user-running desktop applications
                if isAccessory || isRegular {
                    let name = app.localizedName ?? (bundleID.components(separatedBy: ".").last ?? "App")
                    let icon = app.icon ?? NSWorkspace.shared.icon(forFile: app.bundleURL?.path ?? "")
                    
                    result.append(DrawerAppItem(
                        id: app.processIdentifier,
                        name: name,
                        bundleIdentifier: bundleID,
                        icon: icon,
                        isAccessory: isAccessory,
                        runningApplication: app
                    ))
                }
            }
            
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
        item.runningApplication.activate(options: [.activateIgnoringOtherApps])
    }
    
    public func terminate(item: DrawerAppItem) {
        item.runningApplication.terminate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.refresh()
        }
    }
    
    public func openInFinder(item: DrawerAppItem) {
        if let bundleURL = item.runningApplication.bundleURL {
            NSWorkspace.shared.activateFileViewerSelecting([bundleURL])
        }
    }
}
