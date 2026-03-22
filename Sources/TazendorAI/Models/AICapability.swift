/// A capability that an LLM provider or model supports.
///
/// Uses `RawRepresentable` with `String` rather than a closed enum,
/// so provider libraries can define additional capabilities without
/// modifying TazendorAI.
///
/// ```swift
/// // In a provider library:
/// extension AICapability {
///     public static let thinking = AICapability(
///         rawValue: "thinking"
///     )
/// }
/// ```
public struct AICapability: Hashable, Sendable, RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// The provider supports text generation.
    public static let textGeneration = AICapability(
        rawValue: "textGeneration",
    )

    /// The provider supports streaming responses.
    public static let streaming = AICapability(
        rawValue: "streaming",
    )

    /// The provider supports tool use / function calling.
    public static let toolUse = AICapability(
        rawValue: "toolUse",
    )

    /// The provider supports image inputs (vision).
    public static let vision = AICapability(
        rawValue: "vision",
    )

    /// The provider supports structured JSON output mode.
    public static let jsonMode = AICapability(
        rawValue: "jsonMode",
    )
}
