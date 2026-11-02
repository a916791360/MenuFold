import AppKit
import Foundation
import Combine

public struct GitHubReleaseInfo: Codable {
    public let tagName: String
    public let htmlUrl: String
    public let name: String?
    public let body: String?
    public let publishedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case htmlUrl = "html_url"
        case name
        case body
        case publishedAt = "published_at"
    }
}

public class UpdateChecker: ObservableObject {
    public static let shared = UpdateChecker()
    
    private let repoAPIURL = URL(string: "https://api.github.com/repos/a916791360/MenuFold/releases/latest")!
    
    @Published public var isChecking: Bool = false
    
    private init() {}
    
    public var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1.0"
    }
    
    public func checkAutomaticallyIfNeeded() {
        guard Preferences.shared.isAutoCheckUpdateEnabled else { return }
        
        if let lastCheck = Preferences.shared.lastUpdateCheckTime,
           Date().timeIntervalSince(lastCheck) < 86400 {
            return
        }
        
        checkForUpdates(isUserInitiated: false)
    }
    
    public func checkForUpdates(isUserInitiated: Bool) {
        guard !isChecking else { return }
        isChecking = true
        
        var request = URLRequest(url: repoAPIURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 12.0)
        request.setValue("MenuFold-macOS-App", forHTTPHeaderField: "User-Agent")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isChecking = false
                Preferences.shared.lastUpdateCheckTime = Date()
                
                if let error = error {
                    if isUserInitiated {
                        self.showErrorAlert(message: error.localizedDescription)
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                    if isUserInitiated {
                        self.showErrorAlert(message: NSLocalizedString("Unable to connect to GitHub to check for updates. Please check your network connection.", comment: ""))
                    }
                    return
                }
                
                do {
                    let release = try JSONDecoder().decode(GitHubReleaseInfo.self, from: data)
                    self.handleRelease(release, isUserInitiated: isUserInitiated)
                } catch {
                    if isUserInitiated {
                        self.showErrorAlert(message: NSLocalizedString("Failed to parse release information.", comment: ""))
                    }
                }
            }
        }.resume()
    }
    
    private func handleRelease(_ release: GitHubReleaseInfo, isUserInitiated: Bool) {
        let hasNewVersion = isVersion(release.tagName, greaterThan: currentVersion)
        
        if hasNewVersion {
            showNewVersionAlert(release: release)
        } else if isUserInitiated {
            showUpToDateAlert()
        }
    }
    
    private func isVersion(_ v1: String, greaterThan v2: String) -> Bool {
        let clean1 = v1.trimmingCharacters(in: CharacterSet(charactersIn: "vV "))
        let clean2 = v2.trimmingCharacters(in: CharacterSet(charactersIn: "vV "))
        
        let parts1 = clean1.split(separator: ".").compactMap { Int($0) }
        let parts2 = clean2.split(separator: ".").compactMap { Int($0) }
        
        let maxCount = max(parts1.count, parts2.count)
        for i in 0..<maxCount {
            let p1 = i < parts1.count ? parts1[i] : 0
            let p2 = i < parts2.count ? parts2[i] : 0
            if p1 > p2 { return true }
            if p1 < p2 { return false }
        }
        return false
    }
    
    private func showNewVersionAlert(release: GitHubReleaseInfo) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("New Version Available", comment: "Alert title")
        
        let rawNotes = release.body ?? ""
        let notes: String
        if rawNotes.count > 600 {
            notes = String(rawNotes.prefix(600)) + "\n..."
        } else {
            notes = rawNotes
        }
        
        let infoFormat = NSLocalizedString("A new version (%@) of MenuFold is available (current: v%@).\n\nRelease notes:\n%@", comment: "Alert message")
        alert.informativeText = String(format: infoFormat, release.tagName, currentVersion, notes)
        
        alert.addButton(withTitle: NSLocalizedString("Download Update", comment: "Button"))
        alert.addButton(withTitle: NSLocalizedString("Later", comment: "Button"))
        alert.alertStyle = .informational
        
        if let icon = NSApp.applicationIconImage {
            alert.icon = icon
        }
        
        NSApp.activate(ignoringOtherApps: true)
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: release.htmlUrl) {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    private func showUpToDateAlert() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("You're Up to Date", comment: "Alert title")
        alert.informativeText = String(format: NSLocalizedString("MenuFold v%@ is currently the newest version.", comment: "Alert message"), currentVersion)
        alert.addButton(withTitle: NSLocalizedString("OK", comment: "Button"))
        alert.alertStyle = .informational
        if let icon = NSApp.applicationIconImage {
            alert.icon = icon
        }
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }
    
    private func showErrorAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Update Check Failed", comment: "Alert title")
        alert.informativeText = message
        alert.addButton(withTitle: NSLocalizedString("OK", comment: "Button"))
        alert.alertStyle = .warning
        if let icon = NSApp.applicationIconImage {
            alert.icon = icon
        }
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }
}
