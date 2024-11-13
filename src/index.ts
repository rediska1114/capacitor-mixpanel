import { registerPlugin } from '@capacitor/core';
import type { MixpanelPlugin, Properties } from './definitions';

const MixpanelCapacitor = registerPlugin<MixpanelPlugin>('Mixpanel', {});

export class Mixpanel {
  private plugin = MixpanelCapacitor;
  private token!: string;
  private resolveActivation: ((value: void) => void) | null = null;
  private activatingPromise: Promise<void> | null = new Promise((resolve) => (this.resolveActivation = resolve));

  private async awaitActivation() {
    if (this.activatingPromise) {
      await this.activatingPromise;
      this.activatingPromise = null;
    }
  }

  async initialize(
    token: string,
    options?: {
      trackAutomaticEvents?: boolean;
      optOutTrackingByDefault?: boolean;
      superProperties?: Properties;
      serverURL?: string;
    },
  ): Promise<void> {
    this.token = token;
    const promise = this.plugin.initialize({ token, ...options });
    if (!this.activatingPromise) {
      this.activatingPromise = promise;
    }
    await promise;
    if (this.resolveActivation) {
      this.resolveActivation();
      this.resolveActivation = null;
    }
  }

  async setServerURL(serverURL: string): Promise<void> {
    await this.awaitActivation();
    await this.plugin.setServerURL({ token: this.token, serverURL });
  }

  async setLoggingEnabled(loggingEnabled: boolean): Promise<void> {
    await this.awaitActivation();
    await this.plugin.setLoggingEnabled({ token: this.token, loggingEnabled });
  }

  async setFlushOnBackground(flushOnBackground: boolean): Promise<void> {
    await this.awaitActivation();
    await this.plugin.setFlushOnBackground({ token: this.token, flushOnBackground });
  }

  async setFlushBatchSize(flushBatchSize: number): Promise<void> {
    await this.awaitActivation();
    await this.plugin.setFlushBatchSize({ token: this.token, flushBatchSize });
  }

  async setUseIpAddressForGeolocation(useIpAddressForGeolocation: boolean): Promise<void> {
    await this.awaitActivation();
    await this.plugin.setUseIpAddressForGeolocation({ token: this.token, useIpAddressForGeolocation });
  }

  async optOutTracking(): Promise<void> {
    await this.awaitActivation();
    await this.plugin.optOutTracking({ token: this.token });
  }

  async hasOptedOutTracking(): Promise<boolean> {
    await this.awaitActivation();
    const result = await this.plugin.hasOptedOutTracking({ token: this.token });
    return result.hasOptedOut;
  }

  async optInTracking(): Promise<void> {
    await this.awaitActivation();
    await this.plugin.optInTracking({ token: this.token });
  }

  async track(event: string, properties?: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.track({ token: this.token, event, properties });
  }

  async timeEvent(event: string, properties?: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.timeEvent({ token: this.token, event, properties });
  }

  async eventElapsedTime(event: string, properties?: Properties): Promise<number> {
    await this.awaitActivation();
    const result = await this.plugin.eventElapsedTime({ token: this.token, event, properties });
    return result.elapsedTime;
  }

  async identify(distinctId: string): Promise<void> {
    await this.awaitActivation();
    await this.plugin.identify({ token: this.token, distinctId });
  }

  async alias(alias: string, distinctId: string): Promise<void> {
    await this.awaitActivation();
    await this.plugin.alias({ token: this.token, alias, distinctId });
  }

  async flush(): Promise<void> {
    await this.awaitActivation();
    await this.plugin.flush({ token: this.token });
  }

  async reset(): Promise<void> {
    await this.awaitActivation();
    await this.plugin.reset({ token: this.token });
  }

  async getDistinctId(): Promise<string> {
    await this.awaitActivation();
    const result = await this.plugin.getDistinctId({ token: this.token });
    return result.distinctId;
  }

  async getDeviceId(): Promise<string> {
    await this.awaitActivation();
    const result = await this.plugin.getDeviceId({ token: this.token });
    return result.deviceId;
  }

  async registerSuperProperties(properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.registerSuperProperties({ token: this.token, properties });
  }

  async registerSuperPropertiesOnce(properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.registerSuperPropertiesOnce({ token: this.token, properties });
  }

  async getSuperProperties(): Promise<Properties> {
    await this.awaitActivation();
    const result = await this.plugin.getSuperProperties({ token: this.token });
    return result.superProperties;
  }

  async unregisterSuperProperty(propertyName: string): Promise<void> {
    await this.awaitActivation();
    await this.plugin.unregisterSuperProperty({ token: this.token, propertyName });
  }

  async clearSuperProperties(): Promise<void> {
    await this.awaitActivation();
    await this.plugin.clearSuperProperties({ token: this.token });
  }

  async set(properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.set({ token: this.token, properties });
  }

  async setOnce(properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.setOnce({ token: this.token, properties });
  }

  async unset(propertyName: string): Promise<void> {
    await this.awaitActivation();
    await this.plugin.unset({ token: this.token, propertyName });
  }

  async increment(properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.increment({ token: this.token, properties });
  }

  async append(properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.append({ token: this.token, properties });
  }

  async remove(properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.remove({ token: this.token, properties });
  }

  async union(properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.union({ token: this.token, properties });
  }

  async trackCharge(amount: number, properties?: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.trackCharge({ token: this.token, amount, properties });
  }

  async clearCharges(): Promise<void> {
    await this.awaitActivation();
    await this.plugin.clearCharges({ token: this.token });
  }

  async deleteUser(): Promise<void> {
    await this.awaitActivation();
    await this.plugin.deleteUser({ token: this.token });
  }

  async trackWithGroups(event: string, properties?: Properties, groups?: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.trackWithGroups({ token: this.token, event, properties, groups });
  }

  async setGroup(groupKey: string, groupID: any): Promise<void> {
    await this.awaitActivation();
    await this.plugin.setGroup({ token: this.token, groupKey, groupID });
  }

  async addGroup(groupKey: string, groupID: any): Promise<void> {
    await this.awaitActivation();
    await this.plugin.addGroup({ token: this.token, groupKey, groupID });
  }

  async removeGroup(groupKey: string, groupID: any): Promise<void> {
    await this.awaitActivation();
    await this.plugin.removeGroup({ token: this.token, groupKey, groupID });
  }

  async deleteGroup(groupKey: string, groupID: any): Promise<void> {
    await this.awaitActivation();
    await this.plugin.deleteGroup({ token: this.token, groupKey, groupID });
  }

  async groupSetProperties(groupKey: string, groupID: any, properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.groupSetProperties({ token: this.token, groupKey, groupID, properties });
  }

  async groupSetPropertyOnce(groupKey: string, groupID: any, properties: Properties): Promise<void> {
    await this.awaitActivation();
    await this.plugin.groupSetPropertyOnce({ token: this.token, groupKey, groupID, properties });
  }

  async groupUnsetProperty(groupKey: string, groupID: any, propertyName: string): Promise<void> {
    await this.awaitActivation();
    await this.plugin.groupUnsetProperty({ token: this.token, groupKey, groupID, propertyName });
  }

  async groupRemovePropertyValue(groupKey: string, groupID: any, name: string, value: any): Promise<void> {
    await this.awaitActivation();
    await this.plugin.groupRemovePropertyValue({ token: this.token, groupKey, groupID, name, value });
  }

  async groupUnionProperty(groupKey: string, groupID: any, name: string, values: any[]): Promise<void> {
    await this.awaitActivation();
    await this.plugin.groupUnionProperty({ token: this.token, groupKey, groupID, name, values });
  }
}

export * from './definitions';
