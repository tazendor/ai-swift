/// Parses the Server-Sent Events wire format into raw events.
///
/// Handles the SSE protocol: `event:` lines set the type, `data:`
/// lines accumulate the payload, blank lines delimit events, and
/// lines starting with `:` are comments (ignored).
///
/// Each provider library then maps ``SSERawEvent`` into its own
/// typed event enum (e.g., Anthropic's `StreamEvent`).
///
/// ## SSE Wire Format
/// ```
/// event: message_start
/// data: {"type": "message_start", ...}
///
/// event: content_block_delta
/// data: {"type": "content_block_delta", ...}
///
/// ```
public enum SSELineParser {
    /// Parses an async sequence of lines into raw SSE events.
    ///
    /// - Parameter lines: An async sequence of strings, typically
    ///   from `URLSession.bytes.lines`.
    /// - Returns: An `AsyncThrowingStream` yielding parsed events.
    public static func parse<S: AsyncSequence & Sendable>(
        lines: S,
    ) -> AsyncThrowingStream<SSERawEvent, Error>
        where S.Element == String
    {
        AsyncThrowingStream { continuation in
            let task = Task {
                var currentEvent: String?
                var dataLines: [String] = []

                do {
                    for try await line in lines {
                        if line.hasPrefix(":") {
                            // Comment line — ignore per SSE spec
                            continue
                        } else if line.hasPrefix("event: ") {
                            currentEvent = String(
                                line.dropFirst("event: ".count),
                            )
                        } else if line.hasPrefix("data: ") {
                            dataLines.append(
                                String(line.dropFirst("data: ".count)),
                            )
                        } else if line.isEmpty {
                            if !dataLines.isEmpty {
                                let event = SSERawEvent(
                                    event: currentEvent,
                                    data: dataLines.joined(
                                        separator: "\n",
                                    ),
                                )
                                continuation.yield(event)
                            }
                            currentEvent = nil
                            dataLines = []
                        }
                    }
                    // Flush any trailing event without final blank line
                    if !dataLines.isEmpty {
                        let event = SSERawEvent(
                            event: currentEvent,
                            data: dataLines.joined(separator: "\n"),
                        )
                        continuation.yield(event)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
