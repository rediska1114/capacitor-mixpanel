export interface TokenOptions {
  token: string;
}

export interface Properties {
  [key: string]: any;
}

export interface EventOptions extends TokenOptions {
  event: string;
  properties?: Properties;
}

export interface GroupOptions extends TokenOptions {
  groupKey: string;
  groupID: any;
}

export interface MixpanelPlugin {
  initialize(
    options: TokenOptions & {
      trackAutomaticEvents?: boolean;
      optOutTrackingByDefault?: boolean;
      superProperties?: Properties;
      serverURL?: string;
    },
  ): Promise<void>;
  setServerURL(options: TokenOptions & { serverURL: string }): Promise<void>;
  setLoggingEnabled(options: TokenOptions & { loggingEnabled: boolean }): Promise<void>;
  setFlushOnBackground(options: TokenOptions & { flushOnBackground: boolean }): Promise<void>;
  setFlushBatchSize(options: TokenOptions & { flushBatchSize: number }): Promise<void>;
  setUseIpAddressForGeolocation(options: TokenOptions & { useIpAddressForGeolocation: boolean }): Promise<void>;
  optOutTracking(options: TokenOptions): Promise<void>;
  hasOptedOutTracking(options: TokenOptions): Promise<{ hasOptedOut: boolean }>;
  optInTracking(options: TokenOptions): Promise<void>;
  track(options: EventOptions): Promise<void>;
  timeEvent(options: EventOptions): Promise<void>;
  eventElapsedTime(options: EventOptions): Promise<{ elapsedTime: number }>;
  identify(options: TokenOptions & { distinctId: string }): Promise<void>;
  alias(options: TokenOptions & { alias: string; distinctId: string }): Promise<void>;
  flush(options: TokenOptions): Promise<void>;
  reset(options: TokenOptions): Promise<void>;
  getDistinctId(options: TokenOptions): Promise<{ distinctId: string }>;
  getDeviceId(options: TokenOptions): Promise<{ deviceId: string }>;
  registerSuperProperties(options: TokenOptions & { properties: Properties }): Promise<void>;
  registerSuperPropertiesOnce(options: TokenOptions & { properties: Properties }): Promise<void>;
  getSuperProperties(options: TokenOptions): Promise<{ superProperties: Properties }>;
  unregisterSuperProperty(options: TokenOptions & { propertyName: string }): Promise<void>;
  clearSuperProperties(options: TokenOptions): Promise<void>;
  set(options: TokenOptions & { properties: Properties }): Promise<void>;
  setOnce(options: TokenOptions & { properties: Properties }): Promise<void>;
  unset(options: TokenOptions & { propertyName: string }): Promise<void>;
  increment(options: TokenOptions & { properties: Properties }): Promise<void>;
  append(options: TokenOptions & { properties: Properties }): Promise<void>;
  remove(options: TokenOptions & { properties: Properties }): Promise<void>;
  union(options: TokenOptions & { properties: Properties }): Promise<void>;
  trackCharge(options: TokenOptions & { amount: number; properties?: Properties }): Promise<void>;
  clearCharges(options: TokenOptions): Promise<void>;
  deleteUser(options: TokenOptions): Promise<void>;
  trackWithGroups(options: EventOptions & { groups?: Properties }): Promise<void>;
  setGroup(options: GroupOptions): Promise<void>;
  addGroup(options: GroupOptions): Promise<void>;
  removeGroup(options: GroupOptions): Promise<void>;
  deleteGroup(options: GroupOptions): Promise<void>;
  groupSetProperties(options: GroupOptions & { properties: Properties }): Promise<void>;
  groupSetPropertyOnce(options: GroupOptions & { properties: Properties }): Promise<void>;
  groupUnsetProperty(options: GroupOptions & { propertyName: string }): Promise<void>;
  groupRemovePropertyValue(options: GroupOptions & { name: string; value: any }): Promise<void>;
  groupUnionProperty(options: GroupOptions & { name: string; values: any[] }): Promise<void>;
}
