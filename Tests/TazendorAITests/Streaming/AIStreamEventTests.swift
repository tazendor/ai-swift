@testable import TazendorAI
import Testing

struct AIStreamEventTests {
    @Test("Text delta carries text fragment")
    func textDelta() {
        let event = AIStreamEvent.textDelta("Hello")
        if case let .textDelta(text) = event {
            #expect(text == "Hello")
        } else {
            Issue.record("Expected textDelta")
        }
    }

    @Test("Tool call start carries id and name")
    func toolCallStart() {
        let event = AIStreamEvent.toolCallStart(
            id: "tc_1",
            name: "search",
        )
        if case let .toolCallStart(id, name) = event {
            #expect(id == "tc_1")
            #expect(name == "search")
        } else {
            Issue.record("Expected toolCallStart")
        }
    }

    @Test("Tool call delta carries partial JSON")
    func toolCallDelta() {
        let event = AIStreamEvent.toolCallDelta(
            id: "tc_1",
            argumentsFragment: "{\"query\":",
        )
        if case let .toolCallDelta(id, fragment) = event {
            #expect(id == "tc_1")
            #expect(fragment == "{\"query\":")
        } else {
            Issue.record("Expected toolCallDelta")
        }
    }

    @Test("Done event carries final response")
    func doneEvent() {
        let response = AIResponse(
            id: "msg_1",
            model: "test",
            content: [.text("Done!")],
            stopReason: .endTurn,
        )
        let event = AIStreamEvent.done(response)
        if case let .done(resp) = event {
            #expect(resp.id == "msg_1")
        } else {
            Issue.record("Expected done")
        }
    }
}
