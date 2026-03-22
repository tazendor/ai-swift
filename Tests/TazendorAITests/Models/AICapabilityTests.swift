@testable import TazendorAI
import Testing

struct AICapabilityTests {
    @Test("Built-in capabilities have correct raw values")
    func builtInRawValues() {
        #expect(AICapability.textGeneration.rawValue == "textGeneration")
        #expect(AICapability.streaming.rawValue == "streaming")
        #expect(AICapability.toolUse.rawValue == "toolUse")
        #expect(AICapability.vision.rawValue == "vision")
        #expect(AICapability.jsonMode.rawValue == "jsonMode")
    }

    @Test("Custom capabilities can be created")
    func customCapability() {
        let thinking = AICapability(rawValue: "thinking")
        #expect(thinking.rawValue == "thinking")
    }

    @Test("Capabilities work in sets")
    func setOperations() {
        let caps: Set<AICapability> = [
            .textGeneration,
            .streaming,
            .toolUse,
        ]

        #expect(caps.contains(.streaming))
        #expect(!caps.contains(.vision))
        #expect(caps.count == 3)
    }

    @Test("Same capability is equal regardless of construction")
    func equality() {
        let cap1 = AICapability.streaming
        let cap2 = AICapability(rawValue: "streaming")
        #expect(cap1 == cap2)
    }
}

struct AIModelInfoTests {
    @Test("Model info with all fields")
    func allFields() {
        let model = AIModelInfo(
            id: "claude-sonnet-4-6",
            displayName: "Claude Sonnet 4.6",
            provider: "anthropic",
            capabilities: [.textGeneration, .streaming, .toolUse],
            contextWindow: 200_000,
            maxOutputTokens: 8192,
        )

        #expect(model.id == "claude-sonnet-4-6")
        #expect(model.displayName == "Claude Sonnet 4.6")
        #expect(model.provider == "anthropic")
        #expect(model.capabilities.count == 3)
        #expect(model.contextWindow == 200_000)
        #expect(model.maxOutputTokens == 8192)
    }

    @Test("Model info with minimal fields")
    func minimal() {
        let model = AIModelInfo(
            id: "local-model",
            displayName: "Local Model",
            provider: "ollama",
        )

        #expect(model.capabilities.isEmpty)
        #expect(model.contextWindow == nil)
        #expect(model.maxOutputTokens == nil)
    }
}
