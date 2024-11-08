import Foundation

protocol RequestBuilding {
    func buildRequest(from endpoint: Endpoint) -> URLRequest?
}
