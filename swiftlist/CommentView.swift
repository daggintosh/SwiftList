//
//  CommentView.swift
//  swiftlist
//
//  Created by Dagg on 7/10/22.
//

import SwiftUI

struct CommentView: View {
    @State var doNotRequest: Bool = false
    let postID: String
    @State var comments: [Comment] = [
        Comment(id: "0", author: "/u/commentauthor", date: Date().addingTimeInterval(-99999), content: "Long comment discussing the post Long comment discussing the post Long comment discussing the post Long comment discussing the post Long comment discussing the post Long comment discussing the post Long comment discussing the post Long comment discussing the post Long comment discussing the post Long comment discussing the post Long comment discussing the post", edited: true, op: true, replies: [
            Reply(id: "1", author: "/u/author2", date: Date().addingTimeInterval(-1), content: "long text :)", edited: true, op: true, replies: [
                Reply(id: "6", author: "/u/author3", date: Date().addingTimeInterval(-1), content: "long text :)", edited: true, op: true, replies: [
                    Reply(id: "7", author: "/u/author4", date: Date().addingTimeInterval(-1), content: "long text :)", edited: true, op: true, replies: [
                        Reply(id: "8", author: "/u/author6", date: Date().addingTimeInterval(-1), content: "long text :)", edited: true, op: true)
                    ])
                ])
            ]),
            Reply(id: "2", author: "/u/author", date: Date().addingTimeInterval(-1), content: "long text :)", edited: true, op: true),
            Reply(id: "3", author: "/u/author", date: Date().addingTimeInterval(-1), content: "long text :)", edited: true, op: true),
            Reply(id: "4", author: "/u/author", date: Date().addingTimeInterval(-1), content: "long text :)", edited: true, op: true),
            Reply(id: "5", author: "/u/keynote", date: Date().addingTimeInterval(-1), content: "long text :)", edited: true, op: true)
        ]),
        Comment(id: "9", author: "/u/author3", date: Date(), content: "Short", edited: false, op: false)
    ]
    
    var body: some View {
        ForEach(comments) { comment in
            VStack {
                HStack {
                    Text(comment.author).fontWeight(.bold)
                    if (comment.op) {
                        Text("OP").fontWeight(.bold).foregroundColor(.accentColor)
                    }
                    if (comment.edited) {
                        Text("(edited)").fontWeight(.thin)
                    }
                    Spacer()
                    HStack {
                        Text(comment.date.formatted(.relative(presentation: .numeric)))
                        Spacer()
                    }
                }.font(.footnote)
                HStack {
                    Text(comment.content).padding(.vertical, 1)
                    Spacer()
                }
                HStack {
                    Image(systemName: "arrow.up.circle.fill")
                    Text("\(comment.ups)").font(.footnote)
                    Spacer()
                }
                ReplyView(replies: comment.replies)
            }
        }.padding(.horizontal)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post(id: "debug", title: "Title of a hosted video", author: "/u/authorb", subreddit: "/r/aww", contentType: "video", date: Date(), urls: [URL(string: "https://v.redd.it/t3d19ayklja91/HLSPlaylist.m3u8?a=1660012588%2CODMwMzJjM2Q2NjA5MjY5YzAxYmUyZjA3MzNmMzQwMTEwMWY1NGE5N2M3OTgwOTIxZDI5MDQ3ZjcwNmUzZTRjMQ%3D%3D&amp;v=1&amp;f=hd")!])).navigationBarTitleDisplayMode(.inline)
    }
}
