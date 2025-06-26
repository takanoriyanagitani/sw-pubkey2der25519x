import enum CryptoKit.Curve25519
import struct Foundation.Data

public enum KeyToDerErr: Error {
  case invalidArgument(String)
}

public typealias KeyAgreement = CryptoKit.Curve25519.KeyAgreement

public typealias PubkeyForKeyAgreement = KeyAgreement.PublicKey

public func raw2key4x25519(
  _ raw: Data,
) -> Result<PubkeyForKeyAgreement, Error> {
  Result(catching: { try PubkeyForKeyAgreement(rawRepresentation: raw) })
}

public let prefixForKeyAgreement: Data = Data([
  // 42 bytes SEQUENCE
  0x30, 0x2a,

  // 5 bytes SEQUENCE(AlgorithmIdentifier)
  0x30, 0x05,

  // 3 bytes OID(1.3.101.110)
  0x06, 0x03, 0x2b, 0x65, 0x6e,

  // 33 bytes bitstring(with no actual content)
  0x03, 0x21, 0x00,
])

public func pubkey2der4x25519(
  _ key: PubkeyForKeyAgreement,
) -> Result<Data, Error> {
  var out: Data = Data(capacity: 44)
  out.append(prefixForKeyAgreement)
  out.append(key.rawRepresentation)
  return .success(out)
}

/// Converts the raw data(32 bytes) to an ASN.1/DER encoded data(44 bytes).
///
/// The output data will be 44 bytes for the correct input data.
///
/// - parameters:
///     - raw: The raw public key(expecting 32-bytes).
/// - returns: ASN.1/DER encoded X25519 Public Key(SubjectPublicKeyInfo).
/// - seeAlso: RFC 8410 for the official specification.
public func raw2key2der4x25519(_ raw: Data) -> Result<Data, Error> {
  raw2key4x25519(raw).flatMap(pubkey2der4x25519)
}

/// Converts the ASN.1/DER encoded public key(X25519) to raw bytes(Data).
///
/// - parameters:
///     - der: The data to be converted(expecting SubjectPublicKeyInfo).
/// - returns: Raw data(32 bytes).
/// - seeAlso: RFC 8410 for the official specification.
public func der2raw4x25519(_ der: Data) -> Result<Data, Error> {
  guard 44 == der.count else {
    return .failure(KeyToDerErr.invalidArgument("invalid data size"))
  }
  let prefix: Data = der.prefix(12)
  guard prefix == prefixForKeyAgreement else {
    return .failure(KeyToDerErr.invalidArgument("invalid prefix"))
  }
  return .success(der.suffix(32))
}
