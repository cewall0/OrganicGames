//
//  GameChoiceView.swift
//  OrganicPractice
//
//  Created by Chad Wallace on 7/25/24.
//

import SwiftUI

struct GameChoiceView: View {
    
    @Environment(GameViewModel.self) private var gameViewModel
    
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    @State var path = NavigationPath()
    
    func reset() {
        self.path = NavigationPath()
    }
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .headline)], for: .highlighted)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .title2)], for: .normal)
    }
    
    var body: some View {
        
        @Bindable var gameViewModel = gameViewModel
        
        NavigationStack(path: $path) {
            
            VStack{
                Text("")
                Text("")
                Text("")
                Image("Organic Games")
                    .resizable()
                    .frame(width: 250, height: 140)
                Text("")
                Divider()
                Text("")
                Button(action: {
                    reset()
                    path.append(1) // Functional Groups
                }, label: {
                    Text("Functional Groups")
                })
                Text("")
                Button(action: {
                    reset()
                    path.append(2) // Functional Group Suffixes
                }, label: {
                    Text("Functional Group Suffixes")
                })
                Text("")
                Spacer()
                
            }
            .navigationDestination(for: Int.self) { destination in
                switch destination {
                case 1:
                    GameView(path: $path, tileRange: 1...18)
                case 2:
                    GameView(path: $path, tileRange: 19...34)
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    GameChoiceView()
}
