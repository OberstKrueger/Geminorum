/// Gemini uses two-digit numeric status codes. Related status codes share the same first digit. Importantly, the first
/// digit of Gemini status codes do not group codes into vague categories like "client error" and "server error" as per
/// HTTP. Instead, the first digit alone provides enough information for a client to determine how to handle the
/// response. By design, it is possible to write a simple but feature complete client which only looks at the first
/// digit. The second digit provides more fine-grained information, for unambiguous server logging, to allow writing
/// comfier interactive clients which provide a slightly more streamlined user interface, and to allow writing more
/// robust and intelligent automated clients like content aggregators, search engine crawlers, etc.
enum GeminiStatusCode: UInt8 {
    /// The requested resource accepts a line of textual user input. The <META> line is a prompt which should be
    /// displayed to the user. The same resource should then be requested again with the user's input included as a
    /// query component. Queries are included in requests as per the usual generic URL definition in RFC3986, i.e.
    /// separated from the path by a ?. Reserved characters used in the user's input must be "percent-encoded" as per
    /// RFC3986, and space characters should also be percent-encoded.
    case input = 10

    /// As per status code 10, but for use with sensitive input such as passwords. Clients should present the prompt as per status code 10, but the user's input should not be echoed to the screen to prevent it being read by "shoulder surfers".
    case sensitiveInput = 11

    /// The request was handled successfully and a response body will follow the response header. The <META> line is a MIME media type which applies to the response body.
    case success = 20

    /// The server is redirecting the client to a new location for the requested resource. There is no response body. <META> is a new URL for the requested resource. The URL may be absolute or relative. The redirect should be considered temporary, i.e. clients should continue to request the resource at the original address and should not performance convenience actions like automatically updating bookmarks. There is no response body.
    case temporaryRedirect = 30

    /// The requested resource should be consistently requested from the new URL provided in future. Tools like search engine indexers or content aggregators should update their configurations to avoid requesting the old URL, and end-user clients may automatically update bookmarks, etc. Note that clients which only pay attention to the initial digit of status codes will treat this as a temporary redirect. They will still end up at the right place, they just won't be able to make use of the knowledge that this redirect is permanent, so they'll pay a small performance penalty by having to follow the redirect each time.
    case permanentRedirect = 31

    /// The request has failed. There is no response body. The nature of the failure is temporary, i.e. an identical request MAY succeed in the future. The contents of <META> may provide additional information on the failure, and should be displayed to human users.
    case temporaryFailure = 40

    /// The server is unavailable due to overload or maintenance. (cf HTTP 503)
    case serverUnavailable = 41

    /// A CGI process, or similar system for generating dynamic content, died unexpectedly or timed out.
    case CGIError = 42

    /// A proxy request failed because the server was unable to successfully complete a transaction with the remote
    /// host. (cf HTTP 502, 504)
    case proxyError = 43

    /// Rate limiting is in effect. <META> is an integer number of seconds which the client must wait before another
    /// request is made to this server. (cf HTTP 429)
    case slowDown = 44

    /// The request has failed. There is no response body. The nature of the failure is permanent, i.e. identical
    /// future requests will reliably fail for the same reason. The contents of <META> may provide additional
    /// information on the failure, and should be displayed to human users. Automatic clients such as aggregators or
    /// indexing crawlers should not repeat this request.
    case permanentFailure = 50

    /// The requested resource could not be found but may be available in the future. (cf HTTP 404) (struggling to
    /// remember this important status code? Easy: you can't find things hidden at Area 51!)
    case notFound = 51

    /// The resource requested is no longer available and will not be available again. Search engines and similar tools
    /// should remove this resource from their indices. Content aggregators should stop requesting the resource and convey to their human users that the subscribed resource is gone. (cf HTTP 410)
    case gone = 52

    /// The request was for a resource at a domain not served by the server and the server does not accept proxy
    /// requests.
    case proxyRequestRefused = 53

    /// The server was unable to parse the client's request, presumably due to a malformed request. (cf HTTP 400)
    case badRequest = 59

    /// The requested resource requires a client certificate to access. If the request was made without a certificate,
    /// it should be repeated with one. If the request was made with a certificate, the server did not accept it and
    /// the request should be repeated with a different certificate. The contents of <META> (and/or the specific 6x
    /// code) may provide additional information on certificate requirements or the reason a certificate was rejected.
    case clientCertificateRequired = 60

    /// The supplied client certificate is not authorised for accessing the particular requested resource. The problem
    /// is not with the certificate itself, which may be authorised for other resources.
    case certificateNotAuthorised = 61

    /// The supplied client certificate was not accepted because it is not valid. This indicates a problem with the
    /// certificate in and of itself, with no consideration of the particular requested resource. The most likely cause
    /// is that the certificate's validity start date is in the future or its expiry date has passed, but this code may
    /// also indicate an invalid signature, or a violation of a X509 standard requirements. The <META> should provide
    /// more information about the exact error.
    case certificateNotValid = 62
}

