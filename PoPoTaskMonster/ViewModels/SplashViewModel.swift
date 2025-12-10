//
//  SplashViewModel.swift
//  PoPoTaskMonsterApp
//
//  Created by Fahdah Alsamari on 13/06/1447 AH.
//

import SwiftUI
import Combine

final class SplashViewModel: ObservableObject {

    @Published var showCharacter = false
    @Published var showTexts = false
    @Published var showButton = false
    @Published var blinkFrame = 0
    @Published var navigate = false

    let characterDelay: TimeInterval = 0.3
    let textsDelay: TimeInterval = 0.9
    let buttonDelay: TimeInterval = 1.4
    let blinkDelay: TimeInterval = 2.1

    var currentCharacterImageName: String {
        switch blinkFrame {
        case 1: return "character_half"
        case 2: return "character_closed"
        default: return "character_open"
        }
    }

    func startAnimations(reduceMotion: Bool) {

        DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay) {
            self.showCharacter = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + textsDelay) {
            self.showTexts = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + buttonDelay) {
            self.showButton = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDelay) {
            self.blinkOnce(reduceMotion: reduceMotion)
        }
    }

    func blinkOnce(reduceMotion: Bool) {
        guard !reduceMotion else { return }

        blinkFrame = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { self.blinkFrame = 2 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) { self.blinkFrame = 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { self.blinkFrame = 0 }
    }
}
