/// A content part within a message, normalized across providers.
///
/// Messages can contain multiple content parts (text, images, tool
/// calls, tool results) to support multimodal conversations and
/// tool use workflows.
public enum AIContentPart: Sendable, Hashable {
    /// Plain text content.
    case text(String)

    /// An image, either as base64 data or a URL.
    case image(AIImageSource)

    /// A tool call requested by the model.
    case toolCall(AIToolCall)

    /// A tool result provided back to the model.
    case toolResult(AIToolResult)
}

/// An image source for multimodal messages.
public struct AIImageSource: Sendable, Hashable {
    /// The MIME type of the image (e.g., "image/jpeg", "image/png").
    public let mimeType: String

    /// Base64-encoded image data. Mutually exclusive with `url`.
    public let data: String?

    /// A URL pointing to the image. Mutually exclusive with `data`.
    public let url: String?

    /// Creates an image source from base64-encoded data.
    public static func base64(
        mimeType: String,
        data: String,
    ) -> AIImageSource {
        AIImageSource(mimeType: mimeType, data: data, url: nil)
    }

    /// Creates an image source from a URL.
    public static func url(
        _ url: String,
        mimeType: String = "image/jpeg",
    ) -> AIImageSource {
        AIImageSource(mimeType: mimeType, data: nil, url: url)
    }
}

/// A tool call requested by the model.
public struct AIToolCall: Sendable, Hashable {
    /// A unique identifier for this tool call.
    public let id: String

    /// The name of the tool to invoke.
    public let name: String

    /// The arguments to pass to the tool, as arbitrary JSON.
    public let arguments: JSONValue

    public init(id: String, name: String, arguments: JSONValue) {
        self.id = id
        self.name = name
        self.arguments = arguments
    }
}

/// A tool result provided back to the model after execution.
public struct AIToolResult: Sendable, Hashable {
    /// The ID of the tool call this result corresponds to.
    public let toolCallId: String

    /// The result content as a string.
    public let content: String

    /// Whether the tool execution resulted in an error.
    public let isError: Bool

    public init(
        toolCallId: String,
        content: String,
        isError: Bool = false,
    ) {
        self.toolCallId = toolCallId
        self.content = content
        self.isError = isError
    }
}
