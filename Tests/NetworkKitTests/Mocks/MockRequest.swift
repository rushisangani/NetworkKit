//
//  File.swift
//  
//
//  Created by Rushi Sangani on 17/01/2024.
//

import Foundation
@testable import NetworkKit

public struct MockCommentsRequest: Request {
    public var scheme: String { "https" }
    public var host: String { "jsonplaceholder.typicode.com" }
    public var path: String { "/comments" }
    
    var url: URL {
        try! createURLRequest().url!
    }
}
