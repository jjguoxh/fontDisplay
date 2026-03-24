// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FontDisplayApp",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "FontDisplayApp", targets: ["FontDisplayApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "FontDisplayApp",
            dependencies: [],
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        )
    ]
)