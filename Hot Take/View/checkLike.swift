import SwiftUI
import Firebase

struct checkLike: View {
    var Take: take
    
    @State var likeUser = like()
    
    @ObservedObject var LikeDetailViewModel = likeDetailViewModel()
    
    var body: some View {
        VStack() {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .leading) {
                    ForEach(LikeDetailViewModel.likes){like in
                        LikeCardView(Like: like)
                    }
                }
                .padding(.bottom, 65)
            })
        }
        .onAppear(perform: {
            self.LikeDetailViewModel.fetchLikeDetailInformation(Take: Take)
            })
    }
}

struct LikeCardView: View {
    var Like: like
    
    var body: some View {
        HStack(spacing: 15) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            Text(Like.username)
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
        .padding()
        Divider()
    }
}

struct LikeTableview_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
