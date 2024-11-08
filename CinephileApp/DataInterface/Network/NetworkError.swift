import Foundation

enum NetworkError: Error, Equatable {
    case invalidRequest
    case noData
    case invalidResponse
    case badStatusCode(Int)
}
