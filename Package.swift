// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorMixpanel",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorMixpanel",
            targets: ["MixpanelPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "MixpanelPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/MixpanelPlugin"),
        .testTarget(
            name: "MixpanelPluginTests",
            dependencies: ["MixpanelPlugin"],
            path: "ios/Tests/MixpanelPluginTests")
    ]
)
