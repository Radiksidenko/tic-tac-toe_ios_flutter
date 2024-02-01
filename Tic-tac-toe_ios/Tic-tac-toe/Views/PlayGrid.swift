//
//  PlayGrid.swift
//  Tic-tac-toe
//
//  Created by Radomyr Sidenko on 01.02.2024.
//

import SwiftUI

struct PlayGrid: View {
    
    let resetPublisher: EventPublisher
    
    let length: Double
    
    @State private var game = TicTacToe(startingPlayer: .x)
    @State private var animationCompletion = 0.0
    
    var body: some View {
        
        let lineWidth = 0.025 * length
        
        VStack(spacing: lineWidth) {
            ForEach(0..<3) { row in
                HStack(spacing: lineWidth) {
                    ForEach(0..<3) { column in
                        let index = game.index(row: row, column: column)
                        let cell = game.cells[index]
                        
                        GridButton(cell: cell,
                                   lineWidth: lineWidth,
                                   resetPublisher: resetPublisher,
                                   onClick: { onClick(at: index) })
                        .disabled(!cell.isEmpty || !game.isOngoing)
                        .padding(lineWidth / 2)
                    }
                }
            }
        }
        .background(MeshPlayground(lineWidth: lineWidth,
                              animationPercentage: animationCompletion))
        .frame(width: length, height: length)
        .onReceive(resetPublisher, perform: onReceiveResetEvent)
        .task {
            guard animationCompletion == 0 else { return }
            await animateGridLines()
        }
    }
    
    private func animateGridLines() async {
        let aniDuration = 0.75
        withAnimation(.easeOut(duration: aniDuration)) {
            animationCompletion = 1
        }
    }
    
    private func onClick(at index: Int) {
        Task {
            game.play(at: index)
            if isPVE, let indexAI = game.playOne() {
                game.play(at: indexAI)
            }
        }
    }
    
    private func onReceiveResetEvent() {
        Task {
            game = TicTacToe(startingPlayer: true ? .x : game.player)
        }
    }
}
