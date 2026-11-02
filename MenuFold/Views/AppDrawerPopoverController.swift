import AppKit
import SwiftUI

public class AppDrawerPopoverController: NSObject, NSPopoverDelegate {
    public static let shared = AppDrawerPopoverController()
    
    private let popover = NSPopover()
    public private(set) var isShown: Bool = false
    
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
    
    public func show(relativeTo rect: NSRect, of view: NSView, preferredEdge: NSRectEdge = .minY) {
        guard !popover.isShown else { return }
        AppDrawerManager.shared.refresh()
        popover.show(relativeTo: rect, of: view, preferredEdge: preferredEdge)
        isShown = true
    }
    
    public func close() {
        if popover.isShown {
            popover.performClose(nil)
        }
        isShown = false
    }
    
    public func toggle(relativeTo rect: NSRect, of view: NSView, preferredEdge: NSRectEdge = .minY) {
        if popover.isShown {
            close()
        } else {
            show(relativeTo: rect, of: view, preferredEdge: preferredEdge)
        }
    }
    
    // MARK: - NSPopoverDelegate
    public func popoverDidClose(_ notification: Notification) {
        isShown = false
    }
    
    public func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return false
    }
}
