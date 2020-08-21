import Foundation

public struct GeminiPage {
    var statusCode: GeminiStatusCode?
    var statusMeta: String?
    var body: String?

    init(response: String) {
        body = response
    }
}
