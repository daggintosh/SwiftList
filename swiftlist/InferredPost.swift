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
                PostView(post: post)
            } label: {
                Text(post.content!).lineLimit(3).frame(maxWidth: .infinity, alignment: .leading)
            }
        case "video","image","embed","gallery":
            NavigationLink {
                PostView(post: post)
            } label: {}
            Rectangle().aspectRatio(16/9,contentMode: .fit).foregroundColor(.clear)
            AsyncImage(url: post.thumbnail) { Image in
                Image.resizable()
            } placeholder: {
                ProgressView().tint(.gray)
            }.aspectRatio(contentMode: .fit).layoutPriority(-1)
        case "link":
            NavigationLink {
                PostView(post: post)
            } label: {
                Text("\(post.urls![0])").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.accentColor).lineLimit(2)
            }
        default:
            NavigationLink {
                PostView(post: post)
            } label: {
                Text("Discussion").lineLimit(3).frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

func inferredType(postType: String) -> some View {
    return ZStack {
        switch (postType) {
        case "gallery":
            Text("Gallery")
        case "video":
            Text("Video")
        case "embed":
            Text("Embedded")
        default:
            EmptyView()
        }
    }
}
