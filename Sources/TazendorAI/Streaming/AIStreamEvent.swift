/// A normalized streaming event from any provider.
///
/// Provider libraries map their native streaming formats to these
/// events when conforming to ``AIClient/streamMessage(_:)``.
public enum AIStreamEvent: Sendable {
    /// A fragment of text content.
    case textDelta(String)

    /// The start of a tool call with its ID and name.
    case toolCallStart(id: String, name: String)

    /// A fragment of tool call arguments (partial JSON).
    case toolCallDelta(id: String, argumentsFragment: String)

    /// The stream is complete, with the final assembled response.
    case done(AIResponse)
}
