// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "TazendorAI",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "TazendorAI",
            targets: ["TazendorAI"],
        ),
    ],
    targets: [
        .target(
            name: "TazendorAI",
        ),
        .testTarget(
            name: "TazendorAITests",
            dependencies: ["TazendorAI"],
        ),
    ],
)
