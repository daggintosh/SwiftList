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
        LazyVStack {
            ForEach(comments?.comment?.dropLast() ?? []) { comment in
                VStack {
                    HStack {
                        Text("/u/\(comment.author!)").fontWeight(.bold).lineLimit(1)
                        switch(comment.op) {
                        case true:
                            Text("OP").fontWeight(.bold).foregroundColor(.accentColor)
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
                        Text(.init(comment.content!)).fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                        Text("\(comment.ups!)").font(.footnote)
                        Spacer()
                    }.padding(.top, 1)
                    ReplyView(replies: comment.replies).padding(.top,3)
                }
                Divider()
            }.padding(.horizontal)
        }.onAppear {
            switch (doNotRequest) {
            case false:
                comments = getComments(subreddit: subreddit, id: postID)
                doNotRequest = true
            default:
                break
            }
        }
    }
}

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView().navigationBarTitleDisplayMode(.inline)
//    }
//}
