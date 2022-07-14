//
//  Persist.swift
//  swiftlist
//
//  Created by Dagg on 7/13/22.
//

import Foundation
import CoreData

struct Persist {
    static let shared = Persist()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Keychain")
        
        container.loadPersistentStores {resp, err in
            if let err = err {
                fatalError(err.localizedDescription)
            }
        }
    }
}


