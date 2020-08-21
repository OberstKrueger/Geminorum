enum GeminiStatusCode: UInt8 {
    case input = 10
    case sensitiveInput = 11

    case success = 20

    case temporaryRedirect = 30
    case permanentRedirect = 31

    case temporaryFailure = 40
    case serverUnavailable = 41
    case CGIError = 42
    case proxyError = 43
    case slowDown = 44

    case permanentFailure = 50
    case notFound = 51
    case gone = 52
    case proxyRequestRefused = 53
    case badRequest = 59

    case clientCertificateRequired = 60
    case certificateNotAuthorised = 61
    case certificateNotValid = 62
}
