public enum GeminiError: Error, Equatable {
    case schemeInvalid(String)

    case requestInvalid
    case requestTooLarge(Int)

    case URLInvalid(String)
}
