import XCTest

@testable import CinephileApp

final class NetworkManagerTests: XCTestCase {
    private let requestBuilderSpy = RequestBuildingSpy()
    private let urlSessionSpy = URLSessionMock()

    private lazy var sut = NetworkManager(requestBuilder: requestBuilderSpy, urlSession: urlSessionSpy)

    func test_performRequest_whenCalled_requestBuilderIsInvoked() {
        let dummyEndpoint = MockEndpoint()
        sut.performRequest(endpoint: dummyEndpoint) { (result: Result<DummyCodable, Error>) in }
        
        XCTAssertTrue(requestBuilderSpy.buildRequestCalled)
        XCTAssertEqual(requestBuilderSpy.buildRequestPassed?.path, dummyEndpoint.path)
    }
    
    func test_performRequest_whenRequestIsValid_performsDataTask() {
        let dummyEndpoint = MockEndpoint()
        requestBuilderSpy.buildRequestToBeReturned = URLRequest(url: URL(string: "https://api.dummy.com/dummy/endpoint")!)

        var expectedResult: Result<DummyCodable, Error>?
        let expectation = self.expectation(description: "Data task should complete")

        // Configurando os dados do mock
        let userData = "{}".data(using: .utf8)
        urlSessionSpy.setMockData(userData)
        urlSessionSpy.setMockResponse(HTTPURLResponse(url: URL(string: "https://api.dummy.com/dummy/endpoint")!, statusCode: 200, httpVersion: nil, headerFields: nil))

        sut.performRequest(endpoint: dummyEndpoint) { (result: Result<DummyCodable, Error>) in
            expectedResult = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch expectedResult {
        case .success(let data):
            XCTAssertNotNil(data)
        default:
            XCTFail("Unexpected result")
        }
    }

    func test_performRequest_whenRequestIsNil_returnsFailure() {
        let dummyEndpoint = MockEndpoint()
        requestBuilderSpy.buildRequestToBeReturned = nil
        let expectation = self.expectation(description: "Completion should be called with failure")
        
        sut.performRequest(endpoint: dummyEndpoint) { (result: Result<DummyCodable, Error>) in
            switch result {
            case .success:
                XCTFail("Fail was expected")
            case .failure:
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_performRequest_whenStatusCodeIsNot200_returnsFailure() {
        let dummyEndpoint = MockEndpoint()
        requestBuilderSpy.buildRequestToBeReturned = URLRequest(url: URL(string: "https://api.dummy.com/dummy/endpoint")!)
        
        let expectation = self.expectation(description: "Completion should be called with failure")
        
        // Configurando um status code 404 no mock
        urlSessionSpy.setMockResponse(HTTPURLResponse(url: URL(string: "https://api.dummy.com/dummy/endpoint")!, statusCode: 404, httpVersion: nil, headerFields: nil))

        sut.performRequest(endpoint: dummyEndpoint) { (result: Result<DummyCodable, Error>) in
            switch result {
            case .success:
                XCTFail("Fail was expected")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.badStatusCode(404))
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_performRequest_whenDecodingFails_returnsFailure() {
        let dummyEndpoint = MockEndpoint()
        requestBuilderSpy.buildRequestToBeReturned = URLRequest(url: URL(string: "https://api.dummy.com/dummy/endpoint")!)
        let invalidJSONData = "{ \"invalidKey\": \"invalidValue\" }".data(using: .utf8)
        
        let expectation = self.expectation(description: "Completion should be called with failure")
        
        // Configurando dados inválidos para falha na decodificação
        urlSessionSpy.setMockData(invalidJSONData)
        
        sut.performRequest(endpoint: dummyEndpoint) { (result: Result<DummyCodable, Error>) in
            switch result {
            case .success:
                XCTFail("Fail was expected")
            case .failure:
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
