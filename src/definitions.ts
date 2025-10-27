/**
 * Capacitor RealtimeKit Plugin for Cloudflare Calls integration.
 *
 * @since 7.0.0
 */
export interface CapacitorRealtimekitPlugin {
  /**
   * Initializes the RealtimeKit plugin before using other methods.
   *
   * @returns Promise that resolves when initialization is complete
   * @throws Error if initialization fails
   * @since 7.0.0
   * @example
   * ```typescript
   * await CapacitorRealtimekit.initialize();
   * ```
   */
  initialize(): Promise<void>;

  /**
   * Start a meeting using the built-in UI.
   * Only available on Android and iOS.
   *
   * @param options - Configuration options for the meeting
   * @returns Promise that resolves when the meeting UI is launched
   * @throws Error if the platform is not supported or if starting the meeting fails
   * @since 7.0.0
   * @example
   * ```typescript
   * await CapacitorRealtimekit.startMeeting({
   *   authToken: 'your-auth-token',
   *   enableAudio: true,
   *   enableVideo: true,
   * });
   * ```
   */
  startMeeting(options: StartMeetingOptions): Promise<void>;

  /**
   * Get the native Capacitor plugin version.
   *
   * @returns Promise that resolves with the plugin version
   * @throws Error if getting the version fails
   * @since 7.0.0
   * @example
   * ```typescript
   * const { version } = await CapacitorRealtimekit.getPluginVersion();
   * console.log('Plugin version:', version);
   * ```
   */
  getPluginVersion(): Promise<{ version: string }>;
}

/**
 * Configuration options for starting a meeting.
 *
 * @since 0.0.1
 */
export interface StartMeetingOptions {
  /**
   * Authentication token for the participant.
   * This token is required to join the Cloudflare Calls meeting.
   *
   * @since 7.0.0
   */
  authToken: string;

  /**
   * Whether to join with audio enabled.
   * Default is true.
   *
   * @default true
   * @since 7.0.0
   */
  enableAudio?: boolean;

  /**
   * Whether to join with video enabled.
   * Default is true.
   *
   * @default true
   * @since 7.0.0
   */
  enableVideo?: boolean;
}
