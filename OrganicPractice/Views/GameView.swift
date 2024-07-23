//
//  ContentView.swift
//  OrganicFunctionalGroups
//
//  Created by Chad Wallace on 10/25/22.
//

import SwiftUI

struct GameView: View {
    
    @Environment(GameViewModel.self) private var viewModel
    
//    @Binding var path: NavigationPath
    
//    func reset() {
//        self.path = NavigationPath()
//    }
    
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
        
    var body: some View {
        
        ZStack {
                 ForEach(viewModel.tiles) { tile in
                     if let position = viewModel.tilePositions[tile.id], let rotation = viewModel.tileRotations[tile.id] {
                         TileView(tile: tile, isSelected: viewModel.selectedTiles.contains(where: { $0.id == tile.id }))
                             .rotationEffect(.degrees(rotation))
                             .position(position)
                             .onTapGesture {
                                 viewModel.selectTile(tile)
                             }
                     }
                 }
                 
                 if viewModel.gameCompleted {
                     VStack {
                         Text("Congratulations!")
                             .font(.largeTitle)
                             .fontWeight(.bold)
                             .foregroundColor(.green)
                             .padding()
                         
                         Button("Play Again") {
                             viewModel.resetGame()
                         }
                         .padding()
                         .background(Color.blue)
                         .foregroundColor(.white)
                         .cornerRadius(10)
                     }
                     .background(Color.white.opacity(0.8))
                     .cornerRadius(20)
                     .shadow(radius: 10)
                 }
             }
             .frame(maxWidth: .infinity, maxHeight: .infinity)
             .background(Color.white)
             .edgesIgnoringSafeArea(.all)
             .onAppear {
                 viewModel.resetGame()
             }
         }
     }

     struct TileView: View {
         var tile: Tile
         var isSelected: Bool
         
         var body: some View {
             Image(tile.name)
                 .resizable()
                 .aspectRatio(1, contentMode: .fit)
                 .frame(width: 100, height: 100)
                 .background(isSelected ? Color.yellow.opacity(0.3) : Color.clear)
                 .cornerRadius(10)
                 .shadow(radius: 5)
                 .overlay(
                     RoundedRectangle(cornerRadius: 10)
                         .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
                 )
         }
     }
