import Foundation
import Capacitor
import Mixpanel

class MixpanelTypeHandler {
    static func mixpanelTypeValue(_ object: Any) -> MixpanelType? {
        switch object {
        case let value as String:
            return value as MixpanelType
        case let value as NSNumber:
            if isBoolNumber(value) {
                return value.boolValue as MixpanelType
            } else if isInvalidNumber(value) {
                return String(describing: value) as MixpanelType
            } else {
                return value as MixpanelType
            }
        case let value as Int:
            return value as MixpanelType
        case let value as UInt:
            return value as MixpanelType
        case let value as Double:
            return value as MixpanelType
        case let value as Float:
            return value as MixpanelType
        case let value as Bool:
            return value as MixpanelType
        case let value as Date:
            return value as MixpanelType
        case let value as URL:
            return value
        case let value as NSNull:
            return value
        case let value as [Any]:
            return value.map { mixpanelTypeValue($0) }
        case let value as [String: Any]:
            return value.mapValues { mixpanelTypeValue($0) }
        case let value as MixpanelType:
            return value
        default:
            return nil
        }
    }

    private static func isBoolNumber(_ num: NSNumber) -> Bool {
        let boolID = CFBooleanGetTypeID()
        let numID = CFGetTypeID(num)
        return numID == boolID
    }

    private static func isInvalidNumber(_ num: NSNumber) -> Bool {
        return num.doubleValue.isInfinite || num.doubleValue.isNaN
    }

    static func processProperties(properties: [String: Any]? = nil) -> [String: MixpanelType] {
        var mpProperties = [String: MixpanelType]()
        for (key, value) in properties ?? [:] {
            mpProperties[key] = mixpanelTypeValue(value)
        }
        return mpProperties
    }
}

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(MixpanelPlugin)
public class MixpanelPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "MixpanelPlugin"
    public let jsName = "Mixpanel"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setServerURL", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setLoggingEnabled", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setFlushOnBackground", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setFlushBatchSize", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setUseIpAddressForGeolocation", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optOutTracking", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "hasOptedOutTracking", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optInTracking", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "track", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "timeEvent", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "eventElapsedTime", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "identify", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "alias", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "flush", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "reset", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getDistinctId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getDeviceId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "registerSuperProperties", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "registerSuperPropertiesOnce", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getSuperProperties", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "unregisterSuperProperty", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "clearSuperProperties", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "set", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setOnce", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "unset", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "increment", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "append", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "remove", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "union", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "trackCharge", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "clearCharges", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "deleteUser", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "trackWithGroups", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setGroup", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "addGroup", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "removeGroup", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "deleteGroup", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "groupSetProperties", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "groupSetPropertyOnce", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "groupUnsetProperty", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "groupRemovePropertyValue", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "groupUnionProperty", returnType: CAPPluginReturnPromise)
    ]

    @objc func initialize(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let trackAutomaticEvents = call.getBool("trackAutomaticEvents") ?? true
        let optOutTrackingByDefault = call.getBool("optOutTrackingByDefault") ?? false
        let superProperties = MixpanelTypeHandler.processProperties(properties: call.getObject("superProperties"))
        let serverURL = call.getString("serverURL")
        
        
        Mixpanel.initialize(token: token, trackAutomaticEvents: trackAutomaticEvents, optOutTrackingByDefault: optOutTrackingByDefault, superProperties: superProperties, serverURL: serverURL)
    
        
        call.resolve()
    }

    @objc func setServerURL(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let serverURL = call.getString("serverURL") else {
            return call.reject("Missing serverURL argument")
        }
        
        Mixpanel.getInstance(name: token)?.serverURL = serverURL
        call.resolve()
    }

    @objc func setLoggingEnabled(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let loggingEnabled = call.getBool("loggingEnabled") ?? true
        
        Mixpanel.getInstance(name: token)?.loggingEnabled = loggingEnabled
        call.resolve()
    }

    @objc func setFlushOnBackground(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let flushOnBackground = call.getBool("flushOnBackground") ?? true
        
        Mixpanel.getInstance(name: token)?.flushOnBackground = flushOnBackground
        call.resolve()
    }

    @objc func setFlushBatchSize(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let flushBatchSize = call.getInt("flushBatchSize") ?? 20
        
        Mixpanel.getInstance(name: token)?.flushBatchSize = flushBatchSize
        call.resolve()
    }

    @objc func setUseIpAddressForGeolocation(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let useIpAddressForGeolocation = call.getBool("useIpAddressForGeolocation") ?? true
        
        Mixpanel.getInstance(name: token)?.useIPAddressForGeoLocation = useIpAddressForGeolocation
        call.resolve()
    }

    @objc func optOutTracking(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        Mixpanel.getInstance(name: token)?.optOutTracking()
        call.resolve()
    }

    @objc func hasOptedOutTracking(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        let hasOptedOut = Mixpanel.getInstance(name: token)?.hasOptedOutTracking() ?? false
        call.resolve(["hasOptedOut": hasOptedOut])
    }

    @objc func optInTracking(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        Mixpanel.getInstance(name: token)?.optInTracking()
        call.resolve()
    }

    @objc func track(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let event = call.getString("event") else {
            return call.reject("Missing event argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.track(event: event, properties: properties)
        call.resolve()
    }

    @objc func timeEvent(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let event = call.getString("event") else {
            return call.reject("Missing event argument")
        }
        
        Mixpanel.getInstance(name: token)?.time(event: event)
        call.resolve()
    }

    @objc func eventElapsedTime(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let event = call.getString("event") else {
            return call.reject("Missing event argument")
        }
        
        let elapsedTime = Mixpanel.getInstance(name: token)?.eventElapsedTime(event: event) ?? 0
        call.resolve(["elapsedTime": elapsedTime])
    }

    @objc func identify(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let distinctId = call.getString("distinctId") else {
            return call.reject("Missing distinctId argument")
        }
        
        Mixpanel.getInstance(name: token)?.identify(distinctId: distinctId)
        call.resolve()
    }

    @objc func alias(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let alias = call.getString("alias") else {
            return call.reject("Missing alias argument")
        }
        guard let distinctId = call.getString("distinctId") else {
            return call.reject("Missing distinctId argument")
        }
        
        Mixpanel.getInstance(name: token)?.createAlias(alias, distinctId: distinctId)
        call.resolve()
    }

    @objc func flush(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        Mixpanel.getInstance(name: token)?.flush()
        call.resolve()
    }

    @objc func reset(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        Mixpanel.getInstance(name: token)?.reset()
        call.resolve()
    }

    @objc func getDistinctId(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        let distinctId = Mixpanel.getInstance(name: token)?.distinctId ?? ""
        call.resolve(["distinctId": distinctId])
    }

    @objc func getDeviceId(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        let deviceId = Mixpanel.getInstance(name: token)?.anonymousId ?? ""
        call.resolve(["deviceId": deviceId])
    }

    @objc func registerSuperProperties(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.registerSuperProperties(properties)
        call.resolve()
    }

    @objc func registerSuperPropertiesOnce(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.registerSuperPropertiesOnce(properties)
        call.resolve()
    }

    @objc func getSuperProperties(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        let superProperties = Mixpanel.getInstance(name: token)?.currentSuperProperties() ?? [:]
        call.resolve(["superProperties": superProperties])
    }

    @objc func unregisterSuperProperty(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let propertyName = call.getString("propertyName") else {
            return call.reject("Missing propertyName argument")
        }
        
        Mixpanel.getInstance(name: token)?.unregisterSuperProperty(propertyName)
        call.resolve()
    }

    @objc func clearSuperProperties(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        Mixpanel.getInstance(name: token)?.clearSuperProperties()
        call.resolve()
    }

    @objc func set(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.people.set(properties: properties)
        call.resolve()
    }

    @objc func setOnce(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.people.setOnce(properties: properties)
        call.resolve()
    }

    @objc func unset(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let propertyName = call.getString("propertyName") else {
            return call.reject("Missing propertyName argument")
        }
        
        Mixpanel.getInstance(name: token)?.people.unset(properties: [propertyName])
        call.resolve()
    }

    @objc func increment(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.people.increment(properties: properties)
        call.resolve()
    }

    @objc func append(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.people.append(properties: properties)
        call.resolve()
    }

    @objc func remove(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.people.remove(properties: properties)
        call.resolve()
    }

    @objc func union(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.people.union(properties: properties)
        call.resolve()
    }

    @objc func trackCharge(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let amount = call.getDouble("amount") ?? 0.0
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.people.trackCharge(amount: amount, properties: properties)
        call.resolve()
    }

    @objc func clearCharges(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        Mixpanel.getInstance(name: token)?.people.clearCharges()
        call.resolve()
    }

    @objc func deleteUser(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        
        Mixpanel.getInstance(name: token)?.people.deleteUser()
        call.resolve()
    }

    @objc func trackWithGroups(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        let event = call.getString("event") ?? ""
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        let groups = MixpanelTypeHandler.processProperties(properties: call.getObject("groups"))
        
        Mixpanel.getInstance(name: token)?.trackWithGroups(event: event, properties: properties, groups: groups)
        call.resolve()
    }

    @objc func setGroup(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        
        Mixpanel.getInstance(name: token)?.setGroup(groupKey: groupKey, groupID: groupID)
        call.resolve()
    }

    @objc func addGroup(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        
        Mixpanel.getInstance(name: token)?.addGroup(groupKey: groupKey, groupID: groupID)
        call.resolve()
    }

    @objc func removeGroup(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        
        Mixpanel.getInstance(name: token)?.removeGroup(groupKey: groupKey, groupID: groupID)
        call.resolve()
    }

    @objc func deleteGroup(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        
        Mixpanel.getInstance(name: token)?.getGroup(groupKey: groupKey, groupID: groupID).deleteGroup()
        call.resolve()
    }

    @objc func groupSetProperties(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.getGroup(groupKey: groupKey, groupID: groupID).set(properties: properties)
        call.resolve()
    }

    @objc func groupSetPropertyOnce(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        let properties = MixpanelTypeHandler.processProperties(properties: call.getObject("properties"))
        
        Mixpanel.getInstance(name: token)?.getGroup(groupKey: groupKey, groupID: groupID).setOnce(properties: properties)
        call.resolve()
    }

    @objc func groupUnsetProperty(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        guard let propertyName = call.getString("propertyName") else {
            return call.reject("Missing propertyName argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        
        Mixpanel.getInstance(name: token)?.getGroup(groupKey: groupKey, groupID: groupID).unset(property: propertyName)
        call.resolve()
    }

    @objc func groupRemovePropertyValue(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        guard let name = call.getString("name") else {
            return call.reject("Missing name argument")
        }
        let value = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("value") ?? "")
        
        Mixpanel.getInstance(name: token)?.getGroup(groupKey: groupKey, groupID: groupID).remove(key: name, value: value)
        call.resolve()
    }

    @objc func groupUnionProperty(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            return call.reject("Missing token argument")
        }
        guard let groupKey = call.getString("groupKey") else {
            return call.reject("Missing groupKey argument")
        }
        let groupID = MixpanelTypeHandler.mixpanelTypeValue(call.getObject("groupID") ?? "")
        guard let name = call.getString("name") else {
            return call.reject("Missing name argument")
        }
        let values = call.getArray("values", Any.self)?.compactMap { MixpanelTypeHandler.mixpanelTypeValue($0) } ?? []
        
        Mixpanel.getInstance(name: token)?.getGroup(groupKey: groupKey, groupID: groupID).union(key: name, values: values)
        call.resolve()
    }
}
