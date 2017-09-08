//
//  plistConverter.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 9/8/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

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
