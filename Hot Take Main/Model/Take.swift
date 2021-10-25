import Foundation

struct take: Identifiable {
    var id = UUID().uuidString
    var username : String
    var email : String
    var profileImage : String
    var title : String
    var take : String
    var time : String

init(
        username: String = "",
        email: String = "",
        profileImage: String = "",
        title: String = "",
        take: String = "",
        time: String = ""
    ) {
        self.username = username
        self.email = email
        self.profileImage = profileImage
        self.title = title
        self.take = take
        self.time = time
    }
    
    init(data: [String : Any]) {
        username = data["Username"] as? String ?? ""
        email = data["Email"] as? String ?? ""
        profileImage = data["Profile Image"] as? String ?? ""
        title = data["Title"] as? String ?? ""
        take = data["Take"] as? String ?? ""
        time = data["Time"] as? String ?? ""
    }
    
    static func modelToData(Take: take) -> [String:Any] {
        let data : [String:Any] = [
            "ID" : Take.id,
            "Username" : Take.username,
            "Email" : Take.email,
            "Profile Image" : Take.profileImage,
            "Title" : Take.title,
            "Take" : Take.take,
            "Time" : Take.time,
        ]
        return data
    }
}

