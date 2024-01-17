//
//  File.swift
//  
//
//  Created by Rushi Sangani on 17/01/2024.
//

import Foundation
import Combine

// MARK: - NetworkHandler

public protocol NetworkHandler {
    func fetch<T: Decodable>(request: Request) async throws -> T
    func fetch<T: Decodable>(request: Request) -> AnyPublisher<T, RequestError>
}

// MARK: - NetworkManager

public final class NetworkManager: NetworkHandler {
    var requestHandler: RequestHandler
    var responseHandler: ResponseHandler
    
    init(requestHandler: RequestHandler = APIRequestHandler(),
         responseHandler: ResponseHandler = APIResponseHandler()
    ) {
        self.requestHandler = requestHandler
        self.responseHandler = responseHandler
    }
    
    public func fetch<T>(request: Request) async throws -> T where T : Decodable {
        let data = try await requestHandler.sendRequest(request)
        return try responseHandler.getResponse(from: data)
    }
    
    public func fetch<T>(request: Request) -> AnyPublisher<T, RequestError> where T : Decodable {
        return requestHandler
            .sendRequest(request)
            .tryMap { data -> T in
                return try self.responseHandler.getResponse(from: data)
            }
            .mapError { error -> RequestError in
                return RequestError.decode(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
