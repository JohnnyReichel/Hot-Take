import SwiftUI
import Firebase

struct Main : View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{        
            ZStack{
                if self.status {
                    Home()
                } else {
                NavigationView {
                    ZStack{
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            Text("")
                        }
                        .hidden()
                        Login(show: self.$show)
                        }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
    }
}
