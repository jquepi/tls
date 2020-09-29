import Test
import Stream
@testable import TLS

class ChangeCipherSpecTests: TestCase {
    let bytes: [UInt8] = [0x14, 0x03, 0x03, 0x00, 0x01, 0x01]

    func testDecode() throws {
        let stream = InputByteStream(bytes)
        let record = try RecordLayer(from: stream)
        expect(record.version == .tls12)
        expect(record.content == .changeChiperSpec(.default))
    }

    func testEncode() throws {
        let stream = OutputByteStream()
        let record = RecordLayer(version: .tls12, content: .changeChiperSpec(.default))
        try record.encode(to: stream)
        expect(stream.bytes == bytes)
    }
}
