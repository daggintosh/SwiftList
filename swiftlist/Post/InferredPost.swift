//
//  InferredPost.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

func inferredView(post: Post) -> some View {
    return ZStack {
        NavigationLink {
            PostView(post: post)
        } label: {
        }
        VStack {
            switch(post.content) {
            case .some:
                Text(.init(post.content!)).lineLimit(3).frame(maxWidth: .infinity, alignment: .leading)
            case .none:
                EmptyView()
            }
            switch post.urls?[0].blacklist {
            case false:
                Text("\(post.urls![0])").foregroundColor(.accentColor).lineLimit(3).frame(maxWidth: .infinity, alignment: .leading)
            default:
                EmptyView()
            }
            switch post.nsfw {
            case true:
                ZStack {
                    Rectangle().aspectRatio(16/9,contentMode: .fit).foregroundColor(.black)
                    VStack {
                        Text("NSFW").font(.title).fontWeight(.heavy)
                        HStack {
                            Image(systemName: "18.square.fill").resizable().aspectRatio(contentMode: .fit)
                            Image(systemName: "plus").resizable().aspectRatio(contentMode: .fit).frame(maxHeight: 50)
                        }
                    }.padding().layoutPriority(-1)
                }.foregroundColor(.red)
            default:
                EmptyView()
            }
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
