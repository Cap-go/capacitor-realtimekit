import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapacitorRealtimekitPlugin)
public class CapacitorRealtimekitPlugin: CAPPlugin, CAPBridgedPlugin {
    private let pluginVersion: String = "7.0.5"
    public let identifier = "CapacitorRealtimekitPlugin"
    public let jsName = "CapacitorRealtimekit"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startMeeting", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPluginVersion", returnType: CAPPluginReturnPromise)
    ]

    private lazy var implementation = CapacitorRealtimekit(plugin: self, pluginVersion: pluginVersion)

    @objc func initialize(_ call: CAPPluginCall) {
        implementation.initialize()
        call.resolve()
    }

    @objc func startMeeting(_ call: CAPPluginCall) {
        guard let authToken = call.getString("authToken") else {
            call.reject("authToken is required")
            return
        }

        let trimmedToken = authToken.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedToken.isEmpty {
            call.reject("authToken is required")
            return
        }

        let enableAudio = call.getBool("enableAudio") ?? true
        let enableVideo = call.getBool("enableVideo") ?? true

        implementation.startMeeting(
            authToken: trimmedToken,
            enableAudio: enableAudio,
            enableVideo: enableVideo
        ) { error in
            if let error = error {
                call.reject("Failed to start meeting", error.localizedDescription)
            } else {
                call.resolve()
            }
        }
    }

    @objc func getPluginVersion(_ call: CAPPluginCall) {
        call.resolve(["version": self.pluginVersion])
    }

}
