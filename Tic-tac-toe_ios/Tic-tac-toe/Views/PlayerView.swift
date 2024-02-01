//
//  PlayerView.swift
//  Tic-tac-toe
//
//  Created by Radomyr Sidenko on 01.02.2024.
//

import SwiftUI

struct PlayerView : Shape {
    
    static let animation = Animation.easeOut(duration: 0.5)
    let player: TicTacToe.Player?
    
    let lineWidth: Double
    var animationCompletion: Double
    
    var animatableData: Double {
        get { animationCompletion }
        
        set { animationCompletion = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            guard let player else { return }
            
            let rect = rect.insetBy(dx: 0.15 * rect.width, dy: 0.15 * rect.height)
            
            switch player {
            case .x:
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            case .o:
                path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                            radius: min(rect.width, rect.height) / 2,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360),
                            clockwise: false)
            }
        }
        .trimmedPath(from: 0, to: animationCompletion)
        .strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}
