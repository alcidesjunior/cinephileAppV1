import Foundation

protocol Endpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension Endpoint {
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
}
