import Foundation
import SwiftUI
import Firebase

struct follow: Identifiable {
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
    static func modelToData(Follow: follow) -> [String:Any] {
        let data : [String:Any] = [
            "ID" : Follow.id,
            "Username" : Follow.username,
            "Email" : Follow.email
        ]
        return data
    }
}
