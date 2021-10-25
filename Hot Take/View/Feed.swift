import SwiftUI
import Firebase

struct Feed: View {
    
    @State var showingSheet = false
    
    @State var likeActive = false
    @State var profileActive = false
    @State var selectedTake = take()
    
    @ObservedObject var FeedViewModel = feedViewModel()
    
    var body: some View {
        if profileActive {
            checkProfile(Take: selectedTake, profileActive: $profileActive)
        } else if likeActive {
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
            checkLike(Take: selectedTake)
            }
        } else {
        VStack {
            HStack(spacing: 15) {
                Button(action: {
                    showingSheet.toggle()
                }, label: {
                    Image(systemName: "plus.app")
                        .font(.title)
                        .foregroundColor(.primary)
                })
                Spacer()
            }
            .padding()
            .overlay(
                Text("Explore")
                    .font(.title2)
                    .fontWeight(.bold)
            )
            Divider()
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 0) {
                    ForEach(FeedViewModel.takes){take in
                        takeCardView(Take: take, likeActive: $likeActive, profileActive: $profileActive, selectedTake: $selectedTake)
                    }
                }
                .padding(.bottom, 65)
            })
        }
        .sheet(isPresented: $showingSheet) {
            PostView()
                .cornerRadius(20)
        }
        .onAppear(perform: {
            FeedViewModel.fetchFeedInformation()
            })
        }
    }
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct takeCardView: View {
    var Take: take
    
    @Binding var likeActive: Bool
    @Binding var profileActive: Bool
    @Binding var selectedTake: take
    
    @ObservedObject var UserViewModel = userViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                Button(action: {
                    self.profileActive.toggle()
                    self.selectedTake = Take
                }, label: {
                    Text(Take.username)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                })
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
                    self.likeActive.toggle()
                    self.selectedTake = Take
                }, label: {
                    Text("\(UserViewModel.likes.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                })
                Button(action: {
                    if UserViewModel.liked == "suit.heart" {
                    print("like")
                    likeTake(likedTake: Take, likedUser: UserViewModel.User)
                        UserViewModel.liked = "suit.heart.fill"
                    } else {
                    print("dislike")
                        dislikeTake(dislikedTake: Take, dislikedUser: UserViewModel.User)
                        UserViewModel.liked = "suit.heart"
                    }
                }, label: {
                    Image(systemName: UserViewModel.liked)
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
            UserViewModel.fetchUserInformation(Take: Take)
        })
        .padding()
    }
}
