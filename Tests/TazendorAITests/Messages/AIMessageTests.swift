@testable import TazendorAI
import Testing

struct AIMessageTests {
    @Test("Text convenience creates single text part")
    func textConvenience() {
        let message = AIMessage(role: .user, text: "Hello")
        #expect(message.role == .user)
        #expect(message.content.count == 1)
        if case let .text(text) = message.content[0] {
            #expect(text == "Hello")
        } else {
            Issue.record("Expected text content part")
        }
    }

    @Test("Multi-part message preserves all parts")
    func multiPart() {
        let message = AIMessage(
            role: .assistant,
            content: [
                .text("Here's the result:"),
                .toolCall(AIToolCall(
                    id: "tc_1",
                    name: "search",
                    arguments: .object(["query": .string("test")]),
                )),
            ],
        )
        #expect(message.content.count == 2)
    }

    @Test("AIMessage is equatable")
    func equatable() {
        let msg1 = AIMessage(role: .user, text: "Hi")
        let msg2 = AIMessage(role: .user, text: "Hi")
        let msg3 = AIMessage(role: .assistant, text: "Hi")
        #expect(msg1 == msg2)
        #expect(msg1 != msg3)
    }
}

struct AIMessageRoleTests {
    @Test("Roles have correct raw values")
    func rawValues() {
        #expect(AIMessageRole.system.rawValue == "system")
        #expect(AIMessageRole.user.rawValue == "user")
        #expect(AIMessageRole.assistant.rawValue == "assistant")
    }
}
