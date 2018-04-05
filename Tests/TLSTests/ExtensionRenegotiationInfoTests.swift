import Test
import Stream
@testable import TLS

class ExtensionRenegotiationInfoTests: TestCase {
    func testDecode() {
        scope {
            let stream = InputByteStream([0x00])
            let result = try Extension.RenegotiationInfo(from: stream)
            assertEqual(result, .init(values: []))
        }
    }

    func testDecodeExtension() {
        scope {
            let stream = InputByteStream([0xff, 0x01, 0x00, 0x01, 0x00])
            let result = try Extension(from: stream)
            assertEqual(result, .renegotiationInfo(.init(values: [])))
        }
    }

    func testEncode() {
        scope {
            let stream = OutputByteStream()
            let expected: [UInt8] = [0x00]
            let info = Extension.RenegotiationInfo(values: [])
            try info.encode(to: stream)
            assertEqual(stream.bytes, expected)
        }
    }

    func testEncodeExtension() {
        scope {
            let stream = OutputByteStream()
            let expected: [UInt8] = [0xff, 0x01, 0x00, 0x01, 0x00]
            let info = Extension.renegotiationInfo(.init(values: []))
            try info.encode(to: stream)
            assertEqual(stream.bytes, expected)
        }
    }
}
