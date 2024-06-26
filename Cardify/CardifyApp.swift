//
//  CardifyApp.swift
//  Cardify
//
//  Created by Jack Hodges on 29/3/2024.
//

import SwiftUI
import SwiftData

@main
struct CardifyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(subjects: Subject.samples)
        }
        .modelContainer(sharedModelContainer)
    }
}
