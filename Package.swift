// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "HealthKitCombine",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "HealthKitCombine", targets: ["HealthKitCombine"]),
    ],
    targets: [
        .target(name: "HealthKitCombine"),
        .testTarget(name: "HealthKitCombineTests", dependencies: ["HealthKitCombine"]),
    ]
)
