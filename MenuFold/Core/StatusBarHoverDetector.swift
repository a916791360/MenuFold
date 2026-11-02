import AppKit

public class StatusBarHoverDetector: NSResponder {
    public var onHoverChanged: ((Bool, NSStatusBarButton) -> Void)?
    private weak var targetButton: NSStatusBarButton?
    private var trackingArea: NSTrackingArea?
    
    public init(button: NSStatusBarButton) {
        self.targetButton = button
        super.init()
        setupTracking()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupTracking() {
        guard let button = targetButton else { return }
        if let existing = trackingArea {
            button.removeTrackingArea(existing)
        }
        let area = NSTrackingArea(
            rect: button.bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        button.addTrackingArea(area)
        self.trackingArea = area
    }
    
    public override func mouseEntered(with event: NSEvent) {
        if let btn = targetButton {
            onHoverChanged?(true, btn)
        }
    }
    
    public override func mouseExited(with event: NSEvent) {
        if let btn = targetButton {
            onHoverChanged?(false, btn)
        }
    }
}
