import Foundation

/// Preconfigured JSON encoder and decoder using snake_case conventions.
///
/// Most LLM provider APIs use snake_case for JSON keys. These coders
/// automatically convert between Swift's camelCase and the wire format.
public enum JSONCoders {
    /// Encoder configured for snake_case JSON keys.
    public static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    /// Decoder configured for snake_case JSON keys.
    public static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
