//
//  Connections.swift
//  Heros
//
//  Created by rivki glick on 01/05/2021.
//

import Foundation
class Connections:Codable{
    
    var group_affiliation: String = ""
    var relatives: String = ""
    
    init(group_affiliation:String, relatives:String)
    {
        self.group_affiliation = group_affiliation
        self.relatives = relatives
    }
    
    init() {
        
    }
}
