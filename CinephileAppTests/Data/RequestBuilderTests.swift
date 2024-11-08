import XCTest

@testable import CinephileApp

import XCTest

final class RequestBuilderTests: XCTestCase {
    private let sut = RequestBuilder()
    
    func test_buildRequest_withGETMethodAndParameters_shouldAddParametersToURL() {
        let dummyEndpoint = MockEndpoint()
        
        let request = sut.buildRequest(from: dummyEndpoint)
        
        XCTAssertEqual(request?.url?.absoluteString, "https://api.dummy.com/dummy/endpoint?dummyKey=dummyValue")
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), "Bearer dummyAccessToken")
    }

    func test_buildRequest_withPOSTMethodAndParameters_shouldAddParametersToHTTPBody() {
        var dummyEndpoint = MockEndpoint(method: .POST)
        
        let request = sut.buildRequest(from: dummyEndpoint)
        
        XCTAssertEqual(request?.url?.absoluteString, "https://api.dummy.com/dummy/endpoint")
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), "Bearer dummyAccessToken")
        
        if let body = request?.httpBody {
            let json = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: Any]
            XCTAssertEqual(json?["dummyKey"] as? String, "dummyValue")
        } else {
            XCTFail("Expected HTTP body but found nil.")
        }
    }
    
    func test_buildRequest_whenBaseURLIsNil_shouldReturnNil() {
        struct InvalidEndpoint: Endpoint {
            var baseURL: URL? { nil }
            var path: String { "/invalid" }
            var method: HTTPMethod { .GET }
        }
        
        let invalidEndpoint = InvalidEndpoint()
        let request = sut.buildRequest(from: invalidEndpoint)
        
        XCTAssertNil(request, "Expected request to be nil when base URL is nil.")
    }
}

