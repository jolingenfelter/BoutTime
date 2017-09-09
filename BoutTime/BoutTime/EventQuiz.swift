//
//  EventQuiz.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 9/9/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

enum QuizResult {
    case correct
    case incorrect
}

class EventQuiz {
    
    private var eventsArray: [Event]
    internal var quizArray: [Event]
    
    init() {
        
        eventsArray = [Event]()
        quizArray = [Event]()
        
        do {
            
            let convertedArray = try PlistConverter.arrayFromFile("PixarEvents", ofType: "plist")
            eventsArray = EventsUnarchiver.eventsFromArray(convertedArray)
            
            newQuiz()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func newQuiz() {
        
        eventsArray = eventsArray.shuffle
        quizArray.removeAll()
        
        for i in 0...3 {
            quizArray.append(eventsArray[i])
        }
        
    }
    
    func checkAnswer(completion: @escaping (QuizResult) -> Void) {
        
        let correctAnswer = quizArray.sorted { $0.year < $1.year }
        
        if areEqual(array1: quizArray, array2: correctAnswer) {
            completion(.correct)
        } else {
            completion(.incorrect)
        }
        
    }
    
    private func areEqual(array1: [Event], array2: [Event]) -> Bool {
        
        if array1.count != array2.count {
            return false
        }
        
        for i in 0..<array1.count {
            if array1[i] != array2[i] {
                return false
            }
        }
        
        return true
        
    }
    
}










