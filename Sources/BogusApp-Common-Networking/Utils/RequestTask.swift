//
//  RequestTask.swift
//  BougsApp-iOS
//
//  Created by Marius Ilie on 22/01/2021.
//

import Foundation
import BogusApp_Common_Utils

public class RepositoryTask: Cancellable {
    public var networkTask: NetworkCancellable?
    public var isCancelled: Bool = false
    
    public init() { }
    
    public func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
