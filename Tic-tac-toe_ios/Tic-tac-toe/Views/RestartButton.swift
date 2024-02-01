//
//  RestartButton.swift
//  Tic-tac-toe
//
//  Created by Radomyr Sidenko on 01.02.2024.
//

import SwiftUI

struct RestartButton : View {
    var resetPublisher: EventPublisher
    
    var body: some View {
        Button {
            resetPublisher.send()
        } label: {
            Label("Restart", systemImage: "arrow.counterclockwise")
        }
    }
}
