//
//  EventsModel.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 7/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation

// Model Event

struct Event {
    let event: String
    let year: String
    let url: String
}

// Errors

enum EventError: Error {
    case invalidResource
    case pListConversionError
    case invalidKey
}


// Helper Classes

class PlistConverter {
    
    class func arrayFromFile(_ resource: String, ofType type: String) throws -> [[String: String]] {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            throw EventError.invalidResource
        }
        
        guard let array = NSArray(contentsOfFile: path), let castArray = array as?[[String : String]] else {
            throw EventError.pListConversionError
        }
        
        return castArray
    }
}

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
