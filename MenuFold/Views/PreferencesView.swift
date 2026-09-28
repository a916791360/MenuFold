import SwiftUI

public struct PreferencesView: View {
    public init() {}
    
    public var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label(NSLocalizedString("General", comment: "General tab"), systemImage: "gearshape")
                }
            
            AppearanceSettingsView()
                .tabItem {
                    Label(NSLocalizedString("Appearance", comment: "Appearance tab"), systemImage: "paintpalette")
                }
            
            GuideView()
                .tabItem {
                    Label(NSLocalizedString("Guide", comment: "Guide tab"), systemImage: "questionmark.circle")
                }
            
            AboutView()
                .tabItem {
                    Label(NSLocalizedString("About", comment: "About tab"), systemImage: "info.circle")
                }
        }
        .frame(width: 540, height: 480)
    }
}
