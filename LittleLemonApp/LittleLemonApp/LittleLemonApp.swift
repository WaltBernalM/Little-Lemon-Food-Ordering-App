//
//  LittleLemonAppApp.swift
//  LittleLemonApp
//
//  Created by Walter Bernal on 27.08.2024.
//

import SwiftUI

@main
struct LittleLemonApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Onboarding().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
