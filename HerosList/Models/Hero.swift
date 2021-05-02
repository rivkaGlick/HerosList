//
//  Hero.swift
//  Heros
//
//  Created by rivki glick on 30/04/2021.
//

import Foundation


class Hero: Codable{
    
    var id: String = ""
    var image: String = ""
    var name: String = ""
    var biography = Biography()
    var powerstats = Powerstats()
    var work = Work()
    var connections = Connections()
    
    init(id:String, name:String, image:String,biography:Biography,powerstats:Powerstats,work:Work,connections:Connections)
    {
        self.id = id
        self.name = name
        self.image = image
        self.biography = biography
        self.powerstats = powerstats
        self.connections = connections
        
    }
    
    init() {
        
    }

}
