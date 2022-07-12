//
//  CommentView.swift
//  swiftlist
//
//  Created by Dagg on 7/10/22.
//

import SwiftUI

struct CommentView: View {
    @State var doNotRequest: Bool = false
    let subreddit: String
    let postID: String
    @State var comments: Comments?
    
    var body: some View {
        VStack {
            ForEach(comments?.comment?.dropLast() ?? []) { comment in
                VStack {
                    HStack {
                        Text("\(comment.author!)").fontWeight(.bold)
                        switch(comment.op) {
                        case true:
                            Text("OP").fontWeight(.bold).foregroundColor(.accentColor)
                        default:
                            EmptyView()
                        }
                        switch(comment.edited) {
                        case true:
                            Text("(edited)").fontWeight(.thin)
                        default:
                            EmptyView()
                        }
                        Spacer()
                        HStack {
                            Text(comment.date!.formatted(.relative(presentation: .numeric)))
                            Spacer()
                        }
                    }.font(.footnote)
                    HStack {
                        Text(.init(comment.content!)).padding(.vertical, 1)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                        Text("\(comment.ups!)").font(.footnote)
                        Spacer()
                    }
                    ReplyView(replies: comment.replies)
                }
                Divider()
            }.padding(.horizontal)
        }.onAppear {
            if !doNotRequest {
                comments = getComments(subreddit: subreddit, id: postID)
                doNotRequest = true
            }
        }
    }
}

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView().navigationBarTitleDisplayMode(.inline)
//    }
//}
