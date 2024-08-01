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
                Text("")
                Text("")
                Text("")
                Image("OrganicGamesTitle")
                    .resizable()
                    .frame(width: 375, height: 210)
                Text("")
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
                Spacer()
            }
            .navigationDestination(for: GameType.self) { gameType in
                GameView(path: $path, /*tileRange: getTileRange(for: gameType),*/ gameType: gameType)
            }
        }
    }

//    private func getTileRange(for gameType: GameType) -> ClosedRange<Int> {
//        switch gameType {
//        case .game1:
//            return 1...18
//        case .game2:
//            return 19...34
//        case .game3:
//            return 1...23
//        }
//    }
}
