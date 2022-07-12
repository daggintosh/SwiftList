//
//  HomeView.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

struct HomeView: View {
    @State var doNotRequest: Bool = false
    @State var posts: Posts?
    @State var requestedSubreddit: String? = nil
    
    var body: some View {
        List {
            ForEach(posts?.post ?? []) { post in
                VStack {
                    HStack {
                        Text(post.subreddit).fontWeight(.bold)
                        Text(post.author)
                        Text(post.date.formatted(.relative(presentation: .numeric)))
                    }.lineLimit(1).frame(maxWidth: .infinity, alignment: .leading).font(.footnote).padding(.vertical, 1)
                    VStack {
                        Text(post.title).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding(.vertical,1 )
                        inferredView(post: post)
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("\(post.ups)")
                            Spacer()
                            inferredType(postType: post.contentType)
                        }.padding(.top)
                    }
                }
            }
        }.navigationTitle(requestedSubreddit ?? "Home").navigationBarTitleDisplayMode(.inline).listStyle(.plain).onAppear {
            if !doNotRequest {
                posts = getPosts(subreddit: requestedSubreddit)
                doNotRequest = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
