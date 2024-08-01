//
//  AppState.swift
//  Sluff Scorecard
//
//  Created by Chad Wallace on 1/31/24.
//

import Foundation
import SwiftUI
import Combine

@Observable
final class GameViewModel {
    var tiles: [Tile] = []
    var selectedTiles: [Tile] = []
    var tilePositions: [UUID: CGPoint] = [:]
    var tileRotations: [UUID: Double] = [:]
    var gameType: GameType
    var gameCompleted: Bool = false

    init(gameType: GameType) {
        self.gameType = gameType
        resetGame(for: gameType)
    }

    func resetGame(for gameType: GameType) {
        switch gameType {
        case .game1:
            let tileNames = (1...18).map { ["G1_Tile\($0)A", "G1_Tile\($0)B"] }
            let shuffledPairs = tileNames.shuffled()
            let tileStrings = shuffledPairs.flatMap { $0 }
            tiles = tileStrings.map { Tile(name: $0) }
            
        case .game2:
            let tileNames = (19...34).map { ["G2_Tile\($0)A", "G2_Tile\($0)B"] }
            let shuffledPairs = tileNames.shuffled()
            let tileStrings = shuffledPairs.flatMap { $0 }
            tiles = tileStrings.map { Tile(name: $0) }
           
        case .game3:
            let tileNames = (1...20).map { "G3_Atom\($0)" } + ["G3_Charge_minus", "G3_Charge0", "G3_Charge_plus"]
            tiles = tileNames.map { Tile(name: $0) }.shuffled()
        }
        selectedTiles = []
        tilePositions = [:]
        tileRotations = [:]
        generateRandomPositionsAndRotations()
    }

    func generateRandomPositionsAndRotations() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let tileSize: CGFloat = 140
        let padding: CGFloat = 20
        let safeAreaInsets = getSafeAreaInsets()
        let safePadding = padding + tileSize / 2 // Ensure the entire tile fits within the safe area
        let zonesPerRow = 7
        let zonesPerColumn = 10
        let zoneWidth = (screenWidth - safePadding * 2) / CGFloat(zonesPerRow)
        let zoneHeight = (screenHeight - safePadding * 2 - safeAreaInsets.top - safeAreaInsets.bottom) / CGFloat(zonesPerColumn)

        var availableZones = Set(0..<(zonesPerRow * zonesPerColumn))
        var pairs: [(Tile, Tile)] = []

        // Create pairs of tiles
        for pairIndex in stride(from: 0, to: tiles.count, by: 2) {
            guard pairIndex + 1 < tiles.count else { break }
            let tile1 = tiles[pairIndex]
            let tile2 = tiles[pairIndex + 1]
            pairs.append((tile1, tile2))
        }

        // Shuffle pairs to randomize placement
        pairs.shuffle()

        // Assign zones to each pair and place tiles
        for (tile1, tile2) in pairs {
            guard availableZones.count >= 2 else { break }

            var zoneIndices: [Int] = []
            repeat {
                zoneIndices = Array(availableZones.shuffled().prefix(2))
            } while !areZonesFarEnoughApart(zoneIndices[0], zoneIndices[1], zonesPerRow: zonesPerRow, minDistance: 2)

            let zone1 = zoneIndices[0]
            let zone2 = zoneIndices[1]
            availableZones.remove(zone1)
            availableZones.remove(zone2)

            let (position1, rotation1) = generatePositionAndRotation(for: zone1, tileSize: tileSize, zoneWidth: zoneWidth, zoneHeight: zoneHeight, safePadding: safePadding, safeAreaInsets: safeAreaInsets)
            let (position2, rotation2) = generatePositionAndRotation(for: zone2, tileSize: tileSize, zoneWidth: zoneWidth, zoneHeight: zoneHeight, safePadding: safePadding, safeAreaInsets: safeAreaInsets)

            tilePositions[tile1.id] = position1
            tilePositions[tile2.id] = position2
            tileRotations[tile1.id] = rotation1
            tileRotations[tile2.id] = rotation2
        }
    }

    private func generatePositionAndRotation(for zoneIndex: Int, tileSize: CGFloat, zoneWidth: CGFloat, zoneHeight: CGFloat, safePadding: CGFloat, safeAreaInsets: UIEdgeInsets) -> (CGPoint, Double) {
        let zonesPerRow = 7
        let row = zoneIndex / zonesPerRow
        let col = zoneIndex % zonesPerRow

        let xPosition = safePadding + CGFloat(col) * zoneWidth + zoneWidth / 2
        let yPosition = safePadding + safeAreaInsets.top + CGFloat(row) * zoneHeight + zoneHeight / 2

        let position = CGPoint(x: xPosition, y: yPosition)
        let rotation = Double.random(in: -40...40)

        return (position, rotation)
    }

    private func areZonesFarEnoughApart(_ zone1: Int, _ zone2: Int, zonesPerRow: Int, minDistance: Int) -> Bool {
        let row1 = zone1 / zonesPerRow
        let col1 = zone1 % zonesPerRow
        let row2 = zone2 / zonesPerRow
        let col2 = zone2 % zonesPerRow

        let rowDistance = abs(row1 - row2)
        let colDistance = abs(col1 - col2)

        return rowDistance >= minDistance || colDistance >= minDistance
    }

    private func getSafeAreaInsets() -> UIEdgeInsets {
           guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
               return .zero
           }
           return windowScene.windows.first?.safeAreaInsets ?? .zero
       }

    func scrambleRemainingTiles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let tileSize: CGFloat = 100
        let padding: CGFloat = 20
        let safeAreaInsets = getSafeAreaInsets()
        let safePadding = padding + tileSize / 2 // Ensure the entire tile fits within the safe area

        for tile in tiles {
            if tilePositions[tile.id] != nil {
                let xPosition = CGFloat.random(in: safePadding...(screenWidth - safePadding - tileSize))
                let yPosition = CGFloat.random(in: safePadding + safeAreaInsets.top...(screenHeight - safePadding - safeAreaInsets.bottom - tileSize))

                tilePositions[tile.id] = CGPoint(x: xPosition, y: yPosition)
                tileRotations[tile.id] = Double.random(in: -30...30)
            }
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
                    if self.tiles.isEmpty {
                        self.gameCompleted = true
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.selectedTiles.removeAll()
                }
            }
        }
    }
}
