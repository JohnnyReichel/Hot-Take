import SwiftUI
import Firebase

struct checkProfile: View {
    var Take: take
    
    @Binding var profileActive: Bool
    
    @State var currentUser = false
    
    @State var editProfileActive = false
    
    @State var followActive = false
    
    @State var followed = ""
    
    @State var likeActive = false
    
    @State var selectedTake = take()
    
    @ObservedObject var CheckProfileViewModel = checkProfileViewModel()
    
    @ObservedObject var FollowViewModel = followViewModel()
    
    var body: some View {
        if likeActive {
            VStack {
                HStack(spacing: 15) {
                    Button(action: {
                        likeActive.toggle()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.primary)
                    })
                    Spacer()
                }
                .padding()
                .overlay(
                    Text("Likes")
                        .font(.title2)
                        .fontWeight(.bold)
                )
                Divider()
                checkLike(Take: Take)
            }
        } else if editProfileActive {
            VStack {
                HStack(spacing: 15) {
                    Button(action: {
                        editProfileActive.toggle()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.primary)
                    })
                    Spacer()
                }
                .padding()
                .overlay(
                    Text("Edit Profile")
                        .font(.title2)
                        .fontWeight(.bold)
                )
                Divider()
                EditProfile()
            }
        } else {
            VStack(alignment: .leading) {
                HStack(spacing: 15) {
                    Button(action: {
                        profileActive.toggle()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.primary)
                    })
                    Spacer()
                }
                .padding()
                .overlay(
                    Text("Profile")
                        .font(.title2)
                        .fontWeight(.bold)
                )
                Divider()
                HStack(spacing: 60) {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                    VStack {
                        Text(Take.username)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Button(action: {
                            currentUser ? editProfileActive.toggle() : followUser(Take: Take)
                        }
                        , label: {
                            HStack {
                                Spacer(minLength: 0)
                                Text(currentUser ? "Edit Profile" : followed)
                                Spacer(minLength: 0)
                                Image(systemName: "arrow.right")
                            }
                            .frame(width: 125)
                            .foregroundColor(Color.black)
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(Color.white)
                            .border(Color.black)
                        })
                    }
                }
                .padding()
                
                Divider()
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 0) {
                        ForEach(CheckProfileViewModel.takes){take in
                            profileTakeCardView(Take: take, likeActive: $likeActive, selectedTake: $selectedTake)
                        }
                    }
                    .padding(.bottom, 65)
                })
                
            }
            .onAppear(perform: {
                if Take.email == Auth.auth().currentUser?.email {
                    CheckProfileViewModel.fetchCheckProfileInformation(Take: Take)
                    currentUser = true
                } else {
                    FollowViewModel.fetchFollow(Follow: follow.init(username: Take.username, email: Take.email))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    CheckProfileViewModel.fetchCheckProfileInformation(Take: Take)
                    followed = FollowViewModel.followed
                    }
                }
            })
        }
    }
    
    func followUser(Take: take) {
        if followed == "Unfollow" {
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("following").document(Take.username).delete()
            followed = "Follow"
        } else {
            let data = follow.modelToData(Follow: follow.init(username: Take.username, email: Take.email))
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("following").document(Take.username).setData(data)
            followed = "Unfollow"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        CheckProfileViewModel.fetchCheckProfileInformation(Take: Take)
        }
    }
}

struct profileTakeCardView: View {
    var Take: take
    
    @Binding var likeActive: Bool
    @Binding var selectedTake: take
    
    @ObservedObject var CheckLikeProfileViewModel = checkLikeProfileViewModel()
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                Text(Take.username)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            
            VStack(spacing: 15) {
                Text(Take.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(Take.take)
                    .padding(.horizontal)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.15)))
            .cornerRadius(15)
            
            HStack(spacing: 15) {
                Button(action: {
                    likeActive.toggle()
                    selectedTake = Take
                }, label: {
                    Text("\(CheckLikeProfileViewModel.likes.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                })
                Button(action: {
                    if CheckLikeProfileViewModel.liked == "suit.heart" {
                        print("like")
                        likeTake(likedTake: Take, likedUser: CheckLikeProfileViewModel.User)
                        CheckLikeProfileViewModel.liked = "suit.heart.fill"
                    } else {
                        print("dislike")
                        dislikeTake(dislikedTake: Take, dislikedUser: CheckLikeProfileViewModel.User)
                        CheckLikeProfileViewModel.liked = "suit.heart"
                    }
                }, label: {
                    Image(systemName: CheckLikeProfileViewModel.liked)
                        .font(.system(size: 25))
                        .foregroundColor(Color.init(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)))
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 25))
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "bookmark")
                        .font(.system(size: 25))
                })
            }
            .foregroundColor(.primary)
            
            
            Divider()
                .padding(.horizontal, -15)
        }
        .onAppear(perform: {
            CheckLikeProfileViewModel.fetchCheckLikeProfileInformation(Take: Take)
        })
        .padding()
    }
}

struct checkProfile_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
