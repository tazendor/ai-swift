/// A raw Server-Sent Event parsed from the wire format.
///
/// Contains the event type and data strings before any
/// provider-specific interpretation. Each provider library
/// maps these into its own typed event enum.
public struct SSERawEvent: Sendable, Hashable {
    /// The event type (from the `event:` field), if present.
    public let event: String?

    /// The event data (from `data:` fields, joined by newlines).
    public let data: String

    public init(event: String?, data: String) {
        self.event = event
        self.data = data
    }
}
