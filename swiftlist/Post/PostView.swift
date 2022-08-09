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
    
    @State private var galleryScale: CGFloat = 1.0
    @State private var galleryTransform: CGSize = CGSize()
    @State private var galleryLast: CGSize = CGSize()
    var body: some View {
        VStack {
            ScrollView {
                switch post.embed {
                case .some:
                    WKVView(body: post.embed).aspectRatio(16/9, contentMode: .fit)
                case .none:
                    EmptyView()
                }
                switch post.urls {
                case .some:
                    if (post.urls?[0].video == true) {
                        AVView(videoURL: post.urls![0]).aspectRatio(16/9, contentMode: .fit)
                    }
                    ForEach(post.urls!.reversed(), id: \.self) { element in
                        NavigationLink {
                            ZStack {
                                Color.clear
                                AsyncImage(url: element) { Image in
                                    Image.resizable()
                                } placeholder: {
                                    
                                }.offset(galleryTransform).aspectRatio(contentMode: .fit).gesture(DragGesture().onChanged({ value in
                                    let newVal = CGSize(width:  value.translation.width + galleryLast.width, height: value.translation.height + galleryLast.height)
                                    galleryTransform = newVal
                                }).onEnded({ _ in
                                    galleryLast = galleryTransform
                                })).gesture(MagnificationGesture().onChanged({ value in
                                    galleryScale = value * galleryScale
                                }).onEnded({ _ in
                                    if(galleryScale < 1) {
                                        galleryScale = 1
                                    }
                                })).scaleEffect(galleryScale)
                            }.clipped().onAppear {
                                galleryScale = 1.0
                                galleryTransform = CGSize()
                                galleryLast = CGSize()
                            }
                        } label: {
                            AsyncImage(url: element) { Image in
                                Image.resizable()
                            } placeholder: {
                                
                            }.aspectRatio(contentMode: .fit).padding(.bottom, 1)
                        }

                    }
                case .none:
                    EmptyView()
                }
                HStack {
                    Text(post.title).fontWeight(.heavy).multilineTextAlignment(.leading).lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }.padding(.horizontal)
                switch(post.content) {
                case .some:
                    HStack {
                        Text(.init(post.content ?? "")).padding(.horizontal).multilineTextAlignment(.leading).padding(.top,2)
                        Spacer()
                    }
                    //                    Divider().frame(height:2).overlay(Color(.systemGray2)).padding(.horizontal)
                case .none:
                    EmptyView()
                    //                    Divider().frame(height:2).overlay(Color(.systemGray2)).padding(.horizontal)
                }
                switch post.urls?[0].blacklist {
                case false:
                    Link("\(post.urls![0])", destination: post.urls![0]).foregroundColor(.accentColor).padding(.horizontal)
                    Divider().frame(height:2).overlay(Color(.systemGray2)).padding(.horizontal)
                case true:
                    EmptyView()
                default:
                    EmptyView()
                    Divider().frame(height:2).overlay(Color(.systemGray2)).padding(.horizontal)
                }
                HStack {
                    NavigationLink {
                        HomeView(requestedSubreddit: post.subredditUnprefixed)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(post.subreddit).font(.footnote).fontWeight(.bold).foregroundColor(.accentColor)
                                Text(post.author).font(.footnote)
                            }
                            HStack {
                                Text(post.date.formatted(date: .abbreviated, time: .omitted))
                                Image(systemName: "arrow.up").fontWeight(.bold).foregroundColor(.accentColor)
                                Text("\(post.ups)").fontWeight(.bold).foregroundColor(.accentColor)
                            }.font(.footnote)
                        }.foregroundColor(.primary)
                    }.padding(.top,2)
                    Image(systemName: "chevron.right").foregroundColor(.accentColor)
                    Spacer()
                }.padding(.horizontal)
                Divider().frame(height:2).overlay(Color(.systemGray2)).padding(.horizontal)
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
