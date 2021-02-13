import Test
@testable import TLS

let bytes: [UInt8] = [0x16, 0x03, 0x03, 0x00, 0x04, 0x0e, 0x00, 0x00, 0x00]

test.case("Decode") {
    let record = try await RecordLayer.decode(from: bytes)
    expect(record.version == .tls12)
    expect(record.content == .handshake(.serverHelloDone))
}

test.case("Encode") {
    let record = RecordLayer(
        version: .tls12,
        content: .handshake(.serverHelloDone))
    let result = try await record.encode()
    expect(result == bytes)
}

test.run()
