//
//  InferredPost.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

func inferredView(post: Post) -> some View {
    return ZStack {
        VStack {
            NavigationLink {
                PostView(post: post)
            } label: {
                VStack {
                    switch(post.content) {
                    case .some:
                        Text(.init(post.content!))
                    case .none:
                        EmptyView()
                    }
                    switch post.urls?[0].blacklist {
                    case false:
                        Text("\(post.urls![0])").foregroundColor(.accentColor)
                    default:
                        EmptyView()
                    }
                }
            }.lineLimit(3).frame(maxWidth: .infinity, alignment: .leading)
            switch(post.thumbnail) {
            case .some:
                ZStack {
                    Rectangle().aspectRatio(16/9,contentMode: .fit).foregroundColor(.clear)
                    AsyncImage(url: post.thumbnail) { Image in
                        Image.resizable()
                    } placeholder: {
                        ProgressView().tint(.gray)
                    }.aspectRatio(contentMode: .fit).layoutPriority(-1)
                }
            case .none:
                EmptyView()
            }
        }
    }
}
