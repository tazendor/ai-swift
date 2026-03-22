import Foundation
@testable import TazendorAI
import Testing

struct SSELineParserTests {
    @Test("Parses a single event with type and data")
    func singleEvent() async throws {
        let lines = AsyncSequenceOf([
            "event: message_start",
            "data: {\"type\": \"message_start\"}",
            "",
        ])

        let stream = SSELineParser.parse(lines: lines)
        var events: [SSERawEvent] = []
        for try await event in stream {
            events.append(event)
        }

        #expect(events.count == 1)
        #expect(events[0].event == "message_start")
        #expect(events[0].data == "{\"type\": \"message_start\"}")
    }

    @Test("Parses multiple events")
    func multipleEvents() async throws {
        let lines = AsyncSequenceOf([
            "event: ping",
            "data: {}",
            "",
            "event: message_start",
            "data: {\"id\": \"msg_1\"}",
            "",
        ])

        let stream = SSELineParser.parse(lines: lines)
        var events: [SSERawEvent] = []
        for try await event in stream {
            events.append(event)
        }

        #expect(events.count == 2)
        #expect(events[0].event == "ping")
        #expect(events[1].event == "message_start")
    }

    @Test("Joins multiple data lines with newlines")
    func multipleDataLines() async throws {
        let lines = AsyncSequenceOf([
            "event: content",
            "data: line one",
            "data: line two",
            "",
        ])

        let stream = SSELineParser.parse(lines: lines)
        var events: [SSERawEvent] = []
        for try await event in stream {
            events.append(event)
        }

        #expect(events.count == 1)
        #expect(events[0].data == "line one\nline two")
    }

    @Test("Ignores comment lines")
    func commentLines() async throws {
        let lines = AsyncSequenceOf([
            ": this is a comment",
            "event: ping",
            ": another comment",
            "data: {}",
            "",
        ])

        let stream = SSELineParser.parse(lines: lines)
        var events: [SSERawEvent] = []
        for try await event in stream {
            events.append(event)
        }

        #expect(events.count == 1)
        #expect(events[0].event == "ping")
    }

    @Test("Data without event type has nil event")
    func dataWithoutEventType() async throws {
        let lines = AsyncSequenceOf([
            "data: {\"hello\": true}",
            "",
        ])

        let stream = SSELineParser.parse(lines: lines)
        var events: [SSERawEvent] = []
        for try await event in stream {
            events.append(event)
        }

        #expect(events.count == 1)
        #expect(events[0].event == nil)
        #expect(events[0].data == "{\"hello\": true}")
    }

    @Test("Blank line without data yields nothing")
    func blankLineAlone() async throws {
        let lines = AsyncSequenceOf([
            "",
            "",
            "event: real",
            "data: {}",
            "",
        ])

        let stream = SSELineParser.parse(lines: lines)
        var events: [SSERawEvent] = []
        for try await event in stream {
            events.append(event)
        }

        #expect(events.count == 1)
        #expect(events[0].event == "real")
    }

    @Test("Flushes trailing event without final blank line")
    func trailingEvent() async throws {
        let lines = AsyncSequenceOf([
            "event: final",
            "data: {\"done\": true}",
        ])

        let stream = SSELineParser.parse(lines: lines)
        var events: [SSERawEvent] = []
        for try await event in stream {
            events.append(event)
        }

        #expect(events.count == 1)
        #expect(events[0].event == "final")
    }
}

// MARK: - Test Helper

/// A simple async sequence from an array of strings.
struct AsyncSequenceOf<Element: Sendable>: AsyncSequence {
    let elements: [Element]

    init(_ elements: [Element]) {
        self.elements = elements
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(elements: elements)
    }

    struct AsyncIterator: AsyncIteratorProtocol {
        var elements: [Element]
        var index = 0

        mutating func next() -> Element? {
            guard index < elements.count else { return nil }
            let element = elements[index]
            index += 1
            return element
        }
    }
}
