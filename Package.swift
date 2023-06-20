// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "NGSRouter",
    products: [
        .library(name: "NGSRouter",
                 targets: ["NGSRouter"])
    ],
    targets: [
        .target(name: "NGSRouter",
                path: "NGSRouter")
    ]
)
