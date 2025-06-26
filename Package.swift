// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "PubkeyToDerX25519",
  platforms: [
    .macOS(.v15)
  ],
  products: [
    .library(
      name: "PubkeyToDerX25519",
      targets: ["PubkeyToDerX25519"])
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.59.1"),
    .package(
      url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.4",
    ),
  ],
  targets: [
    .target(
      name: "PubkeyToDerX25519"),
    .testTarget(
      name: "PubkeyToDerX25519Tests",
      dependencies: ["PubkeyToDerX25519"],
    ),
  ]
)
