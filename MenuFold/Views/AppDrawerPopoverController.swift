import AppKit
import SwiftUI

public class AppDrawerPopoverController: NSObject, NSPopoverDelegate {
    public static let shared = AppDrawerPopoverController()
    
    private let popover = NSPopover()
    public private(set) var isShown: Bool = false
    public private(set) var openedByHover: Bool = false
    
    private var hoverCheckTimer: Timer?
    private var lastInsideTimestamp: Date = Date()
    private weak var anchorView: NSView?
    
    public var popoverWindow: NSWindow? {
        popover.contentViewController?.view.window
    }
    
    public override init() {
        super.init()
        popover.behavior = .transient
        popover.animates = true
        popover.delegate = self
        
        let hostingController = NSHostingController(rootView: AppDrawerView(onDismiss: { [weak self] in
            self?.close()
        }))
        popover.contentViewController = hostingController
    }
    
    public func show(relativeTo rect: NSRect, of view: NSView, preferredEdge: NSRectEdge = .minY, openedByHover: Bool = false) {
        guard !popover.isShown else { return }
        self.openedByHover = openedByHover
        self.anchorView = view
        self.lastInsideTimestamp = Date()
        
        AppDrawerManager.shared.refresh()
        popover.show(relativeTo: rect, of: view, preferredEdge: preferredEdge)
        isShown = true
        
        if openedByHover {
            startHoverMonitor()
        } else {
            stopHoverMonitor()
        }
    }
    
    public func close() {
        stopHoverMonitor()
        if popover.isShown {
            popover.performClose(nil)
        }
        isShown = false
        openedByHover = false
        anchorView = nil
    }
    
    public func toggle(relativeTo rect: NSRect, of view: NSView, preferredEdge: NSRectEdge = .minY) {
        if popover.isShown {
            close()
        } else {
            show(relativeTo: rect, of: view, preferredEdge: preferredEdge, openedByHover: false)
        }
    }
    
    // MARK: - Hover Monitoring
    private func startHoverMonitor() {
        stopHoverMonitor()
        lastInsideTimestamp = Date()
        
        let timer = Timer(timeInterval: 0.08, repeats: true) { [weak self] _ in
            self?.checkHoverState()
        }
        RunLoop.main.add(timer, forMode: .common)
        hoverCheckTimer = timer
    }
    
    private func stopHoverMonitor() {
        hoverCheckTimer?.invalidate()
        hoverCheckTimer = nil
    }
    
    private func checkHoverState() {
        guard isShown, openedByHover else {
            stopHoverMonitor()
            return
        }
        
        // If the user clicked into the popover (making it the active key window) or is typing in search,
        // do not auto-close on mouse exit! It will close when they click outside or dismiss.
        if let popWin = popoverWindow, popWin.isKeyWindow {
            lastInsideTimestamp = Date()
            return
        }
        
        let mouseLoc = NSEvent.mouseLocation
        
        // 1. Check if inside popover window (with 16pt margin)
        var inside = false
        if let popWin = popoverWindow {
            let paddedFrame = popWin.frame.insetBy(dx: -16, dy: -16)
            if paddedFrame.contains(mouseLoc) {
                inside = true
            }
        }
        
        // 2. Check if inside anchor view / button
        if !inside, let anchor = anchorView, let win = anchor.window {
            let anchorScreenRect = win.convertToScreen(anchor.convert(anchor.bounds, to: nil))
            if anchorScreenRect.insetBy(dx: -16, dy: -16).contains(mouseLoc) {
                inside = true
            }
        }
        
        // 3. Check if inside any of MenuFold's status bar buttons
        if !inside && StatusBarController.shared.isMouseInStatusBarButtons() {
            inside = true
        }
        
        if inside {
            lastInsideTimestamp = Date()
        } else {
            // Mouse has exited both popover and status bar buttons
            // Give 0.45s grace period so users moving between items or briefly slipping off don't lose the popover
            if Date().timeIntervalSince(lastInsideTimestamp) > 0.45 {
                close()
            }
        }
    }
    
    // MARK: - NSPopoverDelegate
    public func popoverDidClose(_ notification: Notification) {
        stopHoverMonitor()
        isShown = false
        openedByHover = false
        anchorView = nil
    }
    
    public func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return false
    }
}
