// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "PubkeyToDerForX25519Cli",
  platforms: [
    .macOS(.v15)
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.59.1"),
    .package(path: "../../.."),
  ],
  targets: [
    .executableTarget(
      name: "PubkeyToDerForX25519Cli",
      dependencies: [
        .product(name: "PubkeyToDerX25519", package: "sw-pubkey2der25519x")
      ],
      swiftSettings: [
        .unsafeFlags(
          ["-cross-module-optimization"],
          .when(configuration: .release),
        )
      ],
    )
  ]
)
