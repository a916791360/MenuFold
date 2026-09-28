import AppKit
import SwiftUI

public class PreferencesWindowController: NSObject, NSWindowDelegate {
    public static let shared = PreferencesWindowController()
    
    private var window: NSWindow?
    
    public func showWindow() {
        if let existingWindow = window {
            NSApp.activate(ignoringOtherApps: true)
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }
        
        let hostingController = NSHostingController(rootView: PreferencesView())
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = NSLocalizedString("MenuFold Preferences", comment: "Pref window title")
        newWindow.styleMask = [.titled, .closable, .miniaturizable]
        newWindow.titlebarSeparatorStyle = .none
        newWindow.isReleasedWhenClosed = false
        newWindow.center()
        newWindow.delegate = self
        
        self.window = newWindow
        NSApp.activate(ignoringOtherApps: true)
        newWindow.makeKeyAndOrderFront(nil)
    }
    
    public func windowWillClose(_ notification: Notification) {
        window = nil
    }
}
