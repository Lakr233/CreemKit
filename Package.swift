// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CreemKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v12),
        .macCatalyst(.v13),
        .visionOS(.v1),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "CreemKit",
            targets: ["CreemKit"]
        ),
        .library(
            name: "CreemProxyKit",
            targets: ["CreemProxyKit"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "CreemKit"),
        .target(name: "CreemProxyKit", dependencies: [
            "CreemKit",
        ]),
        .testTarget(name: "CreemKitTests", dependencies: ["CreemKit"]),
        .testTarget(name: "CreemProxyKitTests", dependencies: ["CreemProxyKit"]),
    ]
)
