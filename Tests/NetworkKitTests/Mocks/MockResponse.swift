//
//  File.swift
//  
//
//  Created by Rushi Sangani on 17/01/2024.
//

import Foundation

public struct MockResponse {
    
    static var commentData: Data {
        let jsonString = "{\r\n\"postId\": 3,\r\n\"id\": 11,\r\n\"name\": \"fugit labore quia mollitia quas deserunt nostrum sunt\",\r\n\"email\": \"Veronica_Goodwin@timmothy.net\",\r\n\"body\": \"ut dolorum nostrum id quia aut est\\nfuga est inventore vel eligendi explicabo quis consectetur\\naut occaecati repellat id natus quo est\\nut blanditiis quia ut vel ut maiores ea\"\r\n}"
        return jsonString.data(using: .utf8)!
    }
    
    static var postData: Data {
        let json = "{\r\n\"userId\": 1,\r\n\"id\": 1,\r\n\"title\": \"sunt aut facere repellat provident occaecati excepturi optio reprehenderit\",\r\n\"body\": \"quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto\"\r\n}"
        return json.data(using: .utf8)!
    }
    
    static var dummyData: Data {
        "dummyText".data(using: .utf8)!
    }
}
