import Stream

extension Extension {
    public struct SupportedGroups: Equatable {
        var items: [SupportedGroup]

        init(_ items: [SupportedGroup]) {
            self.items = items
        }
    }
}

extension Extension {
    // ex elliptic_curves
    public enum SupportedGroup: UInt16 {
        /* Elliptic Curve Groups (ECDHE) */
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect163k1 = 0x0001
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect163r1 = 0x0002
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect163r2 = 0x0003
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect193r1 = 0x0004
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect193r2 = 0x0005
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect233k1 = 0x0006
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect233r1 = 0x0007
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect239k1 = 0x0008
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect283k1 = 0x0009
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect283r1 = 0x000a
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect409k1 = 0x000b
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect409r1 = 0x000c
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect571k1 = 0x000d
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case sect571r1 = 0x000e
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case secp160k1 = 0x000f
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case secp160r1 = 0x0010
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case secp160r2 = 0x0011
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case secp192k1 = 0x0012
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case secp192r1 = 0x0013
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case secp224k1 = 0x0014
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case secp224r1 = 0x0015
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case secp256k1 = 0x0016

        case secp256r1 = 0x0017 // available in TLS 1.3
        case secp384r1 = 0x0018 // available in TLS 1.3
        case secp521r1 = 0x0019 // available in TLS 1.3

//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case brainpoolP256r1 = 0x001a
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case brainpoolP384r1 = 0x001b
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case brainpoolP512r1 = 0x001c

        case x25519 = 0x001d // [draft-tls13][RFC-ietf-tls-rfc4492bis-17]
        case x448 = 0x001e // [draft-tls13][RFC-ietf-tls-rfc4492bis-17]

        /* Finite Field Groups (DHE) */
        case ffdhe2048 = 0x0100
        case ffdhe3072 = 0x0101
        case ffdhe4096 = 0x0102
        case ffdhe6144 = 0x0103
        case ffdhe8192 = 0x0104

        /* Reserved Code Points */
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case arbitrary_explicit_prime_curves = 0xFF01
//        @available(*, deprecated, message: "insecure, removed in TLS 1.3")
        case arbitrary_explicit_char2_curves = 0xFF02
    }
}

extension Extension.SupportedGroup: StreamCodable {
    typealias SupportedGroup = Extension.SupportedGroup

    static func decode(from stream: StreamReader) async throws -> Self {
        let rawGroup = try await stream.read(UInt16.self)
        guard let group = SupportedGroup(rawValue: rawGroup) else {
            throw TLSError.invalidExtension
        }
        return group
    }

    func encode(to stream: StreamWriter) async throws {
        try await stream.write(rawValue)
    }
}

extension Extension.SupportedGroups: StreamCodableCollection {
    typealias LengthType = UInt16
}

extension Extension.SupportedGroups: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Extension.SupportedGroup...) {
        self.init([Extension.SupportedGroup](elements))
    }
}
