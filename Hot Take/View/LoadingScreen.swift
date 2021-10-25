import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea(.all, edges: .all)
            
            ProgressView()
                .padding()
                .background(Color.white)
                .cornerRadius(10)
        }
    }
}



