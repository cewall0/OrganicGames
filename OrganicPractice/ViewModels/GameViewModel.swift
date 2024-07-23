//
//  AppState.swift
//  Sluff Scorecard
//
//  Created by Chad Wallace on 1/31/24.
//

import SwiftUI
import Observation

@Observable
final class GameViewModel {
    var tiles: [Tile] = []
    var selectedTiles: [Tile] = []
    var tilePositions: [UUID: CGPoint] = [:]
    var tileRotations: [UUID: Double] = [:]
    var gameCompleted: Bool = false // Track if the game is completed

    init() {
        resetGame()
    }
    
    func resetGame() {
        let tileNames = (1...18).flatMap { ["\($0 < 10 ? "0" : "")\($0)A", "\($0 < 10 ? "0" : "")\($0)B"] }
        tiles = tileNames.map { Tile(name: $0) }.shuffled()
        selectedTiles = []
        tilePositions = [:]
        tileRotations = [:]
        gameCompleted = false // Reset the game completed state
        generateRandomPositionsAndRotations()
    }
    
    func generateRandomPositionsAndRotations() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let tileSize: CGFloat = 140
        let padding: CGFloat = 20
        let safeAreaInsets = getSafeAreaInsets()
        let safePadding = padding + tileSize / 2 // Ensure the entire tile fits within the safe area
        let zonesPerRow = 7 // Adjust zones per row for better spacing
        let zonesPerColumn = 10 // Adjust zones per column for better spacing
        let zoneWidth = (screenWidth - safePadding * 2) / CGFloat(zonesPerRow)
        let zoneHeight = (screenHeight - safePadding * 2 - safeAreaInsets.top - safeAreaInsets.bottom) / CGFloat(zonesPerColumn)
        
        var usedZones = Set<Int>()
        
        for tile in tiles {
            var zoneIndex: Int
            repeat {
                zoneIndex = Int.random(in: 0..<(zonesPerRow * zonesPerColumn))
            } while usedZones.contains(zoneIndex)
            
            usedZones.insert(zoneIndex)
            
            let zoneRow = zoneIndex / zonesPerRow
            let zoneColumn = zoneIndex % zonesPerRow
            
            let xMin = safePadding + CGFloat(zoneColumn) * zoneWidth
            let xMax = safePadding + CGFloat(zoneColumn + 1) * zoneWidth - tileSize
            let yMin = safePadding + safeAreaInsets.top + CGFloat(zoneRow) * zoneHeight
            let yMax = safePadding + safeAreaInsets.top + CGFloat(zoneRow + 1) * zoneHeight - tileSize
            
            let xPosition = xMin < xMax ? CGFloat.random(in: xMin...xMax) : xMin
            let yPosition = yMin < yMax ? CGFloat.random(in: yMin...yMax) : yMin
            
            tilePositions[tile.id] = CGPoint(x: xPosition, y: yPosition)
            tileRotations[tile.id] = Double.random(in: -40...40)
        }
    }
    
    func selectTile(_ tile: Tile) {
        if selectedTiles.count < 2 {
            selectedTiles.append(tile)
            if selectedTiles.count == 2 {
                checkMatch()
            }
        }
    }
    
    func checkMatch() {
        if selectedTiles.count == 2 {
            if selectedTiles[0].number == selectedTiles[1].number && selectedTiles[0].letter != selectedTiles[1].letter {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.tiles.removeAll { $0.id == self.selectedTiles[0].id || $0.id == self.selectedTiles[1].id }
                    self.selectedTiles.removeAll()
                    self.checkGameCompletion()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.selectedTiles.removeAll()
                }
            }
        }
    }
    
    func checkGameCompletion() {
        if tiles.isEmpty {
            gameCompleted = true
        }
    }
    
    private func getSafeAreaInsets() -> UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return windowScene.windows.first?.safeAreaInsets ?? .zero
    }
}
