//
//  Word.swift
//  Bible Memorization
//
//  Created by Chad Wallace on 2/21/24.
//

import Foundation
import Observation

struct Tile: Identifiable {
    var id: UUID = UUID()
       var name: String
       var number: String {
           String(name.prefix(2))
       }
       var letter: String {
           String(name.suffix(1))
       }
   }
