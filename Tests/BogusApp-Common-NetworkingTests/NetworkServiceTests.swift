//
//  File.swift
//  
//
//  Created by Marius Ilie on 26.01.2021.
//

import XCTest
import BogusApp_Common_Networking

class NetworkServiceTest: XCTestCase {
    class MockApi: NetworkConfigurable {
        var baseURL: URL = URL(string: "http://google.com")!
        var headers: [String : String] = [:]
        var queryParameters: [String : String] = [:]
    }
    
    class MockNetworkService: NetworkService {
        
        let expectedData: Data?
        let config: NetworkConfigurable
        let decoder: JSONDecoder
        
        init(expectedData: Data?, config: NetworkConfigurable, decoder: JSONDecoder = JSONDecoder()) {
            self.expectedData = expectedData
            self.config = config
            self.decoder = decoder
        }
        
        required init(config: NetworkConfigurable, decoder: JSONDecoder = JSONDecoder()) {
            self.config = config
            self.decoder = decoder
            self.expectedData = nil
        }
        
        func request<T: Decodable, E: Requestable>(with endpoint: E,
                                                   completion: @escaping CompletionHandler<T>) -> DataRequest? {
            do {
                _ = try endpoint.urlRequest(with: config)
                completion(decode(data: expectedData))
            } catch {
                completion(.failure(error))
            }
            return nil
        }
    }
    
    class MockEndpoint: Requestable {
        var path: String
        var isFullPath: Bool = false
        var method: HTTPMethod
        var headerParamaters: [String : String] = [:]
        var queryParametersEncodable: Encodable? = nil
        var queryParameters: [String : Any] = [:]
        var bodyParamatersEncodable: Encodable? = nil
        var bodyParamaters: [String : Any] = [:]
        var bodyEncoding: BodyEncoding = .stringEncodingAscii
        
        init(path: String, method: HTTPMethod) {
            self.path = path
            self.method = method
        }
    }
    
    func test_whenDecodingResponseData_shouldReturnExpectedObject() {
        let testObject = ["test": "mock data"]
        let data = try? JSONEncoder().encode(testObject)
        let sut = MockNetworkService(expectedData: data, config: MockApi())
        _ = sut.request(with: MockEndpoint(path: "path", method: .get)) { (result: Result<[String: String], Error>) in
            switch result {
            case .failure(let error):
                XCTFail("Found error instead of String \(error)")
            case .success(let resultObj):
                XCTAssertEqual(testObject, resultObj)
            }
        }
    }
    
    func test_whenErrorEndpointGeneration_shouldReturnProperErrorEquivalent() {
        let sut = MockNetworkService(config: MockApi())
        _ = sut.request(with: MockEndpoint(path: "@^", method: .get)) { (result: Result<String, Error>) in
            switch result {
            case .failure(let error):
                switch error {
                case NetworkError.components: break
                default: XCTFail("Wrong error \(error) for mock endpoint.")
                }
            case .success(_):
                XCTFail("Success result for wrong path.")
            }
        }
    }
    
    static var allTests = [
        ("test_whenDecodingResponseData_shouldReturnExpectedObject", test_whenDecodingResponseData_shouldReturnExpectedObject),
        ("test_whenErrorEndpointGeneration_shouldReturnProperErrorEquivalent", test_whenErrorEndpointGeneration_shouldReturnProperErrorEquivalent),
    ]
}
