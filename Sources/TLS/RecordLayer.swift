import Stream

public struct RecordLayer: Equatable {
    public let version: Version
    public let content: Content

    public init(version: Version, content: Content) {
        self.version = version
        self.content = content
    }
}

extension RecordLayer {
    fileprivate enum ContentType: UInt8 {
        case changeChiperSpec = 20
        case alert = 21
        case handshake = 22
        case applicationData = 23
        case heartbeat = 24
    }

    public enum Content: Equatable {
        case changeChiperSpec(ChangeCiperSpec)
        case alert(Alert)
        case handshake(Handshake)
        case applicationData(ApplicationData)
        case heartbeat
    }
}

extension RecordLayer.ContentType {
    static func decode(from stream: StreamReader) async throws -> Self {
        let rawType = try await stream.read(UInt8.self)
        guard let type = RecordLayer.ContentType(rawValue: rawType) else {
            throw TLSError.invalidRecordContentType
        }
        return type
    }

    func encode(to stream: StreamWriter) async throws {
        try await stream.write(self.rawValue)
    }
}

extension RecordLayer {
    public static func decode(from stream: StreamReader) async throws -> Self {
        let type = try await ContentType.decode(from: stream)

        let version = try await Version.decode(from: stream)
        let content = try await stream.withSubStreamReader(sizedBy: UInt16.self)
        { stream -> Content in
            switch type {
            case .changeChiperSpec:
                return .changeChiperSpec(try await .decode(from: stream))
            case .alert:
                return .alert(try await .decode(from: stream))
            case .handshake:
                return .handshake(try await .decode(from: stream))
            case .applicationData:
                return .applicationData(try await .decode(from: stream))
            case .heartbeat:
                return .heartbeat
            }
        }
        return .init(version: version, content: content)
    }

    public func encode(to stream: StreamWriter) async throws {
        func write(_ type: ContentType) async throws {
            try await stream.write(type.rawValue)
        }

        switch content {
        case .changeChiperSpec: try await write(.changeChiperSpec)
        case .alert: try await write(.alert)
        case .handshake: try await write(.handshake)
        case .applicationData: try await write(.applicationData)
        case .heartbeat: try await write(.heartbeat)
        }

        try await version.encode(to: stream)

        func write(_ encodable: StreamEncodable) async throws {
            try await stream.withSubStreamWriter(sizedBy: UInt16.self)
            { stream in
                try await encodable.encode(to: stream)
            }
        }

        switch content {
        case .changeChiperSpec(let value): try await write(value)
        case .alert(let value): try await write(value)
        case .handshake(let value): try await write(value)
        case .applicationData(let value): try await write(value)
        case .heartbeat: try await stream.write(UInt16(0))
        }
    }
}
