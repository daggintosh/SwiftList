//
//  SearchLogic.swift
//  swiftlist
//
//  Created by Dagg on 7/11/22.
//

import Foundation
import CoreData

var apiURL: URL = URL(string: "https://www.reddit.com/")!
var token: String?
var expire: Date?

func getAppchain() -> Appchain {
    let appchainURI = Bundle.main.url(forResource: "Appchain", withExtension: "plist")
    let data = try! Data(contentsOf: appchainURI!)
    let appchain = try! PropertyListDecoder().decode(Appchain.self, from: data)
    
    return appchain
}

func storeToken(token: String) {
    let accessURL = apiURL.appendingPathComponent("api/v1/access_token")
    let appchain = getAppchain()
    let encodedClientID = Data("\(appchain.clientId):\(appchain.secret)".utf8).base64EncodedString()
    var request = URLRequest(url: accessURL)
    request.httpMethod = "POST"
    request.addValue("Basic \(encodedClientID)", forHTTPHeaderField: "Authorization")
    var parameters = URLComponents()
    parameters.queryItems = [
        URLQueryItem(name: "grant_type", value: "authorization_code"),
        URLQueryItem(name: "code", value: token),
        URLQueryItem(name: "redirect_uri", value: "swiftlist://authorize")
    ]
    request.httpBody = parameters.query?.data(using: .utf8)
    let returned = sendRequest(request: request, decodeType: OauthReturn.self) as! OauthReturn
    let context = Persist.shared.container.viewContext
    
    let keychain = Keychain(context: context)
    keychain.token = returned.access_token
    keychain.expiryDate = Date().addingTimeInterval(returned.expires_in.timeIntervalSince1970)
    print(keychain)
    try! context.save()
}

func getKeychain(action: String? = nil) async {
    let fetch = Keychain.fetchRequest()
    
    let context = Persist.shared.container.viewContext
    
    var result: [Keychain] = []
    try! await context.perform {
        result = try fetch.execute()
    }

    if(result.isEmpty) {
        return
    }
    if(action == "delAll") {
        for object in result {
            context.delete(object)
        }
        try! context.save()
        token = nil
        expire = nil
        apiURL = URL(string: "https://www.reddit.com")!
        return
    }
    if(result[0].expiryDate! < Date()) {
        for object in result {
            context.delete(object)
        }
        try! context.save()
        return
    }
    else {
        token = result[0].token
        expire = result[0].expiryDate
        apiURL = URL(string: "https://oauth.reddit.com")!
        return
    }
}

func getExpiry() -> Date? {
    return expire
}

func sendRequest(request: URLRequest, decodeType: Decodable.Type, token: String? = nil) -> Any? {
    var reqResult: Any?
    
    var request = request
    if (token != nil) {
        request.addValue("bearer \(token!)", forHTTPHeaderField: "Authorization")
    }
    request.addValue("ios:com.dagg.swiftlist:0.2a (by /u/blu-487)", forHTTPHeaderField: "User-Agent")
    
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

    let result = sendRequest(request: URLRequest(url: apiURL), decodeType: Posts.self, token: token)
    return result as! Posts?
}

func searchSubreddit(q: String) -> Subreddits? {
//    let keychain = await getKeychain()
//    if(keychain != nil) {
//        apiURL = URL(string: "https://oauth.reddit.com/")!
//    }
    var apiURL = apiURL
    apiURL.appendPathComponent("search")
    apiURL.appendPathExtension("json")
    apiURL.append(queryItems: [
        URLQueryItem(name: "raw_json", value: "1"),
        URLQueryItem(name: "q", value: q.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)),
        URLQueryItem(name: "type", value: "sr")
    ])
    let result = sendRequest(request: URLRequest(url: apiURL), decodeType: Subreddits.self, token: token)
    return result as! Subreddits?
}

func getComments(subreddit: String, id: String) -> Comments? {
    var apiURL = apiURL
    apiURL.appendPathComponent("/r/\(subreddit)/comments/\(id)")
    apiURL.appendPathExtension("json")
    apiURL.append(queryItems: [
        URLQueryItem(name: "raw_json", value: "1")
    ])
    
    let result = sendRequest(request: URLRequest(url: apiURL), decodeType: RootComments.self, token: token)
    return (result as! RootComments).comments[1]
}
