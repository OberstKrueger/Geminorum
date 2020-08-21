import Combine
import Foundation
import Network

class GeminiManager: ObservableObject {
    @Published var page: GeminiPage?

    func loadPage(url: String) {
        switch processURL(url: url) {
        case .success(let checkedURL):
            let request = "\(checkedURL.scheme!)://\(checkedURL.host!)\(checkedURL.path)/\r\n"

            let host = NWEndpoint.Host(checkedURL.host!)
            let port = NWEndpoint.Port(rawValue: UInt16(checkedURL.port ?? 1965))!

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
                    connection.send(content: request.data(using: .utf8)!, completion: .contentProcessed({ error in
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
        case .failure(let error):
            break
        }
    }

    func processURL(url: String) -> Result<URL, GeminiError> {
        if var components = URLComponents(string: url.contains("://") ? url : "gemini://" + url) {
            // Check scheme
            switch components.scheme {
            case "gemini":
                // The scheme is correct, so nothing is to be done.
                break
            default:
                // Forced unwrapping due to nil case being acounted for already.
                return .failure(.invalidScheme(components.scheme!))
            }

            // Check port
            if components.port == nil { components.port = 1965 }

            if let output = components.url {
                return .success(output)
            } else {
                return .failure(.invalidURL(url))
            }
        } else {
            return .failure(.invalidURL(url))
        }
    }
}

