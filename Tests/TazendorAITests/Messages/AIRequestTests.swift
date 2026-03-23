@testable import TazendorAI
import Testing

struct AIRequestTests {
    @Test("Request with minimal parameters")
    func minimal() {
        let request = AIRequest(
            model: "claude-sonnet-4-6",
            maxTokens: 1024,
            messages: [AIMessage(role: .user, text: "Hello")],
        )

        #expect(request.model == "claude-sonnet-4-6")
        #expect(request.maxTokens == 1024)
        #expect(request.messages.count == 1)
        #expect(request.systemPrompt == nil)
        #expect(request.temperature == nil)
        #expect(request.tools == nil)
        #expect(request.toolChoice == nil)
        #expect(request.stopSequences == nil)
        #expect(request.options.isEmpty)
    }

    @Test("Request with all parameters")
    func allParameters() {
        let request = AIRequest(
            model: "gpt-4o",
            maxTokens: 2048,
            messages: [
                AIMessage(role: .user, text: "What's the weather?"),
            ],
            systemPrompt: "You are a weather assistant.",
            temperature: 0.7,
            tools: [
                ToolDefinition(
                    name: "get_weather",
                    description: "Get weather",
                    inputSchema: ToolInputSchema(),
                ),
            ],
            toolChoice: .auto,
            stopSequences: ["END"],
            options: [
                AIOptionKey(rawValue: "test.key"): .bool(true),
            ],
        )

        #expect(request.systemPrompt == "You are a weather assistant.")
        #expect(request.temperature == 0.7)
        #expect(request.tools?.count == 1)
        #expect(request.toolChoice == .auto)
        #expect(request.stopSequences == ["END"])
        #expect(request.options.count == 1)
    }
}

struct AIOptionKeyTests {
    @Test("Option keys with same raw value are equal")
    func equality() {
        let key1 = AIOptionKey(rawValue: "test.key")
        let key2 = AIOptionKey(rawValue: "test.key")
        #expect(key1 == key2)
    }

    @Test("Option keys with different raw values are not equal")
    func inequality() {
        let key1 = AIOptionKey(rawValue: "test.key1")
        let key2 = AIOptionKey(rawValue: "test.key2")
        #expect(key1 != key2)
    }
}
