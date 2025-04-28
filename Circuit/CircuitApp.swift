//
//  CircuitApp.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/27/25.
//

import SwiftUI

@main
struct CircuitApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
