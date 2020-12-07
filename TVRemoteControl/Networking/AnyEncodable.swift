import Foundation

struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void

    public init<T: Encodable>(_ wrapped: T) {
        encode = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}
