//
//  APIResponseHandler.swift
//  MVVMDemo
//
//  Created by Rushi Sangani on 30/11/2023.
//

import Foundation
import Combine

// MARK: - ResponseHandler

public protocol ResponseHandler {
    func getResponse<T: Decodable>(from response: Data) throws -> T
}

// MARK: - APIResponseHandler

public struct APIResponseHandler: ResponseHandler {
    let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    public func getResponse<T: Decodable>(from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw RequestError.decode(description: error.localizedDescription)
        }
    }
}
