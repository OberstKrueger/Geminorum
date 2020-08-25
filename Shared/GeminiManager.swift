import Combine
import Foundation
import Network

class GeminiManager: ObservableObject {
    @Published var page: GeminiPage?

    func geminiTransaction(input: String) {
        DispatchQueue.global().async {
            let request: Data
            let url: URL

            switch self.verifyURL(url: input) {
            case .failure(let error):
                // Process error message to Gemini body
                return
            case .success(let verifiedURL):
                url = verifiedURL
            }

            switch self.createRequest(url: url) {
            case .failure(let error):
                // Process error message to Gemini body
                return
            case .success(let pageRequest):
                request = pageRequest
            }

            let host = NWEndpoint.Host(url.host!)
            let port = NWEndpoint.Port(rawValue: UInt16(url.port ?? 1965))!

            let connection = NWConnection(host: host, port: port, using: .tls)

            connection.stateUpdateHandler = { state in
                switch state {
                case .cancelled:
                    break
                case .failed(_):
                    break
                case .preparing:
                    break
                case .ready:
                    connection.send(content: request, completion: .contentProcessed({ error in
                        if let error = error {}
                    }))
                    connection.receiveMessage { content, _, _, error in
                        if let content = content {
                            let newPage = GeminiPage(response: String(data: content, encoding: .utf8)!)

                            DispatchQueue.main.async {
                                self.page = newPage
                            }
                        }
                    }
                case .setup:
                    break
                case .waiting(_):
                    break
                }
            }

            connection.start(queue: DispatchQueue.global())
        }
    }

    func createRequest(url: URL) -> Result<Data, GeminiError> {
        if let scheme = url.scheme, let authority = url.host {
            let request = "\(scheme)://\(authority)\(url.path)/\r\n"

            if let data = request.data(using: .utf8) {
                if data.count > 1_024 {
                    return .failure(.requestTooLarge(data.count))
                }

                return .success(data)
            } else {
                return .failure(.requestInvalid)
            }
        } else {
            return .failure(.URLInvalid(url.absoluteString))
        }
    }

    func verifyURL(url: String) -> Result<URL, GeminiError> {
        if var components = URLComponents(string: url.contains("://") ? url : "gemini://" + url) {
            // Check scheme
            switch components.scheme {
            case "gemini":
                // The scheme is correct, so nothing is to be done.
                break
            default:
                // Forced unwrapping due to nil case being acounted for already.
                return .failure(.schemeInvalid(components.scheme!))
            }

            // Check port
            if components.port == nil { components.port = 1965 }

            if let output = components.url {
                return .success(output)
            } else {
                return .failure(.URLInvalid(url))
            }
        } else {
            return .failure(.URLInvalid(url))
        }
    }
}
