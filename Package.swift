// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorMixpanel",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "CapacitorMixpanel",
            targets: ["MixpanelPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main"),
        .package(url: "https://github.com/mixpanel/mixpanel-swift", exact: "4.3.0"),
    ],
    targets: [
        .target(
            name: "MixpanelPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "Mixpanel", package: "mixpanel-swift")
            ],
            path: "ios/Sources/MixpanelPlugin"),
        .testTarget(
            name: "MixpanelPluginTests",
            dependencies: ["MixpanelPlugin"],
            path: "ios/Tests/MixpanelPluginTests")
    ]
)
