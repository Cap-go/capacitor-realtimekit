import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapacitorRealtimekitPlugin)
public class CapacitorRealtimekitPlugin: CAPPlugin, CAPBridgedPlugin {
    private let PLUGIN_VERSION: String = "7.0.2"
    public let identifier = "CapacitorRealtimekitPlugin"
    public let jsName = "CapacitorRealtimekit"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startMeeting", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPluginVersion", returnType: CAPPluginReturnPromise)
    ]

    private let implementation = CapacitorRealtimekit()

    @objc func initialize(_ call: CAPPluginCall) {
        implementation.initialize()
        call.resolve()
    }

    @objc func startMeeting(_ call: CAPPluginCall) {
        guard let authToken = call.getString("authToken") else {
            call.reject("authToken is required")
            return
        }

        let enableAudio = call.getBool("enableAudio") ?? true
        let enableVideo = call.getBool("enableVideo") ?? true

        implementation.startMeeting(
            authToken: authToken,
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
        call.resolve(["version": self.PLUGIN_VERSION])
    }

}
