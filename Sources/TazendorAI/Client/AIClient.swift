/// A provider-agnostic interface for LLM communication.
///
/// Each provider library (TazendorAnthropic, TazendorOpenAI, etc.)
/// vends a type conforming to this protocol. Apps program against
/// `AIClient` to support multiple providers interchangeably.
///
/// ```swift
/// func chat(with client: some AIClient) async throws {
///     let request = AIRequest(
///         model: "claude-sonnet-4-6",
///         maxTokens: 1024,
///         messages: [AIMessage(role: .user, text: "Hello!")]
///     )
///     let response = try await client.sendMessage(request)
/// }
/// ```
public protocol AIClient: Sendable {
    /// The provider's identifier (e.g., "anthropic", "openai").
    var providerID: String { get }

    /// The capabilities this provider supports.
    var capabilities: Set<AICapability> { get }

    /// Sends a message request and returns the complete response.
    func sendMessage(
        _ request: AIRequest,
    ) async throws(AIError) -> AIResponse

    /// Sends a message request with streaming.
    ///
    /// Returns an `AsyncThrowingStream` that yields incremental
    /// events as the model generates its response.
    func streamMessage(
        _ request: AIRequest,
    ) async throws(AIError) -> AsyncThrowingStream<AIStreamEvent, Error>

    /// Lists models available from this provider.
    func listModels() async throws(AIError) -> [AIModelInfo]
}
