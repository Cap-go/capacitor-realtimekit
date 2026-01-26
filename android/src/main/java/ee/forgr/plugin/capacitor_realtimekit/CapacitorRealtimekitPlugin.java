package ee.forgr.plugin.capacitor_realtimekit;

import android.Manifest;
import android.app.Activity;
import android.util.Log;
import com.cloudflare.realtimekit.models.RtkMeetingInfo;
import com.cloudflare.realtimekit.ui.RealtimeKitUI;
import com.cloudflare.realtimekit.ui.RealtimeKitUIBuilder;
import com.cloudflare.realtimekit.ui.RealtimeKitUIInfo;
import com.getcapacitor.JSObject;
import com.getcapacitor.PermissionState;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.getcapacitor.annotation.PermissionCallback;

@CapacitorPlugin(
    name = "CapacitorRealtimekit",
    permissions = {
        @Permission(alias = "camera", strings = { Manifest.permission.CAMERA }),
        @Permission(alias = "microphone", strings = { Manifest.permission.RECORD_AUDIO })
    }
)
public class CapacitorRealtimekitPlugin extends Plugin {

    private static final String TAG = "RealtimekitPlugin";
    private static final String REALTIMEKIT_BASE_DOMAIN = "realtime.cloudflare.com";
    private final String pluginVersion = "8.0.8";
    private boolean isInitialized = false;
    private PendingMeetingRequest pendingMeetingRequest;

    private static final class PendingMeetingRequest {

        private final String authToken;
        private final boolean enableAudio;
        private final boolean enableVideo;

        private PendingMeetingRequest(String authToken, boolean enableAudio, boolean enableVideo) {
            this.authToken = authToken;
            this.enableAudio = enableAudio;
            this.enableVideo = enableVideo;
        }
    }

    @Override
    public void load() {
        super.load();
        Log.d(TAG, "RealtimeKit plugin loaded");
    }

    @PluginMethod
    public void initialize(PluginCall call) {
        isInitialized = true;
        Log.d(TAG, "RealtimeKit initialized");
        call.resolve();
    }

    @PluginMethod
    public void startMeeting(PluginCall call) {
        if (!isInitialized) {
            call.reject("RealtimeKit not initialized. Call initialize() first.");
            return;
        }

        String authToken = call.getString("authToken");
        if (authToken == null || authToken.isEmpty()) {
            call.reject("authToken is required");
            return;
        }

        Boolean enableAudio = call.getBoolean("enableAudio", true);
        Boolean enableVideo = call.getBoolean("enableVideo", true);

        String trimmedToken = authToken.trim();
        if (trimmedToken.isEmpty()) {
            call.reject("authToken is required");
            return;
        }

        PendingMeetingRequest request = new PendingMeetingRequest(trimmedToken, enableAudio, enableVideo);

        if (!hasMediaPermissions()) {
            pendingMeetingRequest = request;
            requestPermissionForAliases(new String[] { "camera", "microphone" }, call, "startMeetingPermissionsCallback");
            return;
        }

        launchMeeting(call, request);
    }

    @PluginMethod
    public void getPluginVersion(final PluginCall call) {
        try {
            final JSObject ret = new JSObject();
            ret.put("version", this.pluginVersion);
            call.resolve(ret);
        } catch (final Exception e) {
            call.reject("Could not get plugin version", e);
        }
    }

    @PermissionCallback
    private void startMeetingPermissionsCallback(PluginCall call) {
        if (call == null) {
            pendingMeetingRequest = null;
            return;
        }

        if (!hasMediaPermissions()) {
            pendingMeetingRequest = null;
            call.reject("Camera and microphone permissions are required to start a meeting.");
            return;
        }

        PendingMeetingRequest request = pendingMeetingRequest;
        pendingMeetingRequest = null;

        if (request == null) {
            call.reject("Missing meeting configuration after granting permissions.");
            return;
        }

        launchMeeting(call, request);
    }

    private boolean hasMediaPermissions() {
        return getPermissionState("camera") == PermissionState.GRANTED && getPermissionState("microphone") == PermissionState.GRANTED;
    }

    private void launchMeeting(PluginCall call, PendingMeetingRequest request) {
        pendingMeetingRequest = null;
        Activity activity = getActivity();
        if (activity == null) {
            call.reject("Unable to access the current Activity to show the meeting UI.");
            return;
        }

        activity.runOnUiThread(() -> {
            try {
                RtkMeetingInfo meetingInfo = new RtkMeetingInfo(
                    request.authToken,
                    request.enableAudio,
                    request.enableVideo,
                    REALTIMEKIT_BASE_DOMAIN
                );
                RealtimeKitUIInfo uiInfo = new RealtimeKitUIInfo(activity, meetingInfo);
                RealtimeKitUI realtimeKitUI = RealtimeKitUIBuilder.build(uiInfo);
                RealtimeKitUIBuilder.getMeeting().setUiKitInfo("capacitor-android", pluginVersion);
                realtimeKitUI.startMeeting();
                Log.d(TAG, "RealtimeKit meeting started successfully");
                call.resolve();
            } catch (Exception e) {
                Log.e(TAG, "Failed to start RealtimeKit meeting", e);
                call.reject("Failed to start meeting: " + e.getMessage(), e);
            }
        });
    }
}
