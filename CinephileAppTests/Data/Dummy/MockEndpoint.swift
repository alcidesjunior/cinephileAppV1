import Foundation

@testable import CinephileApp

struct MockEndpoint: Endpoint {
    var baseURL: URL?
    var path: String
    var method: HTTPMethod
    var headers: [String: String]?
    var parameters: [String: Any]?

    init(
        baseURL: URL? = URL(string: "https://api.dummy.com"),
        path: String = "/dummy/endpoint",
        method: HTTPMethod = .GET,
        headers: [String: String]? = ["Authorization": "Bearer dummyAccessToken"],
        parameters: [String: Any]? = ["dummyKey": "dummyValue"]
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
    }
}

