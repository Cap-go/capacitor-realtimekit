# capacitor-realtimekit
  <a href="https://capgo.app/"><img src='https://raw.githubusercontent.com/Cap-go/capgo/main/assets/capgo_banner.png' alt='Capgo - Instant updates for capacitor'/></a>

<div align="center">
  <h2><a href="https://capgo.app/?ref=plugin"> ➡️ Get Instant updates for your App with Capgo</a></h2>
  <h2><a href="https://capgo.app/consulting/?ref=plugin"> Missing a feature? We'll build the plugin for you 💪</a></h2>
</div>

Cloudflare Calls integration for Capacitor apps with built-in UI for meetings.

## Documentation

The most complete doc is available here: https://capgo.app/docs/plugins/realtimekit/

## Install

```bash
npm install @capgo/capacitor-realtimekit
npx cap sync
```

## Dependencies

This plugin uses the Cloudflare RealtimeKit SDK:

- **iOS**: [RealtimeKitCoreiOS](https://github.com/dyte-in/RealtimeKitCoreiOS) (automatically installed via Swift Package Manager)
- **Android**: `com.cloudflare.realtimekit:ui-android` version `0.2.2` (can be customized via gradle variable `realtimekitUiVersion`)

### Customizing Android RealtimeKit Version

In your app's `build.gradle`:

```gradle
buildscript {
    ext {
        realtimekitUiVersion = '0.2.2'  // or your desired version
    }
}
```

## Platform Support

- **iOS**: ✅ Supported (iOS 14.0+)
- **Android**: ✅ Supported (API 24+)
- **Web**: ❌ Not supported (native only)

## iOS Configuration

Add the following to your app's `Info.plist` file:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for audio calls</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to share images</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>We need Bluetooth access for audio routing</string>

<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
  <string>voip</string>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

## Android Configuration

Add the following permissions to your app's `AndroidManifest.xml` file:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />

<uses-feature android:name="android.hardware.camera" android:required="false" />
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
```

## API

<docgen-index>

* [`initialize()`](#initialize)
* [`startMeeting(...)`](#startmeeting)
* [`getPluginVersion()`](#getpluginversion)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

Capacitor RealtimeKit Plugin for Cloudflare Calls integration.

### initialize()

```typescript
initialize() => Promise<void>
```

Initializes the RealtimeKit plugin before using other methods.

**Since:** 7.0.0

--------------------


### startMeeting(...)

```typescript
startMeeting(options: StartMeetingOptions) => Promise<void>
```

Start a meeting using the built-in UI.
Only available on Android and iOS.

| Param         | Type                                                                | Description                             |
| ------------- | ------------------------------------------------------------------- | --------------------------------------- |
| **`options`** | <code><a href="#startmeetingoptions">StartMeetingOptions</a></code> | - Configuration options for the meeting |

**Since:** 7.0.0

--------------------


### getPluginVersion()

```typescript
getPluginVersion() => Promise<{ version: string; }>
```

Get the native Capacitor plugin version.

**Returns:** <code>Promise&lt;{ version: string; }&gt;</code>

**Since:** 7.0.0

--------------------


### Interfaces


#### StartMeetingOptions

Configuration options for starting a meeting.

| Prop              | Type                 | Description                                                                                            | Default           | Since |
| ----------------- | -------------------- | ------------------------------------------------------------------------------------------------------ | ----------------- | ----- |
| **`authToken`**   | <code>string</code>  | Authentication token for the participant. This token is required to join the Cloudflare Calls meeting. |                   | 7.0.0 |
| **`enableAudio`** | <code>boolean</code> | Whether to join with audio enabled. Default is true.                                                   | <code>true</code> | 7.0.0 |
| **`enableVideo`** | <code>boolean</code> | Whether to join with video enabled. Default is true.                                                   | <code>true</code> | 7.0.0 |

</docgen-api>
