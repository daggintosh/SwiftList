//
//  PostView.swift
//  swiftlist
//
//  Created by Dagg on 7/10/22.
//

import SwiftUI

struct PostView: View {
    @State private var doNotRequest: Bool = false
    @State var post: Post
    @State private var comments: Comments?
    
    var body: some View {
        VStack {
            ScrollView {
                switch(post.contentType) {
                case "video":
                    AVView(videoURL: post.urls![0]).aspectRatio(16/9, contentMode: .fit)
                case "embed":
                    WKVView(body: post.content ?? "").aspectRatio(16/9, contentMode: .fit)
                case "gallery","image":
                    ForEach(post.urls!.reversed(), id: \.self) { img in
                        AsyncImage(url: img) { Image in
                            Image.resizable()
                        } placeholder: {
                            
                        }.aspectRatio(contentMode: .fit).padding(.bottom, 1)
                    }
                case "hybrid:gallery,video":
                    AVView(videoURL: post.urls![0])
                    ForEach(post.urls!.reversed(), id: \.self) { img in
                        AsyncImage(url: img) { Image in
                            Image.resizable()
                        } placeholder: {
                            
                        }.aspectRatio(contentMode: .fit).padding(.bottom, 1)
                    }
                default:
                    EmptyView()
                }
                NavigationLink {
                    HomeView(requestedSubreddit: post.subredditUnprefixed)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(post.title).fontWeight(.heavy).multilineTextAlignment(.leading).lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                            HStack {
                                Text(post.subreddit).font(.footnote).fontWeight(.bold).foregroundColor(.accentColor)
                                Text(post.author).font(.footnote)
                            }
                            HStack {
                                Text(post.date.formatted(date: .abbreviated, time: .omitted))
                                Image(systemName: "arrow.up").fontWeight(.bold).foregroundColor(.accentColor)
                                Text("\(post.ups)").fontWeight(.bold).foregroundColor(.accentColor)
                            }.font(.footnote)
                        }.lineLimit(1)
                        Spacer()
                    }.padding(.horizontal)
                }.foregroundColor(.primary)
                Divider().frame(height:2).overlay(Color(.systemGray2))
                switch(post.contentType) {
                case "link":
                    Link("\(post.urls![0])", destination: post.urls![0]).foregroundColor(.accentColor).padding(.horizontal)
                    Divider().frame(height:2).overlay(Color(.systemGray2))
                default:
                    EmptyView()
                }
                switch post.contentType {
                case "embed":
                    EmptyView()
                default:
                    HStack {
                        Text(.init(post.content ?? "")).padding(.horizontal).multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                if(post.content != nil && post.content != "" && post.contentType != "embed") {Divider().frame(height:2).overlay(Color(.systemGray2)).padding(.horizontal)}
                CommentView(subreddit: post.subredditUnprefixed, postID: post.id)
            }
        }
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            PostView().navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
