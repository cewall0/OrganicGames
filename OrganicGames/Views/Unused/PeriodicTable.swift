//
//  PeriodicTable.swift
//  OrganicPractice
//
//  Created by Chad Wallace on 7/25/24.
//

import Foundation
import SwiftUI

struct Element: Identifiable {
    let id = UUID()
    let atomicNumber: Int
    let symbol: String
    let name: String
    let position: (row: Int, column: Int)

}

let first20Elements: [Element] = [
    Element(atomicNumber: 1, symbol: "H", name: "Hydrogen", position: (row: 0, column: 0)),
    Element(atomicNumber: 2, symbol: "He", name: "Helium", position: (row: 0, column: 17)),
    Element(atomicNumber: 3, symbol: "Li", name: "Lithium", position: (row: 1, column: 0)),
    Element(atomicNumber: 4, symbol: "Be", name: "Beryllium", position: (row: 1, column: 1)),
    Element(atomicNumber: 5, symbol: "B", name: "Boron", position: (row: 1, column: 12)),
    Element(atomicNumber: 6, symbol: "C", name: "Carbon", position: (row: 1, column: 13)),
    Element(atomicNumber: 7, symbol: "N", name: "Nitrogen", position: (row: 1, column: 14)),
    Element(atomicNumber: 8, symbol: "O", name: "Oxygen", position: (row: 1, column: 15)),
    Element(atomicNumber: 9, symbol: "F", name: "Fluorine", position: (row: 1, column: 16)),
    Element(atomicNumber: 10, symbol: "Ne", name: "Neon", position: (row: 1, column: 17)),
    Element(atomicNumber: 15, symbol: "P", name: "Phosphorus", position: (row: 2, column: 14)),
    Element(atomicNumber: 16, symbol: "S", name: "Sulfur", position: (row: 2, column: 15)),
    Element(atomicNumber: 17, symbol: "Cl", name: "Chlorine", position: (row: 2, column: 16)),
    Element(atomicNumber: 35, symbol: "Br", name: "Bromine", position: (row: 3, column: 16)),
    Element(atomicNumber: 53, symbol: "I", name: "Iodine", position: (row: 4, column: 16)),
    Element(atomicNumber: 85, symbol: "At", name: "Astatine", position: (row: 5, column: 16))
]
