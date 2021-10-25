import Foundation

struct user {
    var id = UUID().uuidString
    var firstName: String
    var lastName: String
    var username: String
    var profilePicture: String
    var email: String
    var phoneNumber: String
    var password: String
    
    init(
        firstName:String = "",
        lastName: String = "",
        username: String = "",
        profilePicture: String = "",
        email: String = "",
        phoneNumber: String = "",
        password: String = ""
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.profilePicture = profilePicture
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
    }
    
    init(data: [String : Any]) {
        firstName = data["First Name"] as? String ?? ""
        lastName = data["Last Name"] as? String ?? ""
        username = data["Username"] as? String ?? ""
        profilePicture = data["Profile Picture"] as? String ?? ""
        email = data["Email"] as? String ?? ""
        phoneNumber = data["Phone Number"] as? String ?? ""
        password = data["Password"] as? String ?? ""
    }
    
    static func modelToData(User: user) -> [String:Any] {
        let data : [String:Any] = [
            "ID" : User.id,
            "First Name" : User.firstName,
            "Last Name" : User.lastName,
            "Username" : User.username,
            "Profile Picture" : User.profilePicture,
            "Email" : User.email,
            "Phone Number" : User.phoneNumber,
            "Password" : User.password
        ]
        return data
    }
}

