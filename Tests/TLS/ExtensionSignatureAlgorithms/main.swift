import Test
@testable import TLS

typealias SignatureAlgorithms = Extension.SignatureAlgorithms

let algorithms: SignatureAlgorithms = [
    .init(hash: .sha512, signature: .rsa),
    .init(hash: .sha512, signature: .dsa),
    .init(hash: .sha512, signature: .ecdsa),
    .init(hash: .sha384, signature: .rsa),
    .init(hash: .sha384, signature: .dsa),
    .init(hash: .sha384, signature: .ecdsa),
    .init(hash: .sha256, signature: .rsa),
    .init(hash: .sha256, signature: .dsa),
    .init(hash: .sha256, signature: .ecdsa),
    .init(hash: .sha224, signature: .rsa),
    .init(hash: .sha224, signature: .dsa),
    .init(hash: .sha224, signature: .ecdsa),
    .init(hash: .sha1, signature: .rsa),
    .init(hash: .sha1, signature: .dsa),
    .init(hash: .sha1, signature: .ecdsa),
]

let algorithmsBytes: [UInt8] = [
    0x00, 0x1e, 0x06, 0x01, 0x06, 0x02, 0x06, 0x03,
    0x05, 0x01, 0x05, 0x02, 0x05, 0x03, 0x04, 0x01,
    0x04, 0x02, 0x04, 0x03, 0x03, 0x01, 0x03, 0x02,
    0x03, 0x03, 0x02, 0x01, 0x02, 0x02, 0x02, 0x03
]

let algorithmsExtensionBytes: [UInt8] =
    [0x00, 0x0d, 0x00, 0x20] + algorithmsBytes

test.case("Decode") {
    let result = try await SignatureAlgorithms.decode(from: algorithmsBytes)
    expect(result == algorithms)
}

test.case("DecodeExtension") {
    let result = try await Extension.decode(from: algorithmsExtensionBytes)
    expect(result == .signatureAlgorithms(algorithms))
}

test.case("Encode") {
    let result = try await algorithms.encode()
    expect(result == algorithmsBytes)
}

test.case("EncodeExtension") {
    let algorithmsExtension = Extension.signatureAlgorithms(algorithms)
    let result = try await algorithmsExtension.encode()
    expect(result == algorithmsExtensionBytes)
}

test.run()
