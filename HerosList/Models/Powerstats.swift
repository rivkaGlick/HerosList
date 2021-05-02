//
//  Appearance.swift
//  Heros
//
//  Created by rivki glick on 01/05/2021.
//

import Foundation
class Powerstats:Codable{
    
    var combat: String = ""
    var durability: String = ""
    var intelligence: String = ""
    var power: String = ""
    var speed: String = ""
    var strength: String = ""
    
    
    init(combat:String, durability:String, intelligence:String,power:String,speed:String,strength:String)
    {
        self.combat = combat
        self.durability = durability
        self.intelligence = intelligence
        self.power = power
        self.speed = speed
        self.strength = strength

    }
    
    init() {
        
    }
}
