/// Normalized model information from any provider.
///
/// Represents the common metadata that all providers expose about
/// their models. Provider-specific details are available through
/// the native client's model types.
public struct AIModelInfo: Sendable, Hashable {
    /// The model identifier used in API requests.
    public let id: String

    /// A human-readable display name.
    public let displayName: String

    /// The provider that hosts this model.
    public let provider: String

    /// The capabilities this model supports.
    public let capabilities: Set<AICapability>

    /// The maximum context window size in tokens, if known.
    public let contextWindow: Int?

    /// The maximum output tokens the model can generate, if known.
    public let maxOutputTokens: Int?

    public init(
        id: String,
        displayName: String,
        provider: String,
        capabilities: Set<AICapability> = [],
        contextWindow: Int? = nil,
        maxOutputTokens: Int? = nil,
    ) {
        self.id = id
        self.displayName = displayName
        self.provider = provider
        self.capabilities = capabilities
        self.contextWindow = contextWindow
        self.maxOutputTokens = maxOutputTokens
    }
}
