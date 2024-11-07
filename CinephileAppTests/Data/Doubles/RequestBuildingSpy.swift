import Foundation

@testable import CinephileApp

final class RequestBuildingSpy: RequestBuilding {
    private(set) var buildRequestCalled = false
    private(set) var buildRequestPassed: Endpoint?
    var buildRequestToBeReturned: URLRequest? = nil
    
    func buildRequest(from endpoint: Endpoint) -> URLRequest? {
        buildRequestCalled = true
        buildRequestPassed = endpoint
        return buildRequestToBeReturned
    }
}
