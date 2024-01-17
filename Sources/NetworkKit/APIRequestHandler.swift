//
//  APIRequestHandler.swift
//  MVVMDemo
//
//  Created by Rushi Sangani on 30/11/2023.
//

import Foundation
import Combine

// MARK: - RequestHandler

public protocol RequestHandler {
    func sendRequest(_ request: Request) async throws -> Data
    func sendRequest(_ request: Request) -> AnyPublisher<Data, RequestError>
}

// MARK: - APIRequestHandler

public struct APIRequestHandler: RequestHandler {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func sendRequest(_ request: Request) async throws -> Data {
        let urlRequest = try request.createURLRequest()
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.failed(description: "Request Failed.")
        }
        switch response.statusCode {
        case 200...299:
            return data
        case 401:
            throw RequestError.unauthorized
        default:
            throw RequestError.unexpectedStatusCode(description: "Status Code: \(response.statusCode)")
        }
    }
    
    public func sendRequest(_ request: Request) -> AnyPublisher<Data, RequestError> {
        guard let urlRequest = try? request.createURLRequest() else {
            return Fail(error: RequestError.invalidURL)
                .eraseToAnyPublisher()
        }
        return session
            .dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global())
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RequestError.failed(description: "Request Failed.")
                }
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                case 401:
                    throw RequestError.unauthorized
                default:
                    throw RequestError.unexpectedStatusCode(description: "Status Code: \(httpResponse.statusCode)")
                }
            }
            .mapError { error -> RequestError in
                if let requestError = error as? RequestError {
                    return requestError
                }
                return RequestError.unknown
            }
            .eraseToAnyPublisher()
    }
}
