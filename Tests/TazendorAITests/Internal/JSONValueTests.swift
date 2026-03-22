import Foundation
@testable import TazendorAI
import Testing

struct JSONValueTests {
    // MARK: - Codable Round-Trips

    @Test("String round-trips through JSON")
    func stringRoundTrip() throws {
        let value: JSONValue = .string("hello")
        let data = try JSONCoders.encoder.encode(value)
        let decoded = try JSONCoders.decoder.decode(
            JSONValue.self,
            from: data,
        )
        #expect(decoded == value)
    }

    @Test("Number round-trips through JSON")
    func numberRoundTrip() throws {
        let value: JSONValue = .number(42.5)
        let data = try JSONCoders.encoder.encode(value)
        let decoded = try JSONCoders.decoder.decode(
            JSONValue.self,
            from: data,
        )
        #expect(decoded == value)
    }

    @Test("Bool round-trips through JSON")
    func boolRoundTrip() throws {
        let value: JSONValue = .bool(true)
        let data = try JSONCoders.encoder.encode(value)
        let decoded = try JSONCoders.decoder.decode(
            JSONValue.self,
            from: data,
        )
        #expect(decoded == value)
    }

    @Test("Null round-trips through JSON")
    func nullRoundTrip() throws {
        let value: JSONValue = .null
        let data = try JSONCoders.encoder.encode(value)
        let decoded = try JSONCoders.decoder.decode(
            JSONValue.self,
            from: data,
        )
        #expect(decoded == value)
    }

    @Test("Array round-trips through JSON")
    func arrayRoundTrip() throws {
        let value: JSONValue = .array([.string("a"), .number(1)])
        let data = try JSONCoders.encoder.encode(value)
        let decoded = try JSONCoders.decoder.decode(
            JSONValue.self,
            from: data,
        )
        #expect(decoded == value)
    }

    @Test("Object round-trips through JSON")
    func objectRoundTrip() throws {
        let value: JSONValue = .object([
            "name": .string("test"),
            "count": .number(3),
        ])
        let data = try JSONCoders.encoder.encode(value)
        let decoded = try JSONCoders.decoder.decode(
            JSONValue.self,
            from: data,
        )
        #expect(decoded == value)
    }

    @Test("Nested structure round-trips through JSON")
    func nestedRoundTrip() throws {
        let value: JSONValue = .object([
            "users": .array([
                .object([
                    "name": .string("Alice"),
                    "active": .bool(true),
                    "tags": .array([.string("admin")]),
                ]),
            ]),
            "metadata": .null,
        ])
        let data = try JSONCoders.encoder.encode(value)
        let decoded = try JSONCoders.decoder.decode(
            JSONValue.self,
            from: data,
        )
        #expect(decoded == value)
    }

    // MARK: - Literal Conformances

    @Test("String literal creates string value")
    func stringLiteral() {
        let value: JSONValue = "hello"
        #expect(value == .string("hello"))
    }

    @Test("Integer literal creates number value")
    func integerLiteral() {
        let value: JSONValue = 42
        #expect(value == .number(42.0))
    }

    @Test("Float literal creates number value")
    func floatLiteral() {
        let value: JSONValue = 3.14
        #expect(value == .number(3.14))
    }

    @Test("Boolean literal creates bool value")
    func boolLiteral() {
        let value: JSONValue = true
        #expect(value == .bool(true))
    }

    @Test("Array literal creates array value")
    func arrayLiteral() {
        let value: JSONValue = ["a", "b"]
        #expect(value == .array([.string("a"), .string("b")]))
    }

    @Test("Dictionary literal creates object value")
    func dictionaryLiteral() {
        let value: JSONValue = ["key": "value"]
        #expect(value == .object(["key": .string("value")]))
    }

    @Test("Nil literal creates null value")
    func nilLiteral() {
        let value: JSONValue = nil
        #expect(value == .null)
    }

    // MARK: - Hashable

    @Test("Equal values have same hash")
    func hashableEquality() {
        let val1: JSONValue = .string("test")
        let val2: JSONValue = .string("test")
        #expect(val1.hashValue == val2.hashValue)
    }

    @Test("JSONValues work as dictionary keys")
    func dictionaryKey() {
        var dict: [JSONValue: String] = [:]
        dict[.string("key")] = "value"
        #expect(dict[.string("key")] == "value")
    }
}
