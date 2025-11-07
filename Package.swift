// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorRealtimekit",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapgoCapacitorRealtimekit",
            targets: ["CapacitorRealtimekitPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0"),
        .package(url: "https://github.com/dyte-in/RealtimeKitCoreiOS.git", from: "1.0.0"),
        .package(url: "https://github.com/dyte-in/RealtimeKitUI.git", from: "0.5.3")
    ],
    targets: [
        .target(
            name: "CapacitorRealtimekitPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "RealtimeKit", package: "RealtimeKitCoreiOS"),
                .product(name: "RealtimeKitUI", package: "RealtimeKitUI")
            ],
            path: "ios/Sources/CapacitorRealtimekitPlugin"),
        .testTarget(
            name: "CapacitorRealtimekitPluginTests",
            dependencies: ["CapacitorRealtimekitPlugin"],
            path: "ios/Tests/CapacitorRealtimekitPluginTests")
    ]
)
