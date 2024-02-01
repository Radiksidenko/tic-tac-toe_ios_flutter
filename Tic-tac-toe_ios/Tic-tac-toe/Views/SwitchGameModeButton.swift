//
//  SwitchGameModeButton.swift
//  Tic-tac-toe
//
//  Created by Radomyr Sidenko on 01.02.2024.
//

import SwiftUI

struct SwitchGameModeButton: View {
    var resetPublisher: EventPublisher
    
    @State var title = isPVE ? "1 Player" : "2 Players"
    
    var body: some View {
        Button {
            isPVE.toggle()
            title = isPVE ? "1 Player" : "2 Players"
            resetPublisher.send()
        } label: {
            Text(title)
        }
    }
}
