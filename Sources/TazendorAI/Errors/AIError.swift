/// A provider-agnostic error type for LLM operations.
///
/// Each case covers a common failure mode across all providers.
/// The ``providerError`` case wraps provider-specific errors for
/// cases that don't map cleanly to the common model.
public enum AIError: Error, Sendable {
    /// The provider returned an HTTP error.
    case apiError(statusCode: Int, message: String)

    /// A network-level failure occurred.
    case networkError(underlying: any Error & Sendable)

    /// The response could not be decoded.
    case decodingError(underlying: any Error & Sendable)

    /// The request was invalid before being sent.
    case invalidRequest(reason: String)

    /// A provider-specific error that doesn't map to common cases.
    case providerError(
        provider: String,
        underlying: any Error & Sendable,
    )
}

// MARK: - CustomStringConvertible

extension AIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .apiError(statusCode, message):
            "API error (\(statusCode)): \(message)"
        case let .networkError(underlying):
            "Network error: \(underlying.localizedDescription)"
        case let .decodingError(underlying):
            "Decoding error: \(underlying.localizedDescription)"
        case let .invalidRequest(reason):
            "Invalid request: \(reason)"
        case let .providerError(provider, underlying):
            "\(provider) error: \(underlying.localizedDescription)"
        }
    }
}
