//
//  CellModel.swift
//  game2048
//
//  Created by Alexander on 07.04.2024.
//

import UIKit

enum CellType: Int {
    case nothing
    case updated
    case new
}

struct CellModel: Equatable {
    let type: CellType
    let number: Int
    
    init(type: CellType = .nothing, number: Int) {
        self.type = type
        self.number = number
    }
    
    static func == (
        lhs: CellModel,
        rhs: CellModel
    ) -> Bool {
        lhs.number == rhs.number
    }
}
