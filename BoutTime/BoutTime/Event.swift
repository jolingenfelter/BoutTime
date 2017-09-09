//
//  Event.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 9/8/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

struct Event {
    let event: String
    let year: String
    let url: String
}

extension Event: Equatable {
    
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.event == rhs.event
    }
    
}

