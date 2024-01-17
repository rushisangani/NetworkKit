//
//  NetworkManagerTests.swift
//  MVVMDemoTests
//
//  Created by Rushi Sangani on 30/11/2023.
//

import XCTest
import Combine
@testable import NetworkKit

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkHandler!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }
    
    func testNetworkManagerGetComments() async throws {
        networkManager = NetworkManager(
            requestHandler: MockAPIRequestHandler(shouldSucceed: true),
            responseHandler: MockAPIResponseHandler(shouldSucceed: true)
        )
        
        var comments: [CommentModel] = []
        let request = MockCommentsRequest()
        
        let expectation = XCTestExpectation(description: "NetworkManager Get Comments")
        do {
            comments = try await networkManager.fetch(request: request)
            expectation.fulfill()

            // verify data correctness
            let comment = try XCTUnwrap(comments.first)
            XCTAssert(comment.id == 1)
            XCTAssert(comment.name == "id labore ex et quam laborum")
            XCTAssert(comment.email == "Eliseo@gardner.biz")
        }
        catch {
            print(error)
            XCTFail("Expected NetworkManager should complete fetch request.")
        }
    }
    
    func testNetworkManagerThrowsError() async throws {
        networkManager = NetworkManager(
            requestHandler: MockAPIRequestHandler(shouldSucceed: false),
            responseHandler: MockAPIResponseHandler(shouldSucceed: false)
        )
        
        let request = MockCommentsRequest()
        
        let expectation = XCTestExpectation(description: "NetworkManager throws error")
        do {
            let _: [CommentModel] = try await networkManager!.fetch(request: request)
            XCTFail("Expected NetworkManager should throw error while getting comments")
        }
        catch RequestError.noData {
            expectation.fulfill()
        }
    }
}

// MARK: - Mocks

fileprivate class MockAPIRequestHandler: RequestHandler {
    
    private let shouldSucceed: Bool
    // Important to get bundle as below
    private var bundle: Bundle {
        Bundle.module
    }
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func sendRequest(_ request: Request) async throws -> Data {
        if shouldSucceed {
            return try bundle.fileData(forResource: "comments")
        }
        throw RequestError.noData
    }
    
    func sendRequest(_ request: Request) -> AnyPublisher<Data, RequestError> {
        if shouldSucceed {
            let data = try! bundle.fileData(forResource: "comments")
            return Just(data)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
            
        }
        return Fail(error: RequestError.noData)
            .eraseToAnyPublisher()
    }
}

fileprivate class MockAPIResponseHandler: ResponseHandler {
    private let shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func getResponse<T>(from response: Data) throws -> T where T : Decodable {
        if shouldSucceed {
            try JSONDecoder().decode(T.self, from: response)
        } else {
            throw RequestError.decode(description: "No data")
        }
    }
}

// MARK: - Model

struct CommentModel: Decodable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
