//
//  InferredPost.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

func inferredView(post: Post) -> some View {
    return ZStack {
        switch(post.contentType) {
        case "text":
            NavigationLink {
                EmptyView()
            } label: {
                Text(post.content!).lineLimit(3)
            }
        case "video","image","embed","gallery":
            NavigationLink {
                EmptyView()
            } label: {}
            Rectangle().aspectRatio(16/9,contentMode: .fit).foregroundColor(.clear)
            AsyncImage(url: post.thumbnail) { Image in
                Image.resizable()
            } placeholder: {
                ProgressView().tint(.gray)
            }.aspectRatio(contentMode: .fit).layoutPriority(-1)
        case "link":
            Link("\(post.urls![0])", destination: post.urls![0]).frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.accentColor)
        default:
            Text("No Content Type")
        }
    }
}
