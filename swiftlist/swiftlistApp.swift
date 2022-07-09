//
//  swiftlistApp.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

@main
struct swiftlistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
