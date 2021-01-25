//
//  Endpoint.swift
//  BougsApp-iOS
//
//  Created by Marius Ilie on 23/01/2021.
//

import Foundation
import Alamofire

public class Endpoint: Requestable {

    public var path: String
    public var isFullPath: Bool
    public var method: HTTPMethod
    public var headerParamaters: [String: String]
    public var queryParametersEncodable: Encodable?
    public var queryParameters: [String: Any]
    public var bodyParamatersEncodable: Encodable?
    public var bodyParamaters: [String: Any]
    public var bodyEncoding: BodyEncoding

    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethod,
         headerParamaters: [String: String] = [:],
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String: Any] = [:],
         bodyParamatersEncodable: Encodable? = nil,
         bodyParamaters: [String: Any] = [:],
         bodyEncoding: BodyEncoding = .jsonSerializationData) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParamaters = headerParamaters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParamatersEncodable = bodyParamatersEncodable
        self.bodyParamaters = bodyParamaters
        self.bodyEncoding = bodyEncoding
    }
}

public protocol EndpointProvider: Requestable {
    func endpoint() -> Endpoint
}

public extension EndpointProvider {
    func endpoint() -> Endpoint {
        .init(path: self.path,
              isFullPath: self.isFullPath,
              method: self.method,
              headerParamaters: self.headerParamaters,
              queryParametersEncodable: self.queryParametersEncodable,
              queryParameters: self.queryParameters,
              bodyParamatersEncodable: self.bodyParamatersEncodable,
              bodyParamaters: self.bodyParamaters,
              bodyEncoding: self.bodyEncoding)
    }
}
