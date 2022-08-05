//
//  HomeView.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

struct HomeView: View {
    @State private var doNotRequest: Bool = false
    @State private var posts: Posts?
    @State var requestedSubreddit: String? = nil
    
    var body: some View {
        List {
            ForEach(posts?.post ?? []) { post in
                VStack {
                    HStack {
                        Text(post.subreddit).fontWeight(.bold)
                        Text(post.author)
                        Text(post.date.formatted(.relative(presentation: .numeric)))
                        Spacer()
                    }.lineLimit(1).font(.footnote)
                    VStack {
                        Text(post.title).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding(.vertical,1)
                        inferredView(post: post)
                        HStack {
                            Image(systemName: "arrow.up").foregroundColor(.accentColor)
                            Text("\(post.ups)").foregroundColor(.accentColor)
                            Spacer()
                        }.padding(.top).fontWeight(.bold)
                    }
                    Divider().frame(height:2).overlay(Color(.systemGray2))
                }.padding(.horizontal).padding(.top).fixedSize(horizontal: false, vertical: true)
            }.listRowSeparator(.hidden).listRowInsets(EdgeInsets())
        }.navigationTitle(requestedSubreddit ?? "Home").navigationBarTitleDisplayMode(.inline).listStyle(.plain).task {
            do {
                    if !doNotRequest {
                        await getKeychain()
                        posts = getPosts(subreddit: requestedSubreddit)
                        doNotRequest = true
                    }
            }
        }.refreshable {
            Task {
                await getKeychain()
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
