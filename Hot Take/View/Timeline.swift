import SwiftUI
import Firebase

struct Timeline: View {
    
    @State var showingSheet = false
    
    @State var likeActive = false
    @State var profileActive = false
    @State var selectedTake = take()
    
    @State var takes = [take]()
    
    @ObservedObject var TimelineViewModel = timelineViewModel()
    
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
                Text("Feed")
                    .font(.title2)
                    .fontWeight(.bold)
            )
            Divider()
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 0) {
                    ForEach(TimelineViewModel.takes){take in
                        takeCardView(Take: take, likeActive: $likeActive, profileActive: $profileActive, selectedTake: $selectedTake)
                    }
                }
                .padding(.bottom, 65)
            })
        }
        .onAppear(perform: {
            TimelineViewModel.fetchTimelineInformation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                TimelineViewModel.listener?.remove()
            }
        })
        .sheet(isPresented: $showingSheet) {
            PostView()
                .cornerRadius(20)
            }
        }
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
