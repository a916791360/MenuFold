import SwiftUI

public struct AboutView: View {
    public init() {}
    
    private var versionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.2"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "2"
        return String(format: NSLocalizedString("Version %@", comment: "Version"), "\(version) (Build \(build))")
    }
    
    public var body: some View {
        VStack(spacing: 22) {
            Spacer()
            
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 6) {
                Text("MenuFold")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(versionString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(NSLocalizedString("Ultra-light macOS Menu Bar Organizer for Notch Displays", comment: "About tagline"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    if let url = URL(string: "https://github.com/a916791360/MenuFold") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "link")
                        Text(NSLocalizedString("GitHub Repository", comment: "GitHub button"))
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    if let url = URL(string: "https://github.com/a916791360/MenuFold/releases") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text(NSLocalizedString("Releases & Updates", comment: "Releases button"))
                }
                .buttonStyle(.bordered)
            }
            
            Text(NSLocalizedString("Open source under the MIT License", comment: "License"))
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
