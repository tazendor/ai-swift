import Foundation
@testable import TazendorAI
import Testing

struct ToolDefinitionTests {
    @Test("ToolDefinition round-trips through JSON")
    func roundTrip() throws {
        let tool = ToolDefinition(
            name: "get_weather",
            description: "Get the current weather",
            inputSchema: ToolInputSchema(
                properties: [
                    "location": .object([
                        "type": .string("string"),
                        "description": .string("City name"),
                    ]),
                ],
                required: ["location"],
            ),
        )

        let data = try JSONCoders.encoder.encode(tool)
        let decoded = try JSONCoders.decoder.decode(
            ToolDefinition.self,
            from: data,
        )

        #expect(decoded.name == "get_weather")
        #expect(decoded.description == "Get the current weather")
        #expect(decoded.inputSchema.type == "object")
        #expect(decoded.inputSchema.required == ["location"])
    }

    @Test("ToolDefinition with no description")
    func noDescription() throws {
        let tool = ToolDefinition(
            name: "noop",
            inputSchema: ToolInputSchema(),
        )

        let data = try JSONCoders.encoder.encode(tool)
        let decoded = try JSONCoders.decoder.decode(
            ToolDefinition.self,
            from: data,
        )

        #expect(decoded.name == "noop")
        #expect(decoded.description == nil)
    }

    @Test("ToolInputSchema defaults type to object")
    func schemaDefaultType() {
        let schema = ToolInputSchema()
        #expect(schema.type == "object")
        #expect(schema.properties == nil)
        #expect(schema.required == nil)
    }
}

struct ToolChoiceTests {
    @Test("Auto round-trips through JSON")
    func autoRoundTrip() throws {
        let choice: ToolChoice = .auto
        let data = try JSONCoders.encoder.encode(choice)
        let decoded = try JSONCoders.decoder.decode(
            ToolChoice.self,
            from: data,
        )
        #expect(decoded == .auto)
    }

    @Test("Any round-trips through JSON")
    func anyRoundTrip() throws {
        let choice: ToolChoice = .any
        let data = try JSONCoders.encoder.encode(choice)
        let decoded = try JSONCoders.decoder.decode(
            ToolChoice.self,
            from: data,
        )
        #expect(decoded == .any)
    }

    @Test("Tool with name round-trips through JSON")
    func toolRoundTrip() throws {
        let choice: ToolChoice = .tool(name: "get_weather")
        let data = try JSONCoders.encoder.encode(choice)
        let decoded = try JSONCoders.decoder.decode(
            ToolChoice.self,
            from: data,
        )
        #expect(decoded == .tool(name: "get_weather"))
    }

    @Test("None round-trips through JSON")
    func noneRoundTrip() throws {
        let choice: ToolChoice = .none
        let data = try JSONCoders.encoder.encode(choice)
        let decoded = try JSONCoders.decoder.decode(
            ToolChoice.self,
            from: data,
        )
        #expect(decoded == .none)
    }

    @Test("Unknown type throws decoding error")
    func unknownType() throws {
        let json = #"{"type":"unknown"}"#
        let data = Data(json.utf8)
        #expect(throws: DecodingError.self) {
            try JSONCoders.decoder.decode(
                ToolChoice.self,
                from: data,
            )
        }
    }
}
