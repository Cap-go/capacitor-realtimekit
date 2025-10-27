# Example App for `@capgo/capacitor-realtimekit`

This Vite project links directly to the local plugin source so you can exercise the native APIs while developing.

## Actions in this playground

- **Initialize RealtimeKit** – Initializes the RealtimeKit plugin. Must be called before using other methods.
- **Start Meeting** – Starts a meeting with the built-in UI. Requires an auth token from your Cloudflare Calls backend.
- **Get Plugin Version** – Gets the current plugin version from the native layer.

## Getting started

```bash
npm install
npm start
```

Add native shells with `npx cap add ios` or `npx cap add android` from this folder to try behaviour on device or simulator.

## Note

This example app demonstrates the plugin API structure. For a fully functional implementation, you'll need to:
1. Set up a Cloudflare Calls backend
2. Integrate the Cloudflare RealtimeKit SDK in the native implementations
3. Obtain valid auth tokens from your backend
