//
//  SearchView.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

struct SearchView: View {
    @State private var search: String = ""
    @FocusState private var focused: Bool
    @State private var subreddits: Subreddits?
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle().foregroundColor(Color(.systemBackground)).onTapGesture {
                    focused = false
                }
                List {
                    ForEach(subreddits?.subreddit ?? []) { sub in
                        NavigationLink {
                            HomeView(requestedSubreddit: sub.subreddit)
                        } label: {
                            HStack {
                                AsyncImage(url: sub.image) { Image in
                                    Image.resizable()
                                } placeholder: {
                                    
                                }.aspectRatio(contentMode: .fit).mask {
                                    Circle()
                                }.frame(width: 24).aspectRatio(contentMode: .fit)
                                VStack(alignment: .leading) {
                                    Text("/r/\(sub.subreddit)").fontWeight(.bold).font(.callout).lineLimit(1)
                                    Text("\(sub.members.abbreviate) members").font(.caption).fontWeight(.thin)
                                }
                                //Text(sub.description).font(.footnote).lineLimit(3)
                            }
                        }

                    }
                }.listStyle(.plain).scrollDismissesKeyboard(.immediately)
            }
            Spacer()
            ZStack {
                Rectangle().foregroundColor(Color(.systemGray5)).cornerRadius(10).layoutPriority(-1)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for a subreddit", text: $search).focused($focused).onSubmit {
                        if(search.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                            focused = false
                            subreddits = searchSubreddit(q: search)
                        }
                    }.submitLabel(.search)
                }.padding(10)
            }.padding(8).navigationTitle("Subreddit Search")
        }.onAppear {
            focused = true
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView()
        }
    }
}
