import AppKit
import Combine

public class StatusBarController: NSObject {
    public static let shared = StatusBarController()
    
    // Status items
    private let toggleItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let separatorItem = NSStatusBar.system.statusItem(withLength: 16)
    private var alwaysHiddenItem: NSStatusItem?
    
    // Auto collapse timer
    private var autoCollapseTimer: Timer?
    private var isDebouncing = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public override init() {
        super.init()
        setupStatusItems()
        setupObservers()
        updateUI()
        
        // Initial state
        if Preferences.shared.isCollapsed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.collapse()
            }
        } else {
            expand()
        }
    }
    
    private var collapseWidth: CGFloat {
        let maxWidth = NSScreen.screens.map { $0.frame.width }.max() ?? 1800
        return max(2000, min(maxWidth * 2, 10_000))
    }
    
    private var separatorVisibleLength: CGFloat {
        if Preferences.shared.areSeparatorsHidden {
            return 1
        }
        return Preferences.shared.separatorStyle.visibleLength
    }
    
    private var separatorImage: NSImage? {
        if Preferences.shared.areSeparatorsHidden {
            return nil
        }
        return Preferences.shared.separatorStyle.icon()
    }
    
    private func setupStatusItems() {
        // Configure Toggle Item
        toggleItem.autosaveName = "menufold_toggle"
        if let button = toggleItem.button {
            button.target = self
            button.action = #selector(toggleButtonPressed(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.toolTip = NSLocalizedString("MenuFold: Click to toggle, Option-click to toggle separator", comment: "Toggle Tooltip")
        }
        
        // Configure Separator Item
        separatorItem.autosaveName = "menufold_separator"
        if let button = separatorItem.button {
            button.target = self
            button.action = #selector(separatorButtonPressed(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.toolTip = NSLocalizedString("MenuFold Separator: Cmd-drag items to the left to fold", comment: "Separator Tooltip")
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePreferencesChanged), name: .menuFoldPreferencesChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleToggleRequested), name: .menuFoldToggleCollapseRequested, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleScreenParametersChanged), name: NSApplication.didChangeScreenParametersNotification, object: nil)
    }
    
    @objc private func handlePreferencesChanged() {
        updateUI()
        updateAlwaysHiddenItem()
    }
    
    @objc private func handleToggleRequested() {
        toggle()
    }
    
    @objc private func handleScreenParametersChanged() {
        if Preferences.shared.isCollapsed {
            separatorItem.length = collapseWidth
        }
    }
    
    public func updateUI() {
        let collapsed = Preferences.shared.isCollapsed
        
        // Update Toggle Icon
        toggleItem.button?.image = Preferences.shared.arrowStyle.icon(forCollapsed: collapsed)
        
        // Update Separator
        if collapsed {
            separatorItem.length = collapseWidth
            separatorItem.button?.image = nil
        } else {
            separatorItem.length = separatorVisibleLength
            separatorItem.button?.image = separatorImage
        }
    }
    
    private func updateAlwaysHiddenItem() {
        if Preferences.shared.alwaysHiddenEnabled {
            if alwaysHiddenItem == nil {
                let item = NSStatusBar.system.statusItem(withLength: separatorVisibleLength)
                item.autosaveName = "menufold_always_hidden"
                if let button = item.button {
                    button.image = separatorImage
                    button.target = self
                    button.action = #selector(separatorButtonPressed(_:))
                    button.sendAction(on: [.rightMouseUp])
                }
                alwaysHiddenItem = item
            }
            if Preferences.shared.isCollapsed {
                alwaysHiddenItem?.length = collapseWidth
                alwaysHiddenItem?.button?.image = nil
            } else {
                alwaysHiddenItem?.length = separatorVisibleLength
                alwaysHiddenItem?.button?.image = separatorImage
            }
        } else {
            if let item = alwaysHiddenItem {
                NSStatusBar.system.removeStatusItem(item)
                alwaysHiddenItem = nil
            }
        }
    }
    
    @objc private func toggleButtonPressed(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            showContextMenu(from: sender)
        } else {
            if event.modifierFlags.contains(.option) {
                // Option + Click: Quick toggle separator visibility
                Preferences.shared.areSeparatorsHidden.toggle()
            } else {
                toggle()
            }
        }
    }
    
    @objc private func separatorButtonPressed(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            showContextMenu(from: sender)
        }
    }
    
    public func toggle() {
        guard !isDebouncing else { return }
        isDebouncing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.isDebouncing = false
        }
        
        if Preferences.shared.isCollapsed {
            expand()
        } else {
            collapse()
        }
    }
    
    public func collapse() {
        autoCollapseTimer?.invalidate()
        autoCollapseTimer = nil
        
        separatorItem.length = collapseWidth
        separatorItem.button?.image = nil
        
        alwaysHiddenItem?.length = collapseWidth
        alwaysHiddenItem?.button?.image = nil
        
        toggleItem.button?.image = Preferences.shared.arrowStyle.icon(forCollapsed: true)
        Preferences.shared.isCollapsed = true
    }
    
    public func expand() {
        separatorItem.length = separatorVisibleLength
        separatorItem.button?.image = separatorImage
        
        alwaysHiddenItem?.length = separatorVisibleLength
        alwaysHiddenItem?.button?.image = separatorImage
        
        toggleItem.button?.image = Preferences.shared.arrowStyle.icon(forCollapsed: false)
        Preferences.shared.isCollapsed = false
        
        startAutoCollapseTimerIfNeeded()
    }
    
    private func startAutoCollapseTimerIfNeeded() {
        autoCollapseTimer?.invalidate()
        autoCollapseTimer = nil
        
        let seconds = Preferences.shared.autoCollapseDuration.rawValue
        guard seconds > 0 else { return }
        
        autoCollapseTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(seconds), repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.collapse()
            }
        }
    }
    
    private func showContextMenu(from sender: NSStatusBarButton) {
        let menu = buildContextMenu()
        menu.popUp(positioning: nil, at: NSPoint(x: 0, y: sender.bounds.height + 4), in: sender)
    }
    
    private func buildContextMenu() -> NSMenu {
        let menu = NSMenu()
        
        // Toggle item
        let toggleTitle = Preferences.shared.isCollapsed ?
            NSLocalizedString("Expand Menu Bar", comment: "Expand") :
            NSLocalizedString("Collapse Menu Bar", comment: "Collapse")
        let toggleMenuItem = NSMenuItem(title: toggleTitle, action: #selector(menuToggleClicked), keyEquivalent: "b")
        toggleMenuItem.keyEquivalentModifierMask = [.command, .option]
        toggleMenuItem.target = self
        menu.addItem(toggleMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Auto Collapse Submenu
        let autoCollapseMenu = NSMenu()
        for duration in AutoCollapseDuration.allCases {
            let item = NSMenuItem(title: duration.localizedName, action: #selector(autoCollapseSelected(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = duration
            if Preferences.shared.autoCollapseDuration == duration {
                item.state = .on
            }
            autoCollapseMenu.addItem(item)
        }
        let autoCollapseItem = NSMenuItem(title: NSLocalizedString("Auto Collapse", comment: "Auto Collapse"), action: nil, keyEquivalent: "")
        autoCollapseItem.submenu = autoCollapseMenu
        menu.addItem(autoCollapseItem)
        
        // Separator Style Submenu
        let sepStyleMenu = NSMenu()
        for style in SeparatorStyle.allCases {
            let item = NSMenuItem(title: style.localizedName, action: #selector(separatorStyleSelected(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = style
            if Preferences.shared.separatorStyle == style && !Preferences.shared.areSeparatorsHidden {
                item.state = .on
            }
            sepStyleMenu.addItem(item)
        }
        let sepStyleItem = NSMenuItem(title: NSLocalizedString("Separator Style", comment: "Separator Style"), action: nil, keyEquivalent: "")
        sepStyleItem.submenu = sepStyleMenu
        menu.addItem(sepStyleItem)
        
        // Hide Separator Toggle
        let hideSepTitle = Preferences.shared.areSeparatorsHidden ?
            NSLocalizedString("Show Separator Line", comment: "Show Separator") :
            NSLocalizedString("Hide Separator Line", comment: "Hide Separator")
        let hideSepItem = NSMenuItem(title: hideSepTitle, action: #selector(toggleHideSeparator), keyEquivalent: "")
        hideSepItem.target = self
        menu.addItem(hideSepItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Guide
        let guideItem = NSMenuItem(title: NSLocalizedString("How to Use (⌘ + Drag)...", comment: "Guide"), action: #selector(openGuide), keyEquivalent: "")
        guideItem.target = self
        menu.addItem(guideItem)
        
        // Preferences
        let prefItem = NSMenuItem(title: NSLocalizedString("Preferences...", comment: "Preferences"), action: #selector(openPreferences), keyEquivalent: ",")
        prefItem.target = self
        menu.addItem(prefItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(title: NSLocalizedString("Quit MenuFold", comment: "Quit"), action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    @objc private func menuToggleClicked() {
        toggle()
    }
    
    @objc private func autoCollapseSelected(_ sender: NSMenuItem) {
        if let duration = sender.representedObject as? AutoCollapseDuration {
            Preferences.shared.autoCollapseDuration = duration
        }
    }
    
    @objc private func separatorStyleSelected(_ sender: NSMenuItem) {
        if let style = sender.representedObject as? SeparatorStyle {
            Preferences.shared.separatorStyle = style
            Preferences.shared.areSeparatorsHidden = (style == .hidden)
        }
    }
    
    @objc private func toggleHideSeparator() {
        Preferences.shared.areSeparatorsHidden.toggle()
    }
    
    @objc private func openGuide() {
        OnboardingWindowController.shared.showWindow()
    }
    
    @objc private func openPreferences() {
        PreferencesWindowController.shared.showWindow()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
