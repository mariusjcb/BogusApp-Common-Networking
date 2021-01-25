//
//  NetworkError.swift
//  BougsApp-iOS
//
//  Created by Marius Ilie on 23/01/2021.
//

import Foundation

public enum NetworkError: Error {
    case urlGeneration
    case noResponse
    case components
}
