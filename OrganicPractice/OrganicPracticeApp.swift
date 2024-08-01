//
//  OrganicPracticeApp.swift
//  OrganicPractice
//
//  Created by Chad Wallace on 7/22/24.
//

import SwiftUI

@main
struct OrganicPracticeApp: App {
    
    @State private var tiles = GameViewModel(gameType: .game1)
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(tiles)
        }
    }
}
