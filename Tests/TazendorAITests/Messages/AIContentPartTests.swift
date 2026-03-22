@testable import TazendorAI
import Testing

struct AIContentPartTests {
    @Test("Text content part equality")
    func textEquality() {
        let part1: AIContentPart = .text("hello")
        let part2: AIContentPart = .text("hello")
        let part3: AIContentPart = .text("world")
        #expect(part1 == part2)
        #expect(part1 != part3)
    }

    @Test("Tool call content part")
    func toolCall() {
        let call = AIToolCall(
            id: "tc_123",
            name: "get_weather",
            arguments: .object(["city": .string("London")]),
        )
        let part: AIContentPart = .toolCall(call)

        if case let .toolCall(extracted) = part {
            #expect(extracted.id == "tc_123")
            #expect(extracted.name == "get_weather")
        } else {
            Issue.record("Expected toolCall content part")
        }
    }

    @Test("Tool result content part")
    func toolResult() {
        let result = AIToolResult(
            toolCallId: "tc_123",
            content: "72°F and sunny",
        )
        #expect(result.isError == false)

        let errorResult = AIToolResult(
            toolCallId: "tc_456",
            content: "City not found",
            isError: true,
        )
        #expect(errorResult.isError == true)
    }

    @Test("Image source factory methods")
    func imageSources() {
        let base64 = AIImageSource.base64(
            mimeType: "image/png",
            data: "iVBOR...",
        )
        #expect(base64.mimeType == "image/png")
        #expect(base64.data == "iVBOR...")
        #expect(base64.url == nil)

        let url = AIImageSource.url(
            "https://example.com/img.jpg",
        )
        #expect(url.mimeType == "image/jpeg")
        #expect(url.url == "https://example.com/img.jpg")
        #expect(url.data == nil)
    }
}
