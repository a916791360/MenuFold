import SwiftUI

public enum SettingsTab: String, CaseIterable, Identifiable {
    case general = "general"
    case appearance = "appearance"
    case guide = "guide"
    case about = "about"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .general:
            return NSLocalizedString("General", comment: "General tab")
        case .appearance:
            return NSLocalizedString("Appearance", comment: "Appearance tab")
        case .guide:
            return NSLocalizedString("Guide", comment: "Guide tab")
        case .about:
            return NSLocalizedString("About", comment: "About tab")
        }
    }
}

public struct PreferencesView: View {
    @State private var selectedTab: SettingsTab = .general
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Elegant centered pill switcher with clean spacing
            HStack {
                Spacer()
                Picker("", selection: $selectedTab) {
                    ForEach(SettingsTab.allCases) { tab in
                        Text(tab.localizedName).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 320)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 12)
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Tab Content
            Group {
                switch selectedTab {
                case .general:
                    GeneralSettingsView()
                case .appearance:
                    AppearanceSettingsView()
                case .guide:
                    GuideView()
                case .about:
                    AboutView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 540, height: 490)
    }
}
