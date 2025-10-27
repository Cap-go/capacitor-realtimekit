import { WebPlugin } from '@capacitor/core';

import type { CapacitorRealtimekitPlugin, StartMeetingOptions } from './definitions';

export class CapacitorRealtimekitWeb extends WebPlugin implements CapacitorRealtimekitPlugin {
  async initialize(): Promise<void> {
    throw new Error('RealtimeKit is not supported on web platform.');
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async startMeeting(_options: StartMeetingOptions): Promise<void> {
    throw new Error('RealtimeKit is not supported on web platform. Use native iOS or Android.');
  }

  async getPluginVersion(): Promise<{ version: string }> {
    return { version: 'web' };
  }
}
