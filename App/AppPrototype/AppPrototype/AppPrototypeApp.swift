//
//  AppPrototypeApp.swift
//  AppPrototype
//
//  Created by Andrew on 7/30/23.
//

import SwiftUI

@main
struct AppPrototypeApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
