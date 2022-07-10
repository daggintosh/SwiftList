//
//  HomeView.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

struct HomeView: View {
    @State var doNotTrack: Bool = false
    @State var posts: [Post] = [
        Post(id: "A", title: "Title of a reddit text post", author: "/u/authorofaredditpost", subreddit: "/r/watchpeopledieinside", contentType: "text", date: Date().addingTimeInterval(-99), content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In elit odio, dignissim at metus rutrum, gravida mattis ex. Ut pellentesque nisl tempus, suscipit purus vel, aliquet felis. Mauris accumsan arcu sed neque elementum posuere. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Mauris dolor felis, aliquam eget tristique ut, blandit nec orci. Nullam vestibulum pulvinar euismod. Curabitur fringilla lobortis augue, a aliquet ex finibus at. Mauris maximus ultrices ex malesuada pulvinar. Fusce cursus finibus erat, sit amet vulputate arcu volutpat ac. Praesent vel dolor eget tortor euismod mattis. Sed pretium et ante cursus varius."),
        Post(id: "B", title: "Title of a hosted video", author: "/u/authorb", subreddit: "/r/aww", contentType: "video", date: Date(), urls: [URL(string: "https://v.redd.it/t3d19ayklja91/HLSPlaylist.m3u8?a=1660012588%2CODMwMzJjM2Q2NjA5MjY5YzAxYmUyZjA3MzNmMzQwMTEwMWY1NGE5N2M3OTgwOTIxZDI5MDQ3ZjcwNmUzZTRjMQ%3D%3D&amp;v=1&amp;f=hd")!]),
        Post(id: "C", title: "Title of a photo", author: "/u/authorc", subreddit: "/r/photos", contentType: "image", date: Date(), urls: [URL(string: "https://i.redd.it/5j400mdqwy991.jpg")!]),
        Post(id: "D", title: "Title of embeded content", author: "/u/authord", subreddit: "/r/all", contentType: "embed", date: Date(), content: "iframe width=\"356\" height=\"200\" src=\"https://www.youtube.com/embed/p1mObQX7NN8?feature=oembed&enablejsapi=1\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen"),
        Post(id: "E", title: "Title of photo gallery", author: "/u/authore", subreddit: "/r/aww", contentType: "gallery", date: Date(), urls: [URL(string: "https://i.redd.it/5j400mdqwy991.jpg")!,URL(string: "https://i.redd.it/5j400mdqwy991.jpg")!,URL(string: "https://i.redd.it/5j400mdqwy991.jpg")!]),
        Post(id: "F", title: "Title of external link", author: "/u/authorf", subreddit: "/r/news", contentType: "link", date: Date(), urls: [URL(string: "https://google.com")!])
    ]
    
    var body: some View {
        List {
            ForEach(posts) { post in
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
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(.vertical, 1)
                    }
                }
            }
        }.navigationTitle("Home").navigationBarTitleDisplayMode(.inline).listStyle(.plain)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
