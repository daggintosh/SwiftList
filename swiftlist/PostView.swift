//
//  PostView.swift
//  swiftlist
//
//  Created by Dagg on 7/10/22.
//

import SwiftUI

struct PostView: View {
    @State var post: Post
    
    var body: some View {
        VStack {
            ScrollView {
                switch(post.contentType) {
                case "video":
                    AVView(videoURL: post.urls![0]).aspectRatio(16/9, contentMode: .fit)
                case "embed":
                    WKVView(body: post.content ?? "").aspectRatio(16/9, contentMode: .fit)
                case "gallery","image":
                    ForEach(post.urls!, id: \.self) { img in
                        AsyncImage(url: img) { Image in
                            Image.resizable()
                        } placeholder: {
                            ProgressView().tint(.gray)
                        }.aspectRatio(contentMode: .fit)
                    }
                default:
                    EmptyView()
                }
                NavigationLink {
                    EmptyView()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(post.title).fontWeight(.heavy)
                            HStack() {
                                Text(post.subreddit).font(.footnote).fontWeight(.bold)
                                Text(post.author).font(.footnote)
                            }
                            Text(post.date.formatted(date: .abbreviated, time: .omitted)).font(.footnote)
                        }.lineLimit(1)
                        Spacer()
                        Image(systemName: "arrow.up.circle.fill")
                        Text("\(post.ups)")
                    }.padding(.horizontal)
                }.foregroundColor(.primary)
                Divider().padding(.horizontal)
                if (post.contentType ==  "text") {
                    Text(post.content ?? "").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                    Divider().padding(.horizontal)
                }
                if (post.contentType == "link") {
                    Link("\(post.urls![0])", destination: post.urls![0]).foregroundColor(.accentColor).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    Divider().padding(.horizontal)
                }
                CommentView(postID: post.id).padding(.vertical, 1)
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostView(post: Post(id: "B", title: "Title of a hosted video", author: "/u/authorb", subreddit: "/r/aww", contentType: "video", date: Date(), urls: [URL(string: "https://v.redd.it/t3d19ayklja91/HLSPlaylist.m3u8?a=1660012588%2CODMwMzJjM2Q2NjA5MjY5YzAxYmUyZjA3MzNmMzQwMTEwMWY1NGE5N2M3OTgwOTIxZDI5MDQ3ZjcwNmUzZTRjMQ%3D%3D&amp;v=1&amp;f=hd")!])).navigationBarTitleDisplayMode(.inline)
        }
    }
}
