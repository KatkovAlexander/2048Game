//
//  Collection+extension.swift
//  game2048
//
//  Created by Alexander on 07.04.2024.
//

extension Collection where Element == CellModel {
    
    /// Удаление 0 из массива
    func filterEmptyElements() -> [CellModel] {
        self.filter { cell in
            cell.number != 0
        }
    }
    
    /// Добавление 0 в массив
    func fillWithEmptyElements(_ neededSize: Int) -> [CellModel] {
        var result = [CellModel]()
        result.append(contentsOf: self)
        
        for _ in 0..<(neededSize - self.count) {
            result.append(.init(number: 0))
        }
        return result
    }
    
    /// Переворачивание массива
    func reverseElements() -> [CellModel] {
        var result = [CellModel]()
        
        for element in self.reversed() {
            result.append(element)
        }
        
        return result
    }
    
    /// Складывание чисел
    func additionElements() -> (updatedArray: [CellModel], additionSum: Int) {
        guard let array = self as? [CellModel] else {
            return ([], 0)
        }
        
        var additionSum = 0
        var result = [CellModel]()
        
        var index = 0
        while index < array.count {
            if index == array.count - 1 {
                result.append(.init(number: array[index].number))
                break
            } else if array[index] == array[index + 1] {
                result.append(.init(type: .updated, number: array[index].number * 2))
                additionSum += array[index].number * 2
                index += 2
            } else {
                result.append(.init(number: array[index].number))
                index += 1
            }
        }
        
        return (result, additionSum)
    }
    
    func isFull() -> Bool {
        for cell in self where cell.number == 0 {
            return false
        }
        return true
    }
}

extension Collection where Element == [CellModel] {
    
    /// Генерация нового числа
    func generateNumber() -> [[CellModel]]? {
        guard var array = self as? [[CellModel]] else {
            return nil
        }
        
        let emptyPositions = array.getEmptyPositions()
        guard emptyPositions.count != 0 else {
            return nil
        }
        
        let randomPosition = emptyPositions[Int.random(in: 0..<emptyPositions.count)]
        array[randomPosition.posY][randomPosition.posX] = .init(type: .new, number: Int.random(in: 1...2) * 2)
        return array
    }
    
    /// Получение случайной позиции
    func getEmptyPositions() -> [(posX: Int, posY: Int)] {
        guard let array = self as? [[CellModel]] else {
            return []
        }
        
        var emptyPositions = [(posX: Int, posY: Int)]()
        
        for posY in 0..<array.count {
            for posX in 0..<array.count {
                if array[posY][posX].number == 0 {
                    emptyPositions.append((posX, posY))
                }
            }
        }
        
        return emptyPositions
    }
    
    func isFull() -> Bool {
        for row in self where !row.isFull() {
            return false
        }
        
        return true
    }
}
