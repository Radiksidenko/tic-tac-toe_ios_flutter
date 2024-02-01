//
//  GridButton.swift
//  Tic-tac-toe
//
//  Created by Radomyr Sidenko on 01.02.2024.
//

import SwiftUI

struct GridButton : View {
    
    @State private var animationCompletion = 0.0
    
    let cell: TicTacToe.Cell
    let lineWidth: Double
    let resetPublisher: EventPublisher
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            PlayerView(player: cell.player,
                       lineWidth: lineWidth,
                       animationCompletion: animationCompletion)
        }
        .buttonStyle(.borderless)
        .foregroundColor(foregroundColor)
        .animation(PlayerView.animation, value: cell.isMatching)
        .animation(PlayerView.animation, value: animationCompletion)
        .onChange(of: cell.player) { player in
            if player != nil { animationCompletion = 1 }
        }
        .onReceive(resetPublisher) {
            animationCompletion = 0
        }
    }
    
    private var foregroundColor: Color? {
        
        guard !cell.isMatching else { return .green }
        switch cell.player {
        case .x:
            return .red
        case .o:
            return .blue
        case nil:
            return nil
        }
    }
}
