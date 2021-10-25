import SwiftUI
import Firebase
import IQKeyboardManagerSwift

struct PostView: View {
    @State var take: String = ""
    @State var title: String = ""
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var titleBindingManager = TextBindingManager(limit: 20)
    @ObservedObject var takeBindingManager = TextBindingManager(limit: 150)
    @ObservedObject var postViewModel = submitTakeViewModel()
        
    var body: some View {
            VStack {
                HStack(spacing: 15) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.black)
                    })
                    Spacer()
                }
                .padding()
                .overlay(
                    Text("Hot Take")
                        .font(.title2)
                        .fontWeight(.bold)
                )
                Divider()
                VStack(alignment: .leading) {
                
                Text("Title:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("", text: $titleBindingManager.text)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.leading, .trailing])
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding([.leading, .trailing])
                Text("Take:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    TextEditor(text: $takeBindingManager.text)
                    .frame(height: 345)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.leading, .trailing])
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding([.leading, .trailing])
                    Button(action: {
                        postViewModel.post(title: titleBindingManager.text, text: takeBindingManager.text)
                        titleBindingManager.text = ""
                        takeBindingManager.text = ""
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Spacer(minLength: 0)
                            Text("Post")
                            Spacer(minLength: 0)
                        }
                        .foregroundColor(Color.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color.red)
                        .cornerRadius(10)
                        })
                        .padding()
                        .disabled((titleBindingManager.text != "" && takeBindingManager.text != "") ? false : true)
                        .opacity((titleBindingManager.text != "" && takeBindingManager.text != "") ? 1 : 0.6)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}

