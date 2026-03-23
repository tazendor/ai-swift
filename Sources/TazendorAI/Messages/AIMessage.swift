/// A message in a conversation, normalized across providers.
///
/// Provider libraries map between their native message formats
/// and this type when conforming to ``AIClient``.
public struct AIMessage: Sendable, Hashable {
    /// The role of the message sender.
    public let role: AIMessageRole

    /// The content parts of this message.
    public let content: [AIContentPart]

    public init(role: AIMessageRole, content: [AIContentPart]) {
        self.role = role
        self.content = content
    }

    /// Creates a message with a single text content part.
    public init(role: AIMessageRole, text: String) {
        self.role = role
        content = [.text(text)]
    }
}

/// The role of a message sender in a conversation.
public enum AIMessageRole: String, Codable, Sendable, Hashable {
    case system
    case user
    case assistant
}
