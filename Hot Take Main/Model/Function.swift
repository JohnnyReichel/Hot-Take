//
//  Function.swift
//  Hot Take
//
//  Created by John Reichel on 4/27/21.
//

import Foundation
import SwiftUI
import Firebase

func dislikeTake(dislikedTake: take, dislikedUser: user ) {
    let likeRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("Liked Takes")
    likeRef.document(dislikedTake.title).delete()
    
    Firestore.firestore().collection("Hot Takes").document(dislikedTake.username + ": " + dislikedTake.title).collection("Likes").document(dislikedUser.username).delete()
}

func likeTake(likedTake: take, likedUser: user) {
    let Like = like.init(username: likedUser.username)
    
    Firestore.firestore().collection("Hot Takes").document(likedTake.username + ": " + likedTake.title).collection("Likes").document(likedUser.username).setData(like.modelToData(Like: Like))
    
    let likeRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "").collection("Liked Takes").document(likedTake.title)
            likeRef.setData(
                take.modelToData(Take: likedTake)
            )
}
