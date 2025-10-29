package ee.forgr.plugin.capacitor_realtimekit;

import android.Manifest;
import android.util.Log;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;

@CapacitorPlugin(
    name = "CapacitorRealtimekit",
    permissions = {
        @Permission(alias = "camera", strings = { Manifest.permission.CAMERA }),
        @Permission(alias = "microphone", strings = { Manifest.permission.RECORD_AUDIO })
    }
)
public class CapacitorRealtimekitPlugin extends Plugin {

    private static final String TAG = "RealtimekitPlugin";
    private final String PLUGIN_VERSION = "7.0.3";
    private boolean isInitialized = false;

    @Override
    public void load() {
        super.load();
        Log.d(TAG, "RealtimeKit plugin loaded");
    }

    @PluginMethod
    public void initialize(PluginCall call) {
        // Initialize the RealtimeKit SDK
        // TODO: Add Cloudflare RealtimeKit SDK initialization here
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

        // Start meeting with the built-in UI
        // TODO: Integrate with Cloudflare RealtimeKit SDK to launch meeting UI
        // In a real implementation, this would:
        // 1. Create and configure the RealtimeKit meeting activity/fragment
        // 2. Set the auth token, audio, and video settings
        // 3. Launch the meeting UI

        Log.d(TAG, "Starting meeting with authToken: " + authToken);
        Log.d(TAG, "Audio enabled: " + enableAudio);
        Log.d(TAG, "Video enabled: " + enableVideo);

        // For now, just resolve successfully
        // Real implementation would launch the meeting UI here
        call.resolve();
    }

    @PluginMethod
    public void getPluginVersion(final PluginCall call) {
        try {
            final JSObject ret = new JSObject();
            ret.put("version", this.PLUGIN_VERSION);
            call.resolve(ret);
        } catch (final Exception e) {
            call.reject("Could not get plugin version", e);
        }
    }
}
