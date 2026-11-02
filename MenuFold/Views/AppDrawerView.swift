import SwiftUI
import AppKit

public enum DrawerFilter: String, CaseIterable, Identifiable {
    case all = "all"
    case accessory = "accessory"
    case regular = "regular"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .all:
            return NSLocalizedString("All", comment: "All apps")
        case .accessory:
            return NSLocalizedString("Menu Bar", comment: "Accessory apps")
        case .regular:
            return NSLocalizedString("Apps", comment: "Regular apps")
        }
    }
}

public struct AppDrawerView: View {
    @ObservedObject var drawerManager = AppDrawerManager.shared
    @State private var searchText: String = ""
    @State private var selectedFilter: DrawerFilter = .all
    @State private var hoveredItemId: pid_t? = nil
    
    var onDismiss: (() -> Void)?
    
    public init(onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
    }
    
    private var filteredApps: [DrawerAppItem] {
        drawerManager.apps.filter { item in
            // Filter by type
            switch selectedFilter {
            case .all:
                break
            case .accessory:
                if !item.isAccessory { return false }
            case .regular:
                if item.isAccessory { return false }
            }
            
            // Filter by search text
            if !searchText.isEmpty {
                return item.name.localizedCaseInsensitiveContains(searchText)
            }
            return true
        }
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 8) {
                Image(systemName: "square.grid.2x2.fill")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 14, weight: .bold))
                
                Text(NSLocalizedString("Running Menu Bar Apps", comment: "Drawer Title"))
                    .font(.system(size: 13, weight: .bold))
                
                Text("(\(drawerManager.apps.count))")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    drawerManager.refresh()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help(NSLocalizedString("Refresh App List", comment: "Refresh tooltip"))
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            // Search & Segmented Filter Bar
            VStack(spacing: 8) {
                // Search Field
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    TextField(NSLocalizedString("Search apps...", comment: "Search placeholder"), text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 12))
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
                
                // Filter Picker
                Picker("", selection: $selectedFilter) {
                    ForEach(DrawerFilter.allCases) { filter in
                        Text(filter.localizedName).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .controlSize(.small)
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 10)
            
            Divider()
            
            // App Grid Content
            ScrollView(.vertical, showsIndicators: true) {
                if filteredApps.isEmpty {
                    VStack(spacing: 8) {
                        Spacer()
                        Image(systemName: "tray")
                            .font(.system(size: 28))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("No matching apps found", comment: "Empty state"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 160)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredApps) { item in
                            appItemCell(item: item)
                        }
                    }
                    .padding(14)
                }
            }
            .frame(maxHeight: 280)
            
            Divider()
            
            // Footer Info
            HStack {
                Text(NSLocalizedString("Click to bring app to front", comment: "Drawer Footer tip"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    onDismiss?()
                    PreferencesWindowController.shared.showWindow()
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help(NSLocalizedString("Preferences...", comment: "Preferences"))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(NSColor.windowBackgroundColor).opacity(0.6))
        }
        .frame(width: 350)
        .background(VisualEffectBlur(material: .popover, blendingMode: .behindWindow))
    }
    
    @ViewBuilder
    private func appItemCell(item: DrawerAppItem) -> some View {
        Button(action: {
            drawerManager.activate(item: item)
            onDismiss?()
        }) {
            VStack(spacing: 5) {
                ZStack(alignment: .bottomTrailing) {
                    Image(nsImage: item.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 38, height: 38)
                        .shadow(color: Color.black.opacity(0.12), radius: 3, x: 0, y: 1.5)
                    
                    if item.isAccessory {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 7, height: 7)
                            .overlay(Circle().stroke(Color(NSColor.windowBackgroundColor), lineWidth: 1.5))
                            .offset(x: 2, y: 2)
                    }
                }
                
                Text(item.name)
                    .font(.system(size: 11))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.primary)
                    .frame(maxWidth: 68)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(hoveredItemId == item.id ? Color.primary.opacity(0.08) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered in
            hoveredItemId = isHovered ? item.id : nil
        }
        .contextMenu {
            Button(NSLocalizedString("Bring to Front", comment: "Activate")) {
                drawerManager.activate(item: item)
                onDismiss?()
            }
            
            Button(NSLocalizedString("Show in Finder", comment: "Finder")) {
                drawerManager.openInFinder(item: item)
            }
            
            Divider()
            
            Button(role: .destructive) {
                drawerManager.terminate(item: item)
            } label: {
                Text(NSLocalizedString("Quit", comment: "Quit app"))
            }
        }
    }
}

// Visual Effect helper for popover blur
public struct VisualEffectBlur: NSViewRepresentable {
    public var material: NSVisualEffectView.Material
    public var blendingMode: NSVisualEffectView.BlendingMode
    
    public init(material: NSVisualEffectView.Material, blendingMode: NSVisualEffectView.BlendingMode) {
        self.material = material
        self.blendingMode = blendingMode
    }
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
