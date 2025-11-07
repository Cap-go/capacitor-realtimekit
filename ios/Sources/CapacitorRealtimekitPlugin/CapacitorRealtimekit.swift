import Capacitor
import Foundation
import RealtimeKit
import RealtimeKitUI
import UIKit

public final class CapacitorRealtimekit: NSObject {
    private weak var plugin: CAPPlugin?
    private let pluginVersion: String
    private let baseDomain = "realtime.cloudflare.com"
    private var isInitialized = false
    private var realtimeKitUI: RealtimeKitUI?

    init(plugin: CAPPlugin, pluginVersion: String) {
        self.plugin = plugin
        self.pluginVersion = pluginVersion
        super.init()
    }

    public func initialize() {
        isInitialized = true
        print("RealtimeKit initialized")
    }

    public func startMeeting(
        authToken: String,
        enableAudio: Bool,
        enableVideo: Bool,
        completion: @escaping (Error?) -> Void
    ) {
        guard isInitialized else {
            completion(makeError("RealtimeKit not initialized. Call initialize() first."))
            return
        }

        let trimmedToken = authToken.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedToken.isEmpty else {
            completion(makeError("authToken is required"))
            return
        }

        guard let presenter = topViewController(from: plugin?.bridge?.viewController) else {
            completion(makeError("Unable to find a view controller to present the meeting UI."))
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let meetingInfo = RtkMeetingInfo(
                authToken: trimmedToken,
                enableAudio: enableAudio,
                enableVideo: enableVideo,
                baseDomain: self.baseDomain
            )

            let uiKit = RealtimeKitUI(meetingInfo: meetingInfo)
            uiKit.rtkClient.setUiKitInfo(name: "capacitor-ios", version: self.pluginVersion)
            self.realtimeKitUI = uiKit

            let meetingController = uiKit.startMeeting { [weak self] in
                self?.realtimeKitUI = nil
            }
            meetingController.modalPresentationStyle = .fullScreen

            presenter.present(meetingController, animated: true) {
                completion(nil)
            }
        }
    }

    private func topViewController(from root: UIViewController?) -> UIViewController? {
        guard let root else { return nil }

        if let presented = root.presentedViewController {
            return topViewController(from: presented)
        }

        if let navigation = root as? UINavigationController {
            return topViewController(from: navigation.visibleViewController ?? navigation)
        }

        if let tab = root as? UITabBarController {
            return topViewController(from: tab.selectedViewController ?? tab)
        }

        return root
    }

    private func makeError(_ message: String) -> NSError {
        NSError(domain: "CapacitorRealtimekit", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
