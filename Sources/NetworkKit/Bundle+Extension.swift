//
//  Bundle+Extension.swift
//  MVVMDemoTests
//
//  Created by Rushi Sangani on 05/12/2023.
//

import Foundation

extension Bundle {
    
    public func jsonFilePath(forName fileName: String) -> String {
        path(forResource: fileName, ofType: "json") ?? ""
    }
    
    public func fileData(forResource resource: String) throws -> Data {
        let filePath = jsonFilePath(forName: resource)
        
        var url: URL
        if #available(iOS 16.0, watchOS 9.0, macOS 13.0, *) {
            url = URL(filePath: filePath)
        } else {
            url = URL(fileURLWithPath: filePath)
        }
        return try Data(contentsOf: url)
    }
    
    public func decodableObject<T: Decodable>(forResource resource: String, type: T.Type) throws -> T {
        let data = try fileData(forResource: resource)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
