import SwiftUI

public struct GuideView: View {
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Banner
                HStack(spacing: 16) {
                    Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                        .resizable()
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(NSLocalizedString("Welcome to MenuFold", comment: "Guide Title"))
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(NSLocalizedString("Solve MacBook notch occlusion & organize your menu bar", comment: "Guide Subtitle"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 8)
                
                Divider()
                
                // Visual Diagram Card
                VStack(spacing: 12) {
                    Text(NSLocalizedString("Layout in Menu Bar", comment: "Layout Title"))
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 8) {
                        // Hidden zone
                        VStack(spacing: 4) {
                            Text(NSLocalizedString("Folded / Hidden Area", comment: "Hidden zone"))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                            HStack(spacing: 6) {
                                Image(systemName: "cloud.sun.fill")
                                Image(systemName: "music.note")
                                Image(systemName: "externaldrive.fill")
                            }
                            .font(.system(size: 14))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.orange.opacity(0.12))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange.opacity(0.3), lineWidth: 1))
                        }
                        
                        // Separator
                        VStack(spacing: 4) {
                            Text(NSLocalizedString("Separator", comment: "Sep label"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("|")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 8)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        // Toggle Arrow
                        VStack(spacing: 4) {
                            Text(NSLocalizedString("Toggle Arrow", comment: "Toggle label"))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        
                        // Always visible zone
                        VStack(spacing: 4) {
                            Text(NSLocalizedString("Always Visible Area", comment: "Visible zone"))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            HStack(spacing: 6) {
                                Image(systemName: "wifi")
                                Image(systemName: "battery.100")
                                Image(systemName: "clock")
                            }
                            .font(.system(size: 14))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.green.opacity(0.12))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green.opacity(0.3), lineWidth: 1))
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(12)
                }
                
                // Step 1
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        Circle().fill(Color.blue.opacity(0.2)).frame(width: 30, height: 30)
                        Text("1").font(.subheadline).fontWeight(.bold).foregroundColor(.blue)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(NSLocalizedString("Hold ⌘ (Command) to Drag Icons", comment: "Step 1 title"))
                            .font(.headline)
                        Text(NSLocalizedString("Hold the ⌘ (Command) key on your keyboard and drag any menu bar icon with your mouse. Drag icons you want to collapse to the LEFT of the separator.", comment: "Step 1 desc"))
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Step 2
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        Circle().fill(Color.orange.opacity(0.2)).frame(width: 30, height: 30)
                        Text("2").font(.subheadline).fontWeight(.bold).foregroundColor(.orange)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(NSLocalizedString("Click the Arrow to Fold / Unfold", comment: "Step 2 title"))
                            .font(.headline)
                        Text(NSLocalizedString("Click the arrow (< / >) on the menu bar. All icons to the left will instantly fold and hide, freeing up menu bar space and avoiding notch occlusion!", comment: "Step 2 desc"))
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Step 3
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        Circle().fill(Color.green.opacity(0.2)).frame(width: 30, height: 30)
                        Text("3").font(.subheadline).fontWeight(.bold).foregroundColor(.green)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(NSLocalizedString("Pro Tips: Shortcuts & Clean Mode", comment: "Step 3 title"))
                            .font(.headline)
                        Text(NSLocalizedString("• Press ⌘ + ⌥ + B anywhere to toggle fold state.\n• Option-click the arrow to hide/show the separator line.\n• Enable 'Auto Collapse' in Preferences to fold automatically.", comment: "Step 3 desc"))
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Notch Help Notice
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(NSLocalizedString("Notch Overflow Tip", comment: "Tip title"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    Text(NSLocalizedString("If you don't see the arrow upon launching, it is because your menu bar is already completely full to the notch, placing new icons behind the notch hardware. Simply quit 1-2 unused menu bar apps to let the arrow reveal itself, then ⌘-drag it to the right side of your menu bar!", comment: "Notch tip body"))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
            }
            .padding(24)
        }
    }
}
