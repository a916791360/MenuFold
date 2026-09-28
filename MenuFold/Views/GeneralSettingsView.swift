import SwiftUI

public struct GeneralSettingsView: View {
    @ObservedObject var prefs = Preferences.shared
    @ObservedObject var loginManager = LaunchAtLoginManager.shared
    
    public init() {}
    
    public var body: some View {
        Form {
            Section {
                Toggle(isOn: Binding(
                    get: { loginManager.isEnabled },
                    set: { loginManager.setEnabled($0) }
                )) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Launch at Login", comment: "Launch at login"))
                            .font(.body)
                        Text(NSLocalizedString("Automatically start MenuFold when your Mac starts", comment: "Launch at login sub"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text(NSLocalizedString("Startup", comment: "Section header"))
            }
            
            Section {
                Picker(selection: $prefs.autoCollapseDuration, label: Text(NSLocalizedString("Auto Collapse Timer", comment: "Auto collapse"))) {
                    ForEach(AutoCollapseDuration.allCases) { duration in
                        Text(duration.localizedName).tag(duration)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Text(NSLocalizedString("After expanding, MenuFold will automatically fold after the specified time.", comment: "Auto collapse sub"))
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text(NSLocalizedString("Behavior", comment: "Section header"))
            }
            
            Section {
                Toggle(isOn: $prefs.globalHotkeyEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Enable Global Shortcut (⌘ + ⌥ + B)", comment: "Hotkey title"))
                            .font(.body)
                        Text(NSLocalizedString("Toggle menu bar fold/expand from anywhere with keyboard", comment: "Hotkey sub"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .onChange(of: prefs.globalHotkeyEnabled) { _, enabled in
                    if enabled {
                        HotKeyManager.shared.registerHotKey()
                    } else {
                        HotKeyManager.shared.unregisterHotKey()
                    }
                }
            } header: {
                Text(NSLocalizedString("Shortcuts", comment: "Section header"))
            }
            
            Section {
                Toggle(isOn: $prefs.alwaysHiddenEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Enable Always-Hidden Section", comment: "Always hidden title"))
                            .font(.body)
                        Text(NSLocalizedString("Adds a second separator for icons you never want to see", comment: "Always hidden sub"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text(NSLocalizedString("Advanced", comment: "Section header"))
            }
        }
        .formStyle(GroupedFormStyle())
        .padding()
    }
}
