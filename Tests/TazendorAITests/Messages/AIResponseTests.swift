@testable import TazendorAI
import Testing

struct AIResponseTests {
    @Test("Response with all fields")
    func allFields() {
        let response = AIResponse(
            id: "msg_123",
            model: "claude-sonnet-4-6",
            content: [.text("Hello!")],
            stopReason: .endTurn,
            usage: AIUsage(inputTokens: 10, outputTokens: 5),
        )

        #expect(response.id == "msg_123")
        #expect(response.model == "claude-sonnet-4-6")
        #expect(response.content.count == 1)
        #expect(response.stopReason == .endTurn)
        #expect(response.usage?.inputTokens == 10)
        #expect(response.usage?.outputTokens == 5)
    }

    @Test("Response with minimal fields")
    func minimal() {
        let response = AIResponse(
            id: "msg_456",
            model: "gpt-4o",
            content: [],
        )

        #expect(response.stopReason == nil)
        #expect(response.usage == nil)
    }
}

struct AIStopReasonTests {
    @Test("All stop reasons have correct raw values")
    func rawValues() {
        #expect(AIStopReason.endTurn.rawValue == "endTurn")
        #expect(AIStopReason.maxTokens.rawValue == "maxTokens")
        #expect(AIStopReason.toolUse.rawValue == "toolUse")
        #expect(AIStopReason.stopSequence.rawValue == "stopSequence")
        #expect(AIStopReason.contentFilter.rawValue == "contentFilter")
    }
}

struct AIUsageTests {
    @Test("Usage stores token counts")
    func tokenCounts() {
        let usage = AIUsage(inputTokens: 100, outputTokens: 50)
        #expect(usage.inputTokens == 100)
        #expect(usage.outputTokens == 50)
    }

    @Test("Usage is equatable")
    func equatable() {
        let usage1 = AIUsage(inputTokens: 10, outputTokens: 5)
        let usage2 = AIUsage(inputTokens: 10, outputTokens: 5)
        #expect(usage1 == usage2)
    }
}
