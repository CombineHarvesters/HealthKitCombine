// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "HealthPublishers",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "HealthPublishers", targets: ["HealthPublishers"]),
    ],
    targets: [
        .target(name: "HealthPublishers"),
        .testTarget(name: "HealthPublishersTests", dependencies: ["HealthPublishers"]),
    ]
)
