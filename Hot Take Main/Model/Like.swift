import Foundation
import SwiftUI
import Firebase

struct like: Identifiable {
    var id = UUID().uuidString
    var username : String
    var email : String
    
    init(
        username: String = "",
        email: String = ""
    ) {
        self.username = username
        self.email = email
    }
    init(data: [String : Any]) {
        username = data["Username"] as? String ?? ""
        email = data["Email"] as? String ?? ""
    }
    static func modelToData(Like: like) -> [String:Any] {
        let data : [String:Any] = [
            "ID" : Like.id,
            "Username" : Like.username,
            "Email" : Like.email
        ]
        return data
    }
}
