import Carbon
import Cocoa

public class HotKeyManager {
    public static let shared = HotKeyManager()
    
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    private let hotKeyID = EventHotKeyID(signature: OSType(0x4D464C44), id: 1) // 'MFLD'
    
    private init() {}
    
    public func setup() {
        if Preferences.shared.globalHotkeyEnabled {
            registerHotKey()
        }
    }
    
    public func registerHotKey() {
        unregisterHotKey()
        
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        let handlerBlock: EventHandlerUPP = { _, inEvent, _ in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .menuFoldToggleCollapseRequested, object: nil)
            }
            return noErr
        }
        
        InstallEventHandler(GetApplicationEventTarget(), handlerBlock, 1, &eventType, nil, &eventHandler)
        
        // Register Cmd + Option + B (keyCode 11 is kVK_ANSI_B)
        let status = RegisterEventHotKey(UInt32(kVK_ANSI_B), UInt32(cmdKey | optionKey), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        if status != noErr {
            print("MenuFold: Failed to register hotkey. Status: \(status)")
        }
    }
    
    public func unregisterHotKey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }
    
    deinit {
        unregisterHotKey()
    }
}
