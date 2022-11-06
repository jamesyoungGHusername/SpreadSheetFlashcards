//
//  SpreadsheetFlashcardsApp.swift
//  SpreadsheetFlashcards
//
//  Created by James Young on 11/6/22.
//

import SwiftUI

@main
struct SpreadsheetFlashcardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
