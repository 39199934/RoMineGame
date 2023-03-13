//
//  RoMineGameApp.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/13.
//

import SwiftUI

@main
struct RoMineGameApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
