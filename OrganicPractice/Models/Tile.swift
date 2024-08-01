//
//  Word.swift
//  Bible Memorization
//
//  Created by Chad Wallace on 2/21/24.
//

import Foundation
import Observation

struct Tile: Identifiable {
    var id = UUID()
    var name: String
    
    var number: Int {
        // Extract number from name
        // Ignore the first three characters
               let nameWithoutPrefix = String(name.dropFirst(3))

               // Extract number from the remaining name
               if let number = Int(nameWithoutPrefix.filter { $0.isNumber }) {
                   return number
               }
               return 0
    }
    
    var letter: String {
        // Extract letter from name
        if name.hasPrefix("G3_Atom") || name.hasPrefix("G3_Charge") {
            return ""
        }
        return String(name.suffix(1))
    }
    
    var imageName: String {
//        // Return corresponding image name
//        switch name {
//        case "Charge_plus":
//            return "charge_plus"
//        case "Charge0":
//            return "charge_zero"
//        case "Charge_minus":
//            return "charge_minus"
//        default:
            return name
//        }
    }
    
    var isAtom: Bool {
           return name.hasPrefix("G3_Atom")
       }
       
    var isCharge: Bool {
           return name.hasPrefix("G3_Charge")
       }
    
}
