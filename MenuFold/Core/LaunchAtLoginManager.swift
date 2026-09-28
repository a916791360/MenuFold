import Foundation
import ServiceManagement
import Combine

public class LaunchAtLoginManager: ObservableObject {
    public static let shared = LaunchAtLoginManager()
    
    @Published public var isEnabled: Bool = false
    
    private init() {
        refresh()
    }
    
    public func refresh() {
        isEnabled = (SMAppService.mainApp.status == .enabled)
    }
    
    public func setEnabled(_ enable: Bool) {
        do {
            if enable {
                if SMAppService.mainApp.status != .enabled {
                    try SMAppService.mainApp.register()
                }
            } else {
                if SMAppService.mainApp.status == .enabled {
                    try SMAppService.mainApp.unregister()
                }
            }
            refresh()
        } catch {
            print("MenuFold: Error setting launch at login: \(error)")
            refresh()
        }
    }
}
