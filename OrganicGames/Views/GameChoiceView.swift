//
//  GameChoiceView.swift
//  OrganicPractice
//
//  Created by Chad Wallace on 7/25/24.
//

import SwiftUI

struct GameChoiceView: View {
    @Environment(GameViewModel.self) private var viewModel
    @State var path = NavigationPath()

    func reset() {
        self.path = NavigationPath()
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack{
                    
                    Spacer()
                    Link(destination: URL(string: "https://sites.google.com/view/organic-chem-games/home")!) {
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.trailing)
                            .foregroundColor(.gray)
                    }
                }
                    Image("OrganicGamesTitle")
                        .resizable()
                        .frame(width: 375, height: 210)
                    
        

                
                Divider()
                Text("")
                Button(action: {
                    reset()
                    viewModel.gameType = .game1
                    viewModel.resetGame(for: .game1)
                    path.append(GameType.game1)
                }, label: {
                    Text("Functional Groups")
                })
                Text("")
                Button(action: {
                    reset()
                    viewModel.gameType = .game2
                    viewModel.resetGame(for: .game2)
                    path.append(GameType.game2)
                }, label: {
                    Text("Functional Group Suffixes")
                })
                Text("")
                Button(action: {
                    reset()
                    viewModel.gameType = .game3
                    viewModel.resetGame(for: .game3)
                    path.append(GameType.game3)
                }, label: {
                    Text("Formal Charges")
                })
                Text("")
                Button(action: {
                    reset()
                    viewModel.gameType = .game4
                    viewModel.resetGame(for: .game4)
                    path.append(GameType.game4)
                }, label: {
                    Text("Hybridization")
                })
                Spacer()
            }
            .navigationDestination(for: GameType.self) { gameType in
                GameView(path: $path, gameType: gameType)
            }
        }
    }
}
