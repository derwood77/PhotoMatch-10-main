//
//  PhotoMatchApp.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//

import SwiftUI

@main
struct PhotoMatchApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        .modelContainer(for: SavedImage.self)   // Set up SwiftData for saving
        .environment(Model()) // Create instance of model for holding converted Images
       
    }
}
