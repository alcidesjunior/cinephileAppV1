import Foundation

final class URLSessionMock: URLSession {
    private var mockData: Data?
    private var mockResponse: URLResponse?
    private var mockError: Error?

    // Inicializador para definir dados, resposta e erro
    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }
    
    // Métodos para configurar mock de dados, resposta e erro
    func setMockData(_ data: Data?) {
        self.mockData = data
    }

    func setMockResponse(_ response: URLResponse?) {
        self.mockResponse = response
    }

    func setMockError(_ error: Error?) {
        self.mockError = error
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(mockData, mockResponse, mockError)
        return URLSessionDataTaskMock()
    }
}

final class URLSessionDataTaskMock: URLSessionDataTask {
    override func resume() {}
}
