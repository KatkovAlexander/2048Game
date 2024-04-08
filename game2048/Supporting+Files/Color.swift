//
//  Color.swift
//  game2048
//
//  Created by Alexander on 08.04.2024.
//

import UIKit

enum Color: String {
    case background
    case board
    case emptyCell
    
    var ui: UIColor {
        return UIColor(named: rawValue) ?? .systemBlue
    }
    
    func cellColor(number: Int) -> UIColor {
        switch number {
            case 0:
                return Color.emptyCell.ui
            case 2:
                return UIColor(red: 234/255, green: 226/255, blue: 218/255, alpha: 1.0)
            case 4:
                return UIColor(red: 232/255, green: 222/255, blue: 200/255, alpha: 1.0)
            case 8:
                return UIColor(red: 233/255, green: 179/255, blue: 129/255, alpha: 1.0)
            case 16:
                return UIColor(red: 224/255, green: 146/255, blue: 94/255, alpha: 1.0)
            case 32:
                return UIColor(red: 228/255, green: 131/255, blue: 103/255, alpha: 1.0)
            case 64:
                return UIColor(red: 216/255, green: 99/255, blue: 67/255, alpha: 1.0)
            case 128:
                return UIColor(red: 239/255, green: 217/255, blue: 123/255, alpha: 1.0)
            case 256:
                return UIColor(red: 235/255, green: 203/255, blue: 98/255, alpha: 1.0)
            case 512:
                return UIColor(red: 225/255, green: 192/255, blue: 79/255, alpha: 1.0)
            default:
                return UIColor(red: 220/255, green: 188/255, blue: 66/255, alpha: 1.0)
            }
    }
    
    static func getCellColor(number: Int) -> UIColor {
        // Базовые цвета для чисел 2 и 8
        let firstColor = UIColor(red: 234/255, green: 226/255, blue: 218/255, alpha: 1.0) // бежевый (для числа 2)
        let secondColor = UIColor(red: 233/255, green: 179/255, blue: 129/255, alpha: 1.0) // оранжевый (для числа 8)
        
        // Значения чисел, соответствующие базовым цветам
        let firstValue = 2
        let secondValue = 8
        
        // Интерполируем цвет между базовыми цветами в зависимости от значения числа
        let ratio = CGFloat(number - firstValue) / CGFloat(secondValue - firstValue)
        
        guard let firstColorComponents = firstColor.cgColor.components,
              let secondColorComponents = secondColor.cgColor.components
        else { return firstColor }
        
        let red = firstColorComponents[0] + (secondColorComponents[0] - firstColorComponents[0]) * ratio
        let green = firstColorComponents[1] + (secondColorComponents[1] - firstColorComponents[1]) * ratio
        let blue = firstColorComponents[2] + (secondColorComponents[2] - firstColorComponents[2]) * ratio

        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func getTitleColor(number: Int) -> UIColor {
        if number <= 4 {
            return .darkText
        } else {
            return .white
        }
    }
}
