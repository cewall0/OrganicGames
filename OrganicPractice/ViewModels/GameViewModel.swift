//
//  AppState.swift
//  Sluff Scorecard
//
//  Created by Chad Wallace on 1/31/24.
//

import Foundation
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
        resetGame(tileRange: 1...18)
    }
    
    func resetGame(tileRange: ClosedRange<Int>) {
        let tileNames = tileRange.flatMap { ["\($0 < 10 ? "0" : "")\($0)A", "\($0 < 10 ? "0" : "")\($0)B"] }
        tiles = tileNames.map { Tile(name: $0) }.shuffled()
        selectedTiles = []
        tilePositions = [:]
        tileRotations = [:]
        gameCompleted = false
        generateRandomPositionsAndRotations(for: tiles) // Pass all tiles for initial placement
    }

    func scrambleRemainingTiles() {
        // Filter out tiles that are not yet removed (or selected)
        let remainingTiles = tiles.filter { tile in
            !selectedTiles.contains(where: { $0.id == tile.id })
        }
        
        // Pair remaining tiles
        var pairs: [(Tile, Tile)] = []
        for pairIndex in stride(from: 0, to: remainingTiles.count, by: 2) {
            guard pairIndex + 1 < remainingTiles.count else { break }
            let tile1 = remainingTiles[pairIndex]
            let tile2 = remainingTiles[pairIndex + 1]
            pairs.append((tile1, tile2))
        }
        
        // Shuffle the pairs
        pairs.shuffle()
        
        // Flatten shuffled pairs into a single list of tiles
        let shuffledTiles = pairs.flatMap { [$0.0, $0.1] }
        
        // Clear existing tile positions and rotations
        tilePositions = [:]
        tileRotations = [:]
        
        // Generate new positions and rotations for the shuffled tiles
        generateRandomPositionsAndRotations(for: shuffledTiles)
    }

    func generateRandomPositionsAndRotations(for tiles: [Tile]) {
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

    func generatePositionAndRotation(for zoneIndex: Int, tileSize: CGFloat, zoneWidth: CGFloat, zoneHeight: CGFloat, safePadding: CGFloat, safeAreaInsets: UIEdgeInsets) -> (CGPoint, Double) {
        let row = zoneIndex / 7
        let column = zoneIndex % 7

        let xMin = safePadding + CGFloat(column) * zoneWidth
        let xMax = safePadding + CGFloat(column + 1) * zoneWidth - tileSize
        let yMin = safePadding + safeAreaInsets.top + CGFloat(row) * zoneHeight
        let yMax = safePadding + safeAreaInsets.top + CGFloat(row + 1) * zoneHeight - tileSize

        // Ensure valid ranges
        let xPosition = xMin < xMax ? CGFloat.random(in: xMin...xMax) : xMin
        let yPosition = yMin < yMax ? CGFloat.random(in: yMin...yMax) : yMin
        let rotation = Double.random(in: -40...40)

        return (CGPoint(x: xPosition, y: yPosition), rotation)
    }

    func areZonesFarEnoughApart(_ zone1: Int, _ zone2: Int, zonesPerRow: Int, minDistance: Int) -> Bool {
        let row1 = zone1 / zonesPerRow
        let col1 = zone1 % zonesPerRow
        let row2 = zone2 / zonesPerRow
        let col2 = zone2 % zonesPerRow

        let rowDistance = abs(row1 - row2)
        let colDistance = abs(col1 - col2)

        return rowDistance >= minDistance || colDistance >= minDistance
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
