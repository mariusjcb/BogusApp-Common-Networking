//
//  NetworkService.swift
//  BougsApp-iOS
//
//  Created by Marius Ilie on 23/01/2021.
//

import Alamofire
import Foundation

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias DataRequest = Alamofire.DataRequest

public protocol NetworkService {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    var config: NetworkConfigurable { get }
    var decoder: JSONDecoder { get }
    
    init(config: NetworkConfigurable, decoder: JSONDecoder)
    
    func decode<T: Decodable>(data: Data?) -> Result<T, Error>
    @discardableResult
    func request<T: Decodable, E: Requestable>(with endpoint: E,
                                               completion: @escaping CompletionHandler<T>) -> DataRequest?
}

public extension NetworkService {
    func decode<T: Decodable>(data: Data?) -> Result<T, Error> {
        do {
            guard let data = data else { return .failure(NetworkError.noResponse) }
            let result: T = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}

public final class DefaultNetworkService: NetworkService {
    
    public let config: NetworkConfigurable
    public let decoder: JSONDecoder

    public init(config: NetworkConfigurable, decoder: JSONDecoder = JSONDecoder()) {
        self.config = config
        self.decoder = decoder
    }

    public func request<T, E>(with endpoint: E,
                              completion: @escaping CompletionHandler<T>)
        -> DataRequest? where T : Decodable, E : Requestable {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(error))
            return nil
        }
    }

    // MARK: - Private
    private func request<T: Decodable>(request: URLRequest,
                                       completion: @escaping CompletionHandler<T>)
        -> DataRequest {
        AF.request(request)
            .responseData { [weak self] response in
                guard let `self` = self else { return }
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                completion(self.decode(data: response.data))
            }.resume()
    }
}
