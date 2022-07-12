//
//  SearchLogic.swift
//  swiftlist
//
//  Created by Dagg on 7/11/22.
//

import Foundation

let apiURL: URL = URL(string: "https://www.reddit.com/")!

func sendRequest(request: URLRequest, decodeType: Decodable.Type, token: String? = nil) -> Any? {
    var reqResult: Any?
    
    var request = request
    if (token != nil) {
        request.addValue("bearer \(token!)", forHTTPHeaderField: "Authorization")
    }
    request.addValue("ios:com.dagg.swiftlist:0.1c (by /u/blu-487)", forHTTPHeaderField: "User-Agent")
    
    let sem = DispatchSemaphore(value: 0)
    URLSession.shared.dataTask(with: request) { data, response, error in
        defer { sem.signal() }
        guard let data = data else { return }
#if DEBUG
        if let response = response { print(response) }
        let plain = try? JSONSerialization.jsonObject(with: data)
        print(plain ?? "")
#endif
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        reqResult = try! decoder.decode(decodeType, from: data)
    }.resume()
    sem.wait()
    
    return reqResult
}

func getPosts(subreddit: String? = nil) -> Posts? {
    let apiURLString: String = apiURL.absoluteString
    var apiURL: URL
    apiURL = URL(string: apiURLString)!
    if subreddit != nil {apiURL.appendPathComponent("r/\(subreddit!)")}
    apiURL.appendPathExtension("json")
    apiURL.append(queryItems: [URLQueryItem(name: "raw_json", value: "1")])

    let result = sendRequest(request: URLRequest(url: apiURL), decodeType: Posts.self)
    return result as! Posts?
}

func searchSubreddit(q: String) -> Subreddits? {
    var apiURL = apiURL
    apiURL.appendPathComponent("search")
    apiURL.appendPathExtension("json")
    apiURL.append(queryItems: [
        URLQueryItem(name: "raw_json", value: "1"),
        URLQueryItem(name: "q", value: q.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)),
        URLQueryItem(name: "type", value: "sr")
    ])
    let result = sendRequest(request: URLRequest(url: apiURL), decodeType: Subreddits.self)
    return result as! Subreddits?
}

func getComments(subreddit: String, id: String) -> Comments? {
    var apiURL = apiURL
    apiURL.appendPathComponent("/r/\(subreddit)/comments/\(id)")
    apiURL.appendPathExtension("json")
    apiURL.append(queryItems: [
        URLQueryItem(name: "raw_json", value: "1")
    ])
    
    let result = sendRequest(request: URLRequest(url: apiURL), decodeType: RootComments.self)
    return (result as! RootComments).comments[1]
}
