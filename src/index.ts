import { registerPlugin } from '@capacitor/core';

import type { CapacitorRealtimekitPlugin } from './definitions';

const CapacitorRealtimekit = registerPlugin<CapacitorRealtimekitPlugin>('CapacitorRealtimekit', {
  web: () => import('./web').then((m) => new m.CapacitorRealtimekitWeb()),
});

export * from './definitions';
export { CapacitorRealtimekit };
