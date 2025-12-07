//
//  FlagGuessApp.swift
//  FlagGuess
//
//  Created by FaNik on 2025-09-22.
//

import SwiftUI

@main
struct FlagGuessApp: App {
    @StateObject private var gameModel = FlagGameModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameModel)
        }
    }
}
