//
//  DataStructs.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import Foundation

struct Subreddits: Decodable {
    let subreddit: [Subreddit]
    
    enum RootKeys: CodingKey {
        case data
    }
    
    enum ChildKeys: CodingKey {
        case children
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let data = try container.nestedContainer(keyedBy: ChildKeys.self, forKey: .data)
        self.subreddit = try data.decode([Subreddit].self, forKey: .children)
    }
}

struct Subreddit: Decodable, Identifiable {
    let id: String
    let subreddit: String
    let description: String
    let members: Int64
    let image: URL
    
    enum ItemKeys: CodingKey {
        case data
    }
    
    enum ResultsKeys: CodingKey {
        case display_name, community_icon, public_description, id, subscribers, icon_img
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ItemKeys.self)
        let results = try container.nestedContainer(keyedBy: ResultsKeys.self, forKey: .data)
        self.id = try results.decode(String.self, forKey: .id)
        self.subreddit = try results.decode(String.self, forKey: .display_name)
        self.description = try results.decode(String.self, forKey: .public_description)
        self.members = try results.decodeIfPresent(Int64.self, forKey: .subscribers) ?? 0
        let image: String? = try? results.decodeIfPresent(String.self, forKey: .community_icon) ?? nil
        let imagealt: String? = try? results.decodeIfPresent(String.self, forKey: .icon_img) ?? nil
        self.image = URL(string: image ?? "") ?? URL(string: imagealt ?? "") ?? URL(string: "https://google.com")!
    }
}

struct Posts: Decodable {
    let post: [Post]
    
    enum RootKeys: CodingKey {
        case data
    }
    
    enum ChildKeys: CodingKey {
        case children
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let data = try rootContainer.nestedContainer(keyedBy: ChildKeys.self, forKey: .data)
        self.post = try data.decode([Post].self, forKey: .children)
    }
}

struct Post: Identifiable,Decodable {
    let id: String
    let title: String
    let author: String
    let subreddit: String
    let subredditUnprefixed: String
    var contentType: String
    let date: Date
    var ups: Int = 0
    
    var content: String? = nil
    var urls: [URL]? = nil
    var thumbnail: URL? = nil
    
    enum ItemKeys: CodingKey {
        case data
    }
    enum PostKeys: CodingKey {
        case title, subreddit, id, author, post_hint, created, ups, selftext, thumbnail, url, secure_media, secure_media_embed, media_metadata
    }
    
    enum MediaKeys: CodingKey {
        case reddit_video
    }
    
    enum VideoKeys: CodingKey {
        case hls_url
    }
    
    enum EmbedKeys: CodingKey {
        case content
    }
    
    struct GalleryKeys: CodingKey {
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
        
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    }
    
    init(from decoder: Decoder) throws {
        let items = try decoder.container(keyedBy: ItemKeys.self)
        let post = try items.nestedContainer(keyedBy: PostKeys.self, forKey: .data)
        
        self.id = try post.decode(String.self, forKey: .id)
        self.author = "/u/\(try post.decode(String.self, forKey: .author))"
        self.subredditUnprefixed = try post.decode(String.self, forKey: .subreddit)
        self.subreddit = "/r/\(subredditUnprefixed)"
        self.date = try post.decode(Date.self, forKey: .created)
        self.title = try post.decode(String.self, forKey: .title)
        let postHint = try post.decodeIfPresent(String.self, forKey: .post_hint) ?? ""
        self.ups = try post.decode(Int.self, forKey: .ups)
        var text = try post.decodeIfPresent(String.self, forKey: .selftext)
        text = text?.removingPercentEncoding
        
        let mediaContainer = try? post.nestedContainer(keyedBy: MediaKeys.self, forKey: .secure_media)
        let videoKeys = try? mediaContainer?.nestedContainer(keyedBy: VideoKeys.self, forKey: .reddit_video)
        let videoString = try? videoKeys?.decodeIfPresent(String.self, forKey: .hls_url)?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        let thumburl = try post.decodeIfPresent(String.self, forKey: .thumbnail)
        self.thumbnail = URL(string: thumburl ?? "https://google.com")
        
        let urlString = try post.decodeIfPresent(String.self, forKey: .url)?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        let embedContainer = try? post.nestedContainer(keyedBy: EmbedKeys.self, forKey: .secure_media_embed)
        self.content = try? embedContainer?.decodeIfPresent(String.self, forKey: .content)
        
        struct galleryKeys: Decodable {
            let url: URL
            let hlsPresent: Bool
            
            enum SourceKeys: CodingKey {
                case s,hlsUrl
            }
            
            enum URLKeys: CodingKey {
                case u
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: SourceKeys.self)
                let source = try? container.nestedContainer(keyedBy: URLKeys.self, forKey: .s)
                let urlString = try source?.decodeIfPresent(String.self, forKey: .u)
                let videoString = try container.decodeIfPresent(String.self, forKey: .hlsUrl)
                if videoString != nil {
                    self.hlsPresent = true
                }
                else {
                    self.hlsPresent = false
                }
                self.url = URL(string: urlString ?? videoString!)!
            }
        }
        
        let galleryMeta = try? post.nestedContainer(keyedBy: GalleryKeys.self, forKey: .media_metadata)
        
        self.contentType = postHint
        switch(postHint) {
        case "text":
            self.content = text
        case "image":
            self.urls = [URL(string: urlString)!]
        case "hosted:video":
            self.contentType = "video"
            self.urls = [URL(string: videoString!)!]
        case "rich:video":
            self.contentType = "embed"
        case "link":
            self.urls = [URL(string: urlString)!]
        default:
            self.contentType = "link"
            self.content = text
            self.urls = [URL(string: urlString)!]
        }
        if galleryMeta != nil {
            self.contentType = "gallery"
            self.content = text
            for key in galleryMeta!.allKeys {
                let key = try galleryMeta!.decode(galleryKeys.self, forKey: .init(stringValue: key.stringValue)!)
                if key.hlsPresent {
                    self.contentType = "hybrid:gallery,video"
                }
                urls?.append(key.url)
            }
        }
    }
}

struct Appchain: Decodable {
    let clientId: String
    let secret: String
}

struct OauthReturn: Decodable {
    let access_token: String
    let expires_in: Date
}

struct RootComments: Decodable {
    let comments: [Comments?]
    enum CodingKeys: CodingKey {
        case comments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.comments = try container.decode([Comments?].self)
    }
}

struct Comments: Decodable {
    let comment: [Comment]?
    
    enum RootKeys: CodingKey {
        case data
    }
    
    enum ChildKeys: CodingKey {
        case children
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let data = try container.nestedContainer(keyedBy: ChildKeys.self, forKey: .data)
        self.comment = try! data.decode([Comment].self, forKey: .children)
    }
}

struct Comment: Decodable, Identifiable {
    var id: String?
    var author: String?
    var date: Date?
    var content: String?
//    Not functional(?)
//    var edited: Bool? = false
    var op: Bool?
    var ups: Int?
    var replies: Comments?
    
    enum ItemKeys: CodingKey {
        case data, kind
    }
    
    enum CommentKeys: CodingKey {
        case id, author, created, body, is_submitter, ups, replies,title, subreddit
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ItemKeys.self)
        let comment = try container.nestedContainer(keyedBy: CommentKeys.self, forKey: .data)

        self.id = try comment.decodeIfPresent(String.self, forKey: .id) ?? nil
        self.author = try comment.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.date = try comment.decodeIfPresent(Date.self, forKey: .created) ?? Date()
        self.content = try comment.decodeIfPresent(String.self, forKey: .body) ?? ""
        self.op = try comment.decodeIfPresent(Bool.self, forKey: .is_submitter) ?? false
        self.ups = try comment.decodeIfPresent(Int.self, forKey: .ups) ?? 0
        self.replies = try? comment.decodeIfPresent(Comments.self, forKey: .replies)
    }
}
