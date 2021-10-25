import SwiftUI
import Firebase

struct EditProfile: View {
    
    @ObservedObject var ProfileViewModel = profileViewModel()
    
    @State var color = Color.black.opacity(0.7)
    @State var firstName = ""
    @State var lastName = ""
    @State var phoneNumber = ""
    var body: some View {
    VStack {
        VStack(alignment: .leading) {
        Text("First Name")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.bottom, -25)
            .foregroundColor(.primary)
        TextField(ProfileViewModel.User.firstName, text: self.$firstName)
        .autocapitalization(.none)
        .padding()
        .background(RoundedRectangle(cornerRadius: 4).stroke(self.firstName != "" ? Color("Color") : self.color,lineWidth: 2))
        .padding(.top, 25)
        }
        VStack(alignment: .leading) {
        Text("Last Name")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .padding(.bottom, -25)
        TextField(ProfileViewModel.User.lastName, text: self.$lastName)
        .autocapitalization(.none)
        .padding()
        .background(RoundedRectangle(cornerRadius: 4).stroke(self.lastName != "" ? Color("Color") : self.color,lineWidth: 2))
        .padding(.top, 25)
        }
        VStack(alignment: .leading) {
        Text("Phone Number")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.bottom, -25)
            .foregroundColor(.primary)
        TextField(ProfileViewModel.User.phoneNumber, text: self.$phoneNumber)
        .keyboardType(.phonePad)
        .autocapitalization(.none)
        .padding()
        .background(RoundedRectangle(cornerRadius: 4).stroke(self.phoneNumber != "" ? Color("Color") : self.color,lineWidth: 2))
        .padding(.top, 25)
        }
        Button(action: {
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").setData(["First Name": firstName, "Last Name": lastName, "Phone Number": phoneNumber], merge: true)
        }) {
            Text("Save")
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 50)
        }
        .background(Color("Color"))
        .cornerRadius(10)
        .padding(.top, 25)
        Button(action: {
            UserDefaults.standard.set(false, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
        }) {
            Text("Log out")
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 50)
        }
        .background(Color("Color"))
        .cornerRadius(10)
        .padding(.top, 25)
        Spacer()
        }
        .onAppear(perform: {
            ProfileViewModel.fetchProfileInformation()
        })
        .padding(.horizontal, 25)
        .cornerRadius(10)
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

