import SwiftUI
import Firebase

struct Profile: View {    
    @State private var showingSheet = false
    
    @State var likeActive = false
    @State var editProfileActive = false
    @State var selectedTake = take()
    
    @ObservedObject var ProfileViewModel = profileViewModel()
    
    
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
            checkLike(Take: selectedTake)
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
                    self.showingSheet.toggle()
                }, label: {
                    Image(systemName: "plus.app")
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
                Text(ProfileViewModel.User.username)
                    .font(.title2)
                    .fontWeight(.semibold)
                Button(action: {
                    editProfileActive.toggle()
                }
                , label: {
                    HStack {
                        Spacer(minLength: 0)
                        Text("Edit Profile")
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
            .sheet(isPresented: $showingSheet) {
                PostView()
                    .cornerRadius(20)
            }
            Divider()
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 0) {
                    ForEach(ProfileViewModel.takes){take in
                        profileTakeCardView(Take: take, likeActive: $likeActive, selectedTake: $selectedTake)
                    }
                }
                .padding(.bottom, 65)
            })
        }
        .onAppear(perform: {
            self.ProfileViewModel.fetchProfileInformation()
            })
        }
    }
}

