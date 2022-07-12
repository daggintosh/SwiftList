//
//  PostView.swift
//  swiftlist
//
//  Created by Dagg on 7/10/22.
//

import SwiftUI

struct PostView: View {
    @State var doNotRequest: Bool = false
    @State var post: Post
    @State var comments: Comments?
    
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
                default:
                    EmptyView()
                }
                NavigationLink {
                    HomeView(requestedSubreddit: post.subredditUnprefixed)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(post.title).fontWeight(.heavy).lineLimit(2).multilineTextAlignment(.leading)
                            HStack() {
                                Text(post.subreddit).font(.footnote).fontWeight(.bold).foregroundColor(.accentColor)
                                Text(post.author).font(.footnote)
                            }
                            Text(post.date.formatted(date: .abbreviated, time: .omitted)).font(.footnote)
                        }.lineLimit(1)
                        Spacer()
                        Image(systemName: "arrow.up.circle.fill").font(.footnote)
                        Text("\(post.ups)").font(.footnote)
                    }.padding(.horizontal)
                }.foregroundColor(.primary)
                Divider().frame(height:2).overlay(Color(.systemGray2))
                switch(post.contentType) {
                case "text","gallery":
                    HStack {
                        Text(.init(post.content ?? "")).padding(.horizontal).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    if(post.content != "") {Divider().frame(height:2).overlay(Color(.systemGray2)).padding(.horizontal)}
                case "link":
                    Link("\(post.urls![0])", destination: post.urls![0]).foregroundColor(.accentColor).padding(.horizontal)
                    Divider().frame(height:2).overlay(Color(.systemGray2))
                default:
                    EmptyView()
                }
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
