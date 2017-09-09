//
//  EventQuiz.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 9/9/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

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
    
}
