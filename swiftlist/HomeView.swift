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
    
    @State private var subredditInfo: SubredditDisplay?
    
    var body: some View {
        List {
            switch subredditInfo {
            case .some:
                ZStack {
                    Rectangle().aspectRatio(4,contentMode: .fit).foregroundColor(.blue)
                    switch subredditInfo?.header {
                    case .some:
                        AsyncImage(url: subredditInfo?.header) { Image in
                            Image.resizable()
                        } placeholder: {
                            ProgressView().tint(.gray)
                        }.aspectRatio(contentMode: .fill).layoutPriority(-1)
                    case .none:
                        EmptyView()
                    }
                    HStack {
                        AsyncImage(url: subredditInfo?.icon) { Image in
                            Image.resizable()
                        } placeholder: {
                            ZStack {
                                Circle().stroke(.white, lineWidth: 5).foregroundColor(.blue)
                                Text("r/").foregroundColor(.white).fontWeight(.heavy).font(.title3)
                            }
                        }.aspectRatio(contentMode: .fit).mask {
                            Circle()
                        }.shadow(color: Color(.black), radius: 2)
                        Text(subredditInfo?.headline ?? "Null").fontWeight(.heavy).foregroundColor(.white).shadow(color: Color(.black), radius: 2)
                        Spacer()
                    }.padding().layoutPriority(-1)
                }.listRowInsets(EdgeInsets()).listRowSeparator(.hidden)
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(subredditInfo?.activeAccounts ?? 0) active users")
                        Text("\(subredditInfo?.members ?? 0) subscribers")
                    }
                    Text(subredditInfo?.publicDescription ?? "").font(.body)
                    Text("Created on \(subredditInfo?.creationDate.formatted(date: .abbreviated, time: .omitted) ?? "")")
                    Divider().frame(height:2).overlay(Color(.systemGray2))
                }.font(.footnote).fontWeight(.bold)
            case .none:
                EmptyView()
            }
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
        }.navigationTitle(subredditInfo?.displayNamePrefixed ?? "Home").navigationBarTitleDisplayMode(.inline).listStyle(.plain).task {
            do {
                    if !doNotRequest {
                        await getKeychain()
                        posts = getPosts(subreddit: requestedSubreddit)
                        if (requestedSubreddit != nil && requestedSubreddit != "all") {
                            subredditInfo = getSubredditData(subreddit: requestedSubreddit)
                        }
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
