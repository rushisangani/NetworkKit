//
//  APIResponseHandler.swift
//  MVVMDemo
//
//  Created by Rushi Sangani on 30/11/2023.
//

import Foundation
import Combine

// MARK: - ResponseHandler

protocol ResponseHandler {
    func getResponse<T: Decodable>(from response: Data) throws -> T
}

// MARK: - APIResponseHandler

struct APIResponseHandler: ResponseHandler {
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func getResponse<T: Decodable>(from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw RequestError.decode(description: error.localizedDescription)
        }
    }
}
