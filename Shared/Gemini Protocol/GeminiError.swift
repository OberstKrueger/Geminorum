public enum GeminiError: Error, Equatable {
    case invalidScheme(String)
    case invalidURL(String)

    // DELETE THIS
    case testError
}
