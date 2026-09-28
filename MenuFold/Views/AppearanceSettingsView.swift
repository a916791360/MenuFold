import SwiftUI

public struct AppearanceSettingsView: View {
    @ObservedObject var prefs = Preferences.shared
    
    public init() {}
    
    public var body: some View {
        Form {
            Section {
                Picker(selection: $prefs.arrowStyle, label: Text(NSLocalizedString("Arrow Icon Style", comment: "Arrow style"))) {
                    ForEach(ArrowStyle.allCases) { style in
                        Text(style.localizedName).tag(style)
                    }
                }
                .pickerStyle(RadioGroupPickerStyle())
                
                HStack(spacing: 20) {
                    Text(NSLocalizedString("Preview:", comment: "Preview"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        Image(nsImage: prefs.arrowStyle.icon(forCollapsed: false) ?? NSImage())
                        Text(NSLocalizedString("Expanded", comment: "Expanded label"))
                            .font(.caption)
                    }
                    .padding(6)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(6)
                    
                    HStack(spacing: 8) {
                        Image(nsImage: prefs.arrowStyle.icon(forCollapsed: true) ?? NSImage())
                        Text(NSLocalizedString("Folded", comment: "Folded label"))
                            .font(.caption)
                    }
                    .padding(6)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(6)
                }
                .padding(.top, 4)
            } header: {
                Text(NSLocalizedString("Toggle Arrow", comment: "Section header"))
            }
            
            Section {
                Picker(selection: $prefs.separatorStyle, label: Text(NSLocalizedString("Separator Style", comment: "Sep style"))) {
                    ForEach(SeparatorStyle.allCases) { style in
                        Text(style.localizedName).tag(style)
                    }
                }
                .pickerStyle(RadioGroupPickerStyle())
                .onChange(of: prefs.separatorStyle) { _, newStyle in
                    prefs.areSeparatorsHidden = (newStyle == .hidden)
                }
                
                Toggle(isOn: $prefs.areSeparatorsHidden) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Hide Separator Line", comment: "Hide separator"))
                            .font(.body)
                        Text(NSLocalizedString("Hides the separator bar for an ultra-clean look (Option-click arrow to toggle)", comment: "Hide sep sub"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text(NSLocalizedString("Separator Boundary", comment: "Section header"))
            }
        }
        .formStyle(GroupedFormStyle())
        .padding()
    }
}
