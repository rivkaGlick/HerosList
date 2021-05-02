//
//  Work.swift
//  Heros
//
//  Created by rivki glick on 01/05/2021.
//

import Foundation
class Work:Codable{
    
    var base: String = ""
    var occupation: String = ""

    init(base:String, occupation:String)
    {
        self.base = base
        self.occupation = occupation
    }
    
    init() {
        
    }
}
