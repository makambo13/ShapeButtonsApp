//
//  Model.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/27/25.
//

import Foundation

/*
 {
    "buttons":[
       {
          "name":"Circle",
          "draw_path":"circle"
       },
       {
          "name":"Square",
          "draw_path":"square"
       },
       {
          "name":"Triangle",
          "draw_path":"triangle"
       }
    ]
 }
 */


struct ShapeModel: Codable {
    var buttons: [ShapeButton]
}

struct ShapeButton: Codable {
    var name: String
    var draw_path: String
}
