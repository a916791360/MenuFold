import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Run as accessory app (no dock icon, lives in menu bar)
        NSApp.setActivationPolicy(.accessory)
        
        // Initialize Core status bar controller
        _ = StatusBarController.shared
        
        // Initialize Global Hotkey
        HotKeyManager.shared.setup()
        
        // Show Onboarding guide on first launch
        if !Preferences.shared.hasCompletedOnboarding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                OnboardingWindowController.shared.showWindow()
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyManager.shared.unregisterHotKey()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

@main
struct MenuFoldApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}
