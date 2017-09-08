//
//  EventsUnarchiver.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 9/8/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

class EventsUnarchiver {
    class func eventsFromArray(_ array: [[String : String]]) -> [Event] {
        var eventsArray: [Event] = []
        
        for anEvent in array {
            if let event = anEvent["event"], let year = anEvent["year"], let url = anEvent["url"] {
                let newEvent = Event(event: event, year: year, url: url)
                eventsArray.append(newEvent)
            }
    
        }
        
        return eventsArray
    }
}
