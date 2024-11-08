import Foundation

final class NetworkManager: NetworkManaging {
    private let urlSession: URLSession
    private let requestBuilder: RequestBuilding
    
    init(requestBuilder: RequestBuilding, urlSession: URLSession) {
        self.requestBuilder = requestBuilder
        self.urlSession = urlSession
    }
    
    func performRequest<T>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        guard let request = requestBuilder.buildRequest(from: endpoint) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else  {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.badStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum NetworkError: Error, Equatable {
    case invalidRequest
    case noData
    case invalidResponse
    case badStatusCode(Int)
}
