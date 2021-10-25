import SwiftUI

struct Home: View {
    @State var selectedTab = "house.fill"
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Timeline()
                .tag("house.fll")
            Feed()
                .tag("magnifyingglass")
            likeView()
                .tag("suit.heart.fill")
            Profile()
                .tag("person.circle")
        }
        .overlay(
            VStack(spacing: 12) {
                HStack(spacing: 0) {
                    TabBarButton(image: "house.fill", selectedTab: $selectedTab)
                        .frame(maxWidth: .infinity)
                    TabBarButton(image: "magnifyingglass", selectedTab: $selectedTab)
                        .frame(maxWidth: .infinity)
                    TabBarButton(image: "suit.heart.fill", selectedTab: $selectedTab)
                        .frame(maxWidth: .infinity)
                    TabBarButton(image: "person.circle", selectedTab: $selectedTab)
                        .frame(maxWidth: .infinity)
                }
                .frame(width: 400, height: 50, alignment: .center)
                .padding()
                .border(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)))
            }
            .background(scheme == .dark ? Color.black : Color.white)
            
            ,alignment: .bottom
        )
        .ignoresSafeArea()
    }
}

struct TabBarButton: View {
    var image: String
    @Binding var selectedTab: String
    var body: some View {
        Button(action: {
            selectedTab = image
        }, label: {
            Image(systemName: image)
                .font(.title2)
                .foregroundColor(selectedTab == image ? .primary : .gray)
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
