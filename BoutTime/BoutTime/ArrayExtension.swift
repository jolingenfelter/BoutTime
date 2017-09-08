//
//  ArrayExtension.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 9/8/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

//Extension to randomize events for each round
extension Array {
    var shuffle:[Element] {
        var elements = self
        for index in 0..<elements.count {
            let newIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if index != newIndex {
                swap(&elements[index], &elements[newIndex])
            }
        }
        return elements
    }
}
