//
//  PeriodicTableGameView.swift
//  OrganicPractice
//
//  Created by Chad Wallace on 7/25/24.
//

//import SwiftUI
//
//struct PeriodicTableGameView: View {
//    
//    @Environment(GameViewModel.self) private var gameViewModel
//    
//    @Binding var path: NavigationPath
//    
//    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
//    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
//    
//    func reset() {
//        self.path = NavigationPath()
//    }
//    
//    @State private var userAnswers = Array(repeating: "", count: 20)
//    @State private var correctCount = 0
//    @State private var timer: Timer?
//    @State private var timeRemaining = 60
//
//    var body: some View {
//        VStack {
//                  Text("Periodic Table Game")
//                      .font(.largeTitle)
//                      .padding()
//                  
//                  Text("Time Remaining: \(timeRemaining)s")
//                      .font(.headline)
//                      .padding()
//                  
//                  Text("Correct Answers: \(correctCount)")
//                      .font(.headline)
//                      .padding()
//
//                  LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 18), spacing: 10) {
//                      ForEach(0..<6) { row in
//                          ForEach(0..<18) { column in
//                              if let element = first20Elements.first(where: { $0.position.row == row && $0.position.column == column }) {
//                                  TextField("?", text: $userAnswers[first20Elements.firstIndex(where: { $0.id == element.id })!])
//                                      .frame(width: 60, height: 60)
//                                      .background(Color.gray.opacity(0.2))
//                                      .cornerRadius(8)
//                                      .multilineTextAlignment(.center)
//                                      .font(.title)
//                                      .onChange(of: userAnswers[first20Elements.firstIndex(where: { $0.id == element.id })!]) { _ in
//                                          updateCorrectCount()
//                                      }
//                              } else {
//                                  Color.clear.frame(width: 60, height: 60)
//                              }
//                          }
//                      }
//                  }
//                  .padding()
//
//                  Button("Start Game") {
//                      startGame()
//                  }
//                  .font(.title2)
//                  .padding()
//              }
//              .onAppear {
//                  resetGame()
//              }
//          }
//
//          func startGame() {
//              resetGame()
//              timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//                  if timeRemaining > 0 {
//                      timeRemaining -= 1
//                  } else {
//                      timer?.invalidate()
//                  }
//              }
//          }
//
//          func resetGame() {
//              userAnswers = Array(repeating: "", count: first20Elements.count)
//              correctCount = 0
//              timeRemaining = 60
//              timer?.invalidate()
//          }
//
//          func updateCorrectCount() {
//              correctCount = userAnswers.indices.filter { userAnswers[$0].lowercased() == first20Elements[$0].symbol.lowercased() }.count
//          }
//      }
