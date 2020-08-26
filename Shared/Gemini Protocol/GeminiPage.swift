import Foundation

public struct GeminiPage {
    var statusCode: GeminiStatusCode?
    var statusMeta: String?
    var bodyResponse: String?

    var body: String {
        switch (statusCode, statusMeta) {
        default:
            return ""
        }

    }

    init(response: String) {
        for components in response.split(separator: "\r\n").enumerated() {
            if components.offset == 0 {
                for headerComponent in components.element.split(separator: " ").enumerated()  {
                    if headerComponent.offset == 0 {
                        if let validNumber = UInt8(headerComponent.element) {
                            switch GeminiStatusCode(rawValue: validNumber) {
                            case .none:
                                break
                            case .some(let code):
                                statusCode = code
                            }
                        }
                    } else {
                        statusMeta = String(headerComponent.element)
                    }
                }
            } else {
                bodyResponse = String(components.element)
            }
        }
    }
}
