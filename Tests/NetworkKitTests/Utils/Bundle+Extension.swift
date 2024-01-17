//
//  Bundle+Extension.swift
//  MVVMDemoTests
//
//  Created by Rushi Sangani on 05/12/2023.
//

import Foundation

extension Bundle {
    
    func jsonFilePath(forName fileName: String) -> String {
        path(forResource: fileName, ofType: "json") ?? ""
    }
    
    func fileData(forResource resource: String) throws -> Data {
        let filePath = jsonFilePath(forName: resource)
        
        var url: URL
        if #available(iOS 16.0, *) {
            url = URL(filePath: filePath)
        } else {
            url = URL(fileURLWithPath: filePath)
        }
        return try Data(contentsOf: url)
    }
    
    func decodableObject<T: Decodable>(forResource resource: String, type: T.Type) throws -> T {
        let data = try fileData(forResource: resource)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
