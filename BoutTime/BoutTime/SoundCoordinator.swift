//
//  SoundCoordinator.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 9/8/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundCoordinator {
    
    private var correctSound: SystemSoundID = 0
    private var incorrectSound: SystemSoundID = 0
    
    init() {
        loadSoundCorrectAnswer()
        loadSoundInCorrectAnswer()
    }
    
    private func loadSoundCorrectAnswer() {
        let pathToFile = Bundle.main.path(forResource: "CorrectDing", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &correctSound)
    }
    
    func playCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    private func loadSoundInCorrectAnswer() {
        let pathToFile = Bundle.main.path(forResource: "IncorrectBuzz", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &incorrectSound)
    }
    
    func playIncorrectSound() {
        AudioServicesPlaySystemSound(incorrectSound)
    }
    
}
