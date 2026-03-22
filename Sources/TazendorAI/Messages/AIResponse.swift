/// A provider-agnostic message response.
///
/// Contains the normalized content, stop reason, and token usage
/// that all providers return. Provider-specific data (thinking blocks,
/// cache metrics, etc.) is only available through the native client.
public struct AIResponse: Sendable {
    /// The response identifier from the provider.
    public let id: String

    /// The model that generated this response.
    public let model: String

    /// The content parts of the response.
    public let content: [AIContentPart]

    /// Why the model stopped generating.
    public let stopReason: AIStopReason?

    /// Token usage statistics.
    public let usage: AIUsage?

    public init(
        id: String,
        model: String,
        content: [AIContentPart],
        stopReason: AIStopReason? = nil,
        usage: AIUsage? = nil,
    ) {
        self.id = id
        self.model = model
        self.content = content
        self.stopReason = stopReason
        self.usage = usage
    }
}

/// Why the model stopped generating content.
public enum AIStopReason: String, Sendable, Hashable {
    /// The model reached a natural stopping point.
    case endTurn

    /// The response hit the maximum token limit.
    case maxTokens

    /// The model wants to use a tool.
    case toolUse

    /// A stop sequence was encountered.
    case stopSequence

    /// The response was filtered by the provider's safety system.
    case contentFilter
}

/// Token usage statistics for a response.
public struct AIUsage: Sendable, Hashable {
    /// Number of tokens in the input (prompt).
    public let inputTokens: Int

    /// Number of tokens in the output (response).
    public let outputTokens: Int

    public init(inputTokens: Int, outputTokens: Int) {
        self.inputTokens = inputTokens
        self.outputTokens = outputTokens
    }
}
