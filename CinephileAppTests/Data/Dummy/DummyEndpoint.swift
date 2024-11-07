import Foundation

@testable import CinephileApp

struct DummyEndpoint: Endpoint {
    var baseURL: URL? {
        return URL(string: "https://api.dummy.com")
    }
    
    var path: String {
        return "/dummy/endpoint"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: [String: String]? {
        return [
            "Authorization": "Bearer dummyAccessToken"
        ]
    }
    
    var parameters: [String: Any]? {
        return [
            "dummyKey": "dummyValue"
        ]
    }
}
