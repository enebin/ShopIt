// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShopIt",
    platforms: [.iOS(.v16), .macOS(.v12)],
    products: [
        .library(
            name: "ShopIt",
            targets: ["ShopIt"]),
    ],
    targets: [
        .target(
            name: "ShopIt"),
        .testTarget(
            name: "ShopItTests",
            dependencies: ["ShopIt"]
        ),
    ]
)
