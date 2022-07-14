//
//  swiftlistApp.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI
import AVKit

@main
struct swiftlistApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView().task {
                do {
                    try? AVAudioSession.sharedInstance().setCategory(.playback)
                }
            }.environment(\.managedObjectContext, Persist.shared.container.viewContext)
        }
    }
}
