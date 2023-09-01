//
//  EggParameters.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import Foundation

enum EggSize: String, CaseIterable {
    case s = "S"
    case m = "M"
    case l = "L"
    case xl = "XL"
}

enum EggTemp: String, CaseIterable {
case refrigerated = "Refrigerated"
case room =  "Room"
}

enum EggCondition: String, CaseIterable {
    case soft = "Soft"
    case medium = "Medium"
    case hard = "Hard"
}
