import AppKit
import SwiftUI

public struct OnboardingView: View {
    var onDismiss: () -> Void
    
    public var body: some View {
        VStack(spacing: 0) {
            GuideView()
            
            Divider()
            
            HStack {
                Spacer()
                Button(action: onDismiss) {
                    Text(NSLocalizedString("Got it! Start using MenuFold", comment: "Onboarding button"))
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(width: 580, height: 560)
    }
}

public class OnboardingWindowController: NSObject, NSWindowDelegate {
    public static let shared = OnboardingWindowController()
    
    private var window: NSWindow?
    
    public func showWindow() {
        if let existingWindow = window {
            NSApp.activate(ignoringOtherApps: true)
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }
        
        let onboardingView = OnboardingView { [weak self] in
            Preferences.shared.hasCompletedOnboarding = true
            self?.window?.close()
        }
        
        let hostingController = NSHostingController(rootView: onboardingView)
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = NSLocalizedString("Welcome to MenuFold", comment: "Onboarding title")
        newWindow.styleMask = [.titled, .closable]
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
