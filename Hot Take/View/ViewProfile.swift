//
//  Profile.swift
//  Hot Take
//
//  Created by John Reichel on 3/24/21.
//

import SwiftUI
import Firebase

struct checkProfile: View {
    var Take: take
    
    @State var likeActive = false
    
    @ObservedObject var viewProfileInformationViewModel = viewProfileViewModel()
    
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
            LikeTableview(Take: Take)
            }
        } else {
        VStack(alignment: .leading) {
            HStack(spacing: 60) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                VStack {
                Text(Take.username)
                    .font(.title2)
                    .fontWeight(.semibold)
                Button(action: {
                    
                }
                , label: {
                    HStack {
                        Spacer(minLength: 0)
                        Text("Follow")
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
            
            Divider()
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 0) {
                    ForEach(viewProfileInformationViewModel.takes){take in
                        profileTakeCardView(Take: take, likeActive: $likeActive)
                    }
                }
                .padding(.bottom, 65)
            })
        }
        .onAppear(perform: {
            viewProfileInformationViewModel.fetchViewProfileInformation(Take: Take)
            })
        }
    }
}

struct profileTakeCardView: View {
    var Take: take
    
    @Binding var likeActive: Bool
    @ObservedObject var profileLikeViewModel = profileLikeModel()
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                Text(Take.username)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
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
                    likeActive.toggle()
                }, label: {
                    Text("\(profileLikeViewModel.likes.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                })
                Button(action: {
                    if profileLikeViewModel.liked == "suit.heart" {
                    print("like")
                        likeTake(likedTake: Take, likedUser: profileLikeViewModel.User)
                        profileLikeViewModel.liked = "suit.heart.fill"
                    } else {
                    print("dislike")
                        dislikeTake(dislikedTake: Take, dislikedUser: profileLikeViewModel.User)
                        profileLikeViewModel.liked = "suit.heart"
                    }
                }, label: {
                    Image(systemName: profileLikeViewModel.liked)
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
            profileLikeViewModel.fetchUserInformation(Take: Take)
        })
        .padding()
    }
}
