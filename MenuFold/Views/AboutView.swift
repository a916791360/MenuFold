import SwiftUI

public struct AboutView: View {
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 6) {
                Text("MenuFold")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(String(format: NSLocalizedString("Version %@", comment: "Version"), "1.0.0 (Build 1)"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(NSLocalizedString("Ultra-light macOS Menu Bar Organizer for Notch Displays", comment: "About tagline"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Divider()
                .padding(.horizontal, 40)
            
            VStack(spacing: 8) {
                Text(NSLocalizedString("Designed & Developed by", comment: "Author prefix"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("a916791360")
                    .font(.body)
                    .fontWeight(.medium)
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
