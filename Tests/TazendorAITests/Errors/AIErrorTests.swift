@testable import TazendorAI
import Testing

struct AIErrorTests {
    @Test("API error description includes status code")
    func apiErrorDescription() {
        let error = AIError.apiError(
            statusCode: 429,
            message: "Rate limit exceeded",
        )
        let description = error.description
        #expect(description.contains("429"))
        #expect(description.contains("Rate limit exceeded"))
    }

    @Test("Invalid request description includes reason")
    func invalidRequestDescription() {
        let error = AIError.invalidRequest(
            reason: "Model not specified",
        )
        #expect(error.description.contains("Model not specified"))
    }

    @Test("Provider error description includes provider name")
    func providerErrorDescription() {
        struct TestError: Error, Sendable {
            let message: String
        }
        let error = AIError.providerError(
            provider: "anthropic",
            underlying: TestError(message: "test"),
        )
        #expect(error.description.contains("anthropic"))
    }

    @Test("Network error wraps underlying error")
    func networkError() {
        struct TestError: Error, Sendable {
            var localizedDescription: String {
                "Connection lost"
            }
        }
        let error = AIError.networkError(
            underlying: TestError(),
        )
        #expect(error.description.contains("Network error"))
    }

    @Test("Decoding error wraps underlying error")
    func decodingError() {
        struct TestError: Error, Sendable {
            var localizedDescription: String {
                "Bad JSON"
            }
        }
        let error = AIError.decodingError(
            underlying: TestError(),
        )
        #expect(error.description.contains("Decoding error"))
    }
}
