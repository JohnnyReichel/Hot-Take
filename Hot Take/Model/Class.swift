import Foundation
import Firebase
import SwiftUI

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}

class submitTakeViewModel: ObservableObject {
    var alert = false
    var error = ""
    
    func post(title: String, text: String) {
    Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").addSnapshotListener { (querySnapshot, err) in
        if err != nil{
            self.error = err!.localizedDescription
            self.alert.toggle()
            return
        }
        
        guard let data = querySnapshot?.data() else { return }
        let User = user.init(data: data)
        let Take = take.init(username: User.username, email: User.email, profileImage: "", title: title, take: text, time: "")
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("Hot Takes").document(title).setData(
                take.modelToData(Take: Take)
            )
        Firestore.firestore().collection("Hot Takes").document(User.username + ": " + title).setData(
                take.modelToData(Take: Take)
            )
        }
    }
}

class userViewModel: ObservableObject {
    @Published var takes = [take]()
    @Published var likes = [like]()
    @Published var likesCheck = [like]()
    @Published var User = user()
    @Published var liked = "suit.heart"
    
    @State var alert = false
    @State var error = ""
    
    func fetchUserInformation(Take: take) {
        Firestore.firestore().collection("Hot Takes").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            self.takes = documents.map { queryDocumentSnapshot -> take in
                let data = queryDocumentSnapshot.data()
                return take.init(data: data)
            }
        }
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").addSnapshotListener { (querySnapshot, err) in
            if err != nil{
                self.error = err!.localizedDescription
                self.alert.toggle()
                return
            }
            guard let data = querySnapshot?.data() else { return }
            self.User = user.init(data: data)
            
            Firestore.firestore().collection("Hot Takes").document(Take.username + ": " + Take.title).collection("Likes").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                      print("No documents")
                      return
                    }
                    self.likes = documents.map { queryDocumentSnapshot -> like in
                        let data = queryDocumentSnapshot.data()
                        return like.init(data: data)
                }
                if self.likes.contains(where: { $0.username == self.User.username}) {
                    self.liked = "suit.heart.fill"
                }
            }
        }
    }
}

class feedViewModel: ObservableObject {
    @Published var takes = [take]()
    
    func fetchFeedInformation() {
    Firestore.firestore().collection("Hot Takes").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        self.takes = documents.map { queryDocumentSnapshot -> take in
            let data = queryDocumentSnapshot.data()
            return take.init(data: data)
            }
        }
    }
}

class timelineViewModel: ObservableObject {
    var listener : ListenerRegistration? = nil
    
    @Published var follows = [follow]()
    
    @Published var takes = [take]()
    
    func fetchTimelineInformation() {
        listener = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("following").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        self.follows = documents.map { queryDocumentSnapshot -> follow in
            let data = queryDocumentSnapshot.data()
            return follow.init(data: data)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.follows.count == 0 {
                self.takes.removeAll()
            } else {
            for i in 0...self.follows.count-1 {
                Firestore.firestore().collection("Users").document(self.follows[i].email).collection("Hot Takes").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                  print("No documents")
                  return
                }
                self.takes = documents.map { queryDocumentSnapshot -> take in
                    let data = queryDocumentSnapshot.data()
                    return take.init(data: data)
                        }
                    }
                }
            }
        }
    }
}

class profileViewModel: ObservableObject {
    @Published var takes = [take]()
    @Published var User = user()
    
    @State var alert = false
    @State var error = ""
    
    func fetchProfileInformation() {
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").addSnapshotListener { (querySnapshot, err) in
            if err != nil{
                self.error = err!.localizedDescription
                self.alert.toggle()
                return
            }
            guard let data = querySnapshot?.data() else { return }
            self.User = user.init(data: data)
            
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("Hot Takes").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                  print("No documents")
                  return
                }
                self.takes = documents.map { queryDocumentSnapshot -> take in
                    let data = queryDocumentSnapshot.data()
                    return take.init(data: data)
                }
            }
        }
    }
}

class checkProfileViewModel: ObservableObject {
    @Published var takes = [take]()
    
    @State var alert = false
    @State var error = ""
    
    func fetchCheckProfileInformation(Take: take) {
        Firestore.firestore().collection("Users").document(Take.email).collection("Hot Takes").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            self.takes = documents.map { queryDocumentSnapshot -> take in
                let data = queryDocumentSnapshot.data()
                return take.init(data: data)
            }
        }
    }
}

class checkLikeProfileViewModel: ObservableObject {
    @Published var takes = [take]()
    @Published var likes = [like]()
    @Published var likesCheck = [like]()
    @Published var User = user()
    @Published var liked = "suit.heart"
    
    @State var alert = false
    @State var error = ""
    
    func fetchCheckLikeProfileInformation(Take: take) {
        Firestore.firestore().collection("Hot Takes").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            self.takes = documents.map { queryDocumentSnapshot -> take in
                let data = queryDocumentSnapshot.data()
                return take.init(data: data)
            }
        }
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").addSnapshotListener { (querySnapshot, err) in
            if err != nil{
                self.error = err!.localizedDescription
                self.alert.toggle()
                return
            }
            guard let data = querySnapshot?.data() else { return }
            self.User = user.init(data: data)
            
            Firestore.firestore().collection("Hot Takes").document(Take.username + ": " + Take.title).collection("Likes").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                      print("No documents")
                      return
                    }
                    self.likes = documents.map { queryDocumentSnapshot -> like in
                        let data = queryDocumentSnapshot.data()
                        return like.init(data: data)
                }
                if self.likes.contains(where: { $0.username == self.User.username}) {
                    self.liked = "suit.heart.fill"
                }
            }
        }
    }
}

class likeViewModel: ObservableObject {
    @Published var takes = [take]()
    @Published var User = user()
    
    @State var alert = false
    @State var error = ""
    
    func fetchLikeInformation() {
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").addSnapshotListener { (querySnapshot, err) in
            if err != nil{
                self.error = err!.localizedDescription
                self.alert.toggle()
                return
            }
            guard let data = querySnapshot?.data() else { return }
            self.User = user.init(data: data)
            
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("Liked Takes").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                  print("No documents")
                  return
                }
                self.takes = documents.map { queryDocumentSnapshot -> take in
                    let data = queryDocumentSnapshot.data()
                    return take.init(data: data)
                }
            }
        }
    }
}

class likeDetailViewModel: ObservableObject {
    @Published var likes = [like]()
    
    @State var alert = false
    @State var error = ""
    
    func fetchLikeDetailInformation(Take: take) {
            Firestore.firestore().collection("Hot Takes").document(Take.username + ": " + Take.title).collection("Likes").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                      print("No documents")
                      return
                    }
                    self.likes = documents.map { queryDocumentSnapshot -> like in
                        let data = queryDocumentSnapshot.data()
                        return like.init(data: data)
            }
        }
    }
}

class followViewModel: ObservableObject {
    @Published var follows = [follow]()
    @Published var followed = "Follow"
    
    @State var alert = false
    @State var error = ""
    
    
    func fetchFollow(Follow: follow) {
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("following").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                      print("No documents")
                      return
                    }
                    self.follows = documents.map { queryDocumentSnapshot -> follow in
                        let data = queryDocumentSnapshot.data()
                        return follow.init(data: data)
                }
                if self.follows.contains(where: { $0.username == Follow.username}) {
                    self.followed = "Unfollow"
            }
        }
    }
}

