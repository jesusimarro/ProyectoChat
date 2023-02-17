//
//  Struct.swift
//  ProyectoChat
//
//  Created by estech on 17/2/23.
//

import Foundation

struct Contactos: Codable {
    let name: String
    let token: String
    let message: [[String]]
}
