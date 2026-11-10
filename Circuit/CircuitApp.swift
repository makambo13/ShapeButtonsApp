//
//  CircuitApp.swift
//  Circuit
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
