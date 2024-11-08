import Foundation

struct RequestBuilder: RequestBuilding {
    func buildRequest(from endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.baseURL?.appendingPathComponent(endpoint.path) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = endpoint.parameters, endpoint.method == .GET {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            request.url = urlComponents?.url ?? url
        }
        
        if endpoint.method == .POST, let parameters = endpoint.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
}
