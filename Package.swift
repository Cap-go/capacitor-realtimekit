// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorRealtimekit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapgoCapacitorRealtimekit",
            targets: ["CapacitorRealtimekitPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0"),
        .package(url: "https://github.com/cloudflare/realtimekit-ios-core.git", from: "1.6.1"),
        .package(url: "https://github.com/cloudflare/realtimekit-ios-ui.git", from: "0.5.3")
    ],
    targets: [
        .target(
            name: "CapacitorRealtimekitPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "RealtimeKit", package: "realtimekit-ios-core"),
                .product(name: "RealtimeKitUI", package: "realtimekit-ios-ui")
            ],
            path: "ios/Sources/CapacitorRealtimekitPlugin"),
        .testTarget(
            name: "CapacitorRealtimekitPluginTests",
            dependencies: ["CapacitorRealtimekitPlugin"],
            path: "ios/Tests/CapacitorRealtimekitPluginTests")
    ]
)
