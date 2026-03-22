/// A provider-agnostic message request.
///
/// Contains all the common parameters that most LLM providers support.
/// Provider-specific features are passed via the ``options`` dictionary,
/// with typed convenience methods defined in each provider library.
public struct AIRequest: Sendable {
    /// The model identifier (e.g., "claude-sonnet-4-6", "gpt-4o").
    public let model: String

    /// Maximum tokens to generate in the response.
    public let maxTokens: Int

    /// The conversation messages.
    public let messages: [AIMessage]

    /// System instructions for the model.
    public let systemPrompt: String?

    /// Sampling temperature (0.0–2.0, provider-dependent range).
    public let temperature: Double?

    /// Tool definitions available to the model.
    public let tools: [ToolDefinition]?

    /// How the model should choose tools.
    public let toolChoice: ToolChoice?

    /// Sequences that cause the model to stop generating.
    public let stopSequences: [String]?

    /// Provider-specific options that don't fit the common model.
    ///
    /// Each provider library defines its own ``AIOptionKey`` constants
    /// and typed convenience methods for setting options.
    public let options: [AIOptionKey: JSONValue]

    public init(
        model: String,
        maxTokens: Int,
        messages: [AIMessage],
        systemPrompt: String? = nil,
        temperature: Double? = nil,
        tools: [ToolDefinition]? = nil,
        toolChoice: ToolChoice? = nil,
        stopSequences: [String]? = nil,
        options: [AIOptionKey: JSONValue] = [:],
    ) {
        self.model = model
        self.maxTokens = maxTokens
        self.messages = messages
        self.systemPrompt = systemPrompt
        self.temperature = temperature
        self.tools = tools
        self.toolChoice = toolChoice
        self.stopSequences = stopSequences
        self.options = options
    }
}

/// A typed key for provider-specific request options.
///
/// Provider libraries define their own constants as extensions:
/// ```swift
/// extension AIOptionKey {
///     public static let anthropicThinkingBudget = AIOptionKey(
///         rawValue: "anthropic.thinkingBudget"
///     )
/// }
/// ```
public struct AIOptionKey: Hashable, Sendable, RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
