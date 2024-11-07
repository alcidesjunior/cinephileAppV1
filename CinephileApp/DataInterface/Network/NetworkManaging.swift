import Foundation

protocol NetworkManaging {
    func performRequest<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}
