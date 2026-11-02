import Foundation
import Combine
import SwiftUI

public extension Notification.Name {
    static let menuFoldPreferencesChanged = Notification.Name("menuFoldPreferencesChanged")
    static let menuFoldToggleCollapseRequested = Notification.Name("menuFoldToggleCollapseRequested")
}

public class Preferences: ObservableObject {
    public static let shared = Preferences()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let isCollapsed = "menufold_is_collapsed"
        static let autoCollapseDuration = "menufold_auto_collapse_duration"
        static let arrowStyle = "menufold_arrow_style"
        static let separatorStyle = "menufold_separator_style"
        static let areSeparatorsHidden = "menufold_are_separators_hidden"
        static let alwaysHiddenEnabled = "menufold_always_hidden_enabled"
        static let globalHotkeyEnabled = "menufold_global_hotkey_enabled"
        static let hasCompletedOnboarding = "menufold_has_completed_onboarding"
        static let isHoverDrawerEnabled = "menufold_is_hover_drawer_enabled"
        static let hoverDrawerDelay = "menufold_hover_drawer_delay"
        static let drawerTriggerTarget = "menufold_drawer_trigger_target"
    }
    
    @Published public var isCollapsed: Bool {
        didSet {
            defaults.set(isCollapsed, forKey: Keys.isCollapsed)
        }
    }
    
    @Published public var autoCollapseDuration: AutoCollapseDuration {
        didSet {
            defaults.set(autoCollapseDuration.rawValue, forKey: Keys.autoCollapseDuration)
            notifyChanged()
        }
    }
    
    @Published public var arrowStyle: ArrowStyle {
        didSet {
            defaults.set(arrowStyle.rawValue, forKey: Keys.arrowStyle)
            notifyChanged()
        }
    }
    
    @Published public var separatorStyle: SeparatorStyle {
        didSet {
            defaults.set(separatorStyle.rawValue, forKey: Keys.separatorStyle)
            notifyChanged()
        }
    }
    
    @Published public var areSeparatorsHidden: Bool {
        didSet {
            defaults.set(areSeparatorsHidden, forKey: Keys.areSeparatorsHidden)
            notifyChanged()
        }
    }
    
    @Published public var alwaysHiddenEnabled: Bool {
        didSet {
            defaults.set(alwaysHiddenEnabled, forKey: Keys.alwaysHiddenEnabled)
            notifyChanged()
        }
    }
    
    @Published public var globalHotkeyEnabled: Bool {
        didSet {
            defaults.set(globalHotkeyEnabled, forKey: Keys.globalHotkeyEnabled)
            notifyChanged()
        }
    }
    
    @Published public var hasCompletedOnboarding: Bool {
        didSet {
            defaults.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding)
        }
    }
    
    @Published public var isHoverDrawerEnabled: Bool {
        didSet {
            defaults.set(isHoverDrawerEnabled, forKey: Keys.isHoverDrawerEnabled)
            notifyChanged()
        }
    }
    
    @Published public var hoverDrawerDelay: HoverDelayOption {
        didSet {
            defaults.set(hoverDrawerDelay.rawValue, forKey: Keys.hoverDrawerDelay)
            notifyChanged()
        }
    }
    
    @Published public var drawerTriggerTarget: DrawerTriggerTarget {
        didSet {
            defaults.set(drawerTriggerTarget.rawValue, forKey: Keys.drawerTriggerTarget)
            notifyChanged()
        }
    }
    
    private init() {
        self.isCollapsed = defaults.bool(forKey: Keys.isCollapsed)
        
        let autoDurationRaw = defaults.object(forKey: Keys.autoCollapseDuration) as? Int ?? AutoCollapseDuration.never.rawValue
        self.autoCollapseDuration = AutoCollapseDuration(rawValue: autoDurationRaw) ?? .never
        
        let arrowStyleRaw = defaults.string(forKey: Keys.arrowStyle) ?? ArrowStyle.chevron.rawValue
        self.arrowStyle = ArrowStyle(rawValue: arrowStyleRaw) ?? .chevron
        
        let sepStyleRaw = defaults.string(forKey: Keys.separatorStyle) ?? SeparatorStyle.line.rawValue
        self.separatorStyle = SeparatorStyle(rawValue: sepStyleRaw) ?? .line
        
        self.areSeparatorsHidden = defaults.bool(forKey: Keys.areSeparatorsHidden)
        self.alwaysHiddenEnabled = defaults.bool(forKey: Keys.alwaysHiddenEnabled)
        self.globalHotkeyEnabled = defaults.object(forKey: Keys.globalHotkeyEnabled) as? Bool ?? true
        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)
        
        self.isHoverDrawerEnabled = defaults.object(forKey: Keys.isHoverDrawerEnabled) as? Bool ?? true
        let hoverDelayRaw = defaults.object(forKey: Keys.hoverDrawerDelay) as? Double ?? HoverDelayOption.normal.rawValue
        self.hoverDrawerDelay = HoverDelayOption(rawValue: hoverDelayRaw) ?? .normal
        
        let triggerTargetRaw = defaults.string(forKey: Keys.drawerTriggerTarget) ?? DrawerTriggerTarget.both.rawValue
        self.drawerTriggerTarget = DrawerTriggerTarget(rawValue: triggerTargetRaw) ?? .both
    }
    
    private func notifyChanged() {
        NotificationCenter.default.post(name: .menuFoldPreferencesChanged, object: self)
    }
}
