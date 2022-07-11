//
//  DataStructs.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import Foundation

struct Post: Identifiable {
    let id: String
    let title: String
    let author: String
    let subreddit: String
    let contentType: String
    let date: Date
    let ups: Int = 0
    
    var content: String? = nil
    var urls: [URL]? = nil
    var thumbnail: URL? = URL(string: "https://i.redd.it/5j400mdqwy991.jpg")!
}

struct Reply: Identifiable {
    let id: String
    let author: String
    let date: Date
    let content: String
    let edited: Bool
    let op: Bool
    let ups: Int = 0
    var replies: [Reply]? = []
}

struct Comment: Identifiable {
    let id: String
    let author: String
    let date: Date
    let content: String
    let edited: Bool
    let op: Bool
    let ups: Int = 0
    var replies: [Reply]? = []
}
