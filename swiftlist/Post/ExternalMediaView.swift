//
//  AVView.swift
//  swiftlist
//
//  Created by Dagg on 7/10/22.
//

import SwiftUI
import AVKit
import WebKit

extension URL {
    var video: Bool {
        if self.host == "v.redd.it" {
            return true
        }
        else {
            return false
        }
    }
    var blacklist: Bool {
        // Host link blacklists
        switch self.host {
        case "v.redd.it","i.redd.it","www.reddit.com","preview.redd.it":
            return true
        default:
            return false
        }
    }
}

struct AVView: UIViewControllerRepresentable {
    let videoURL: URL
    typealias UIViewControllerType = AVPlayerViewController

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.allowsPictureInPicturePlayback = true
        controller.exitsFullScreenWhenPlaybackEnds = true
        let player = AVPlayer(url: videoURL)
        controller.player = player
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}

struct WKVView: UIViewRepresentable {
    let body: String?
    typealias UIViewType = WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        if body != nil {
            let configuration = WKWebViewConfiguration()
            configuration.allowsInlineMediaPlayback = true
            configuration.allowsPictureInPictureMediaPlayback = true
            configuration.applicationNameForUserAgent = Bundle.main.bundleIdentifier
            let WebView = WKWebView(frame: .zero, configuration: configuration)
            let decodedBody = body!.removingPercentEncoding?.replacingOccurrences(of: ".*( src=\\S+).*", with: "$1", options: .regularExpression)
            let fixedTarget = decodedBody?.replacingOccurrences(of: " src=", with: "").replacingOccurrences(of: "\"", with: "")

            var request = URLRequest(url: URL(string: fixedTarget ?? "")!)
            request.addValue("https://www.youtube.com/", forHTTPHeaderField: "Referer")
            WebView.load(request)
            
            return WebView
        }
        else {
            return WKWebView()
        }
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
