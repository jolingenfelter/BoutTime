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

enum EventError: ErrorType {
    case InvalidResource
    case PListConversionError
    case InvalidKey
}


// Helper Classes

class PlistConverter {
    
    class func arrayFromFile(resource: String, ofType type: String) throws -> [[String: String]] {
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw EventError.InvalidResource
        }
        
        guard let array = NSArray(contentsOfFile: path), let castArray = array as?[[String : String]] else {
            throw EventError.PListConversionError
        }
        
        return castArray
    }
}

class EventsUnarchiver {
    class func eventsFromArray(array: [[String : String]]) -> [Event] {
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