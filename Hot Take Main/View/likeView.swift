import SwiftUI
import Firebase


struct likeView: View {
    
    @State var showingSheet = false
    
    @State var likeActive = false
    @State var profileActive = false
    @State var selectedTake = take()
    
    @ObservedObject var LikeViewModel = likeViewModel()
    
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
                Text("Likes")
                    .font(.title2)
                    .fontWeight(.bold)
            )
            Divider()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 0) {
                    ForEach(LikeViewModel.takes){take in
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
            self.LikeViewModel.fetchLikeInformation()
        })
        }
    }
}

