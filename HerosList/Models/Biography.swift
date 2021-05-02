//
//  Biography.swift
//  Heros
//
//  Created by rivki glick on 01/05/2021.
//

import Foundation

class Biography:Codable{
    
    var alignment: String = ""
    var alter_egos: String = ""
    var first_appearance: String = ""
    var full_name: String = ""
    
    init(alignment:String, alter_egos:String, first_appearance:String,full_name:String)
    {
        self.alignment = alignment
        self.alter_egos = alter_egos
        self.first_appearance = first_appearance
        self.full_name = full_name

    }
    
    init() {
        
    }
}
