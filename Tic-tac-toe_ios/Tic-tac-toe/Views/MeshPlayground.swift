//
//  MeshPlayground.swift
//  Tic-tac-toe
//
//  Created by Radomyr Sidenko on 01.02.2024.
//

import SwiftUI

struct MeshPlayground : Shape {
    
    let lineWidth: Double
    var animationPercentage: Double
    
    var animatableData: Double {
        get { animationPercentage }
        
        set { animationPercentage = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            var offset = (x: 0.0, y: 0.0)
            
            let cellWidth = (rect.width - 2 * lineWidth) / 3
            let cellHeight = (rect.height - 2 * lineWidth) / 3
            
            for _ in 0..<2 {
                
                offset.x += cellWidth + lineWidth / 2
                path.move(to: CGPoint(x: rect.minX + offset.x, y: rect.minY))
                
                path.addVLine(height: animationPercentage * rect.height)
                offset.y += cellHeight + lineWidth / 2
                path.move(to: CGPoint(x: rect.minX, y: rect.minY + offset.y))
                path.addHLine(width: animationPercentage * rect.width)
                
                offset.x += lineWidth / 2
                offset.y += lineWidth / 2
            }
        }
        .strokedPath(StrokeStyle(lineWidth: lineWidth))
    }
}

fileprivate extension Path {
    
    mutating func addHLine(width: Double) {
        guard let currentPoint else { return }
        addLine(to: CGPoint(x: currentPoint.x + width, y: currentPoint.y))
    }
    
    mutating func addVLine(height: Double) {
        guard let currentPoint else { return }
        addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y + height))
    }
}
