//
//  Model.swift
//  Circuit
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


struct ShapeModel: Codable, Sendable {
    var buttons: [ShapeButton]
}

struct ShapeButton: Codable, Sendable {
    var name: String
    var draw_path: String
}
