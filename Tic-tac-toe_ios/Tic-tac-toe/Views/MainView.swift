//
//  ContentView.swift
//  Tic-tac-toe
//
//  Created by Radomyr Sidenko on 23.01.2024.
//

import SwiftUI
import Combine

var isPVE = true

typealias EventPublisher = PassthroughSubject<Void, Never>

struct MainView : View {
    private let resetPublisher = EventPublisher()
    
    var body: some View {
        GeometryReader { geometry in
            
            let width = geometry.size.width, height = geometry.size.height
            
            PlayGrid(resetPublisher: resetPublisher,
                          length: 0.9 * min(width, height))
            .frame(width: width, height: height)
            
            VStack {
                RestartButton(resetPublisher: resetPublisher)
                SwitchGameModeButton(resetPublisher: resetPublisher)
            }
        }
    }
}
