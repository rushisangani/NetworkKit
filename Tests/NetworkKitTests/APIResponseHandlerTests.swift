//
//  APIResponseHandlerTests.swift
//  MVVMDemoTests
//
//  Created by Rushi Sangani on 30/11/2023.
//

import XCTest
@testable import NetworkKit

final class APIResponseHandlerTests: XCTestCase {
    var responseHandler: ResponseHandler!
    
    override func setUpWithError() throws {
        responseHandler = APIResponseHandler()
    }

    override func tearDownWithError() throws {
        responseHandler = nil
    }
    
    func testAPIResponseHandlerParseSuccess() throws {
        let postData = MockResponse.postData
        
        let result: PostModel = try responseHandler!.getResponse(from: postData)
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
    }
    
    func testAPIResponseHandlerParseFailure() throws {
        let dummyData = MockResponse.dummyData
        let expectation = XCTestExpectation(description: "APIResponseHandler throws decode error")
        
        do {
            let _: PostModel = try responseHandler!.getResponse(from: dummyData)
            XCTFail("APIResponseHandler should throw decode error")
        }
        catch RequestError.decode {
            expectation.fulfill()
        }
    }
}

// MARK: - Model

struct PostModel: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
