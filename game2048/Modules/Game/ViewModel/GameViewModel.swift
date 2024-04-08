//
//  GameViewModel.swift
//  game2048
//
//  Created by Alexander on 07.04.2024.
//

import Combine

final class GameViewModel {
    
    // MARK: Constants
    
    private enum Constants {
        static let cellsInRow = 4
    }
    
    @Published var isGameOver = true
    @Published var yourScore = 0
    @Published var board = [[CellModel]]()
    
    
}

// MARK: Intrenal methods

extension GameViewModel {
    
    func startGame() {
        board = Array(
            repeating: Array(repeating: CellModel(number: 0), count: Constants.cellsInRow),
            count: Constants.cellsInRow
        )
        
        guard let updatedBoard = board.generateNumber()?.generateNumber()
        else { return }
        isGameOver = false
        yourScore = 0
        board = updatedBoard
    }
    
    func didSwiped(direction: SwipeDirectionType) {
        updateBoard(direction)
    }
    
    func didEmptyCellAdded(posY: CGFloat, posX: CGFloat) {
        
    }
}

// MARK: Private methods

private extension GameViewModel {
        
    // TODO: подумать, как можно упростить
    @discardableResult func updateBoard(
        _ direction: SwipeDirectionType,
        isCheckSwipe: Bool = false
    ) -> Bool {
        var updatedBoard = board
        
        switch direction {
            case .up, .down:
                for column in 0..<updatedBoard.count {
                    let updateRow = updateRow(
                        board.map { $0[column] },
                        needReverse: direction == .down
                    )
                    
                    for index in 0..<updatedBoard.count {
                        updatedBoard[index][column] = updateRow[index]
                    }
                }
            case .left, .right:
                for row in 0..<updatedBoard.count {
                    updatedBoard[row] = updateRow(updatedBoard[row], needReverse: direction == .right)
                }
        }
    
        let updateBoardWithNewElement = updatedBoard.generateNumber()
        
        if updatedBoard != board && !isCheckSwipe,
           let updateBoardWithNewElement = updateBoardWithNewElement {
            
            
            board = updateBoardWithNewElement
        } else if updatedBoard == board && updateBoardWithNewElement == nil && isCheckSwipe {
            return true
        }
        
        if board.isFull() && !isCheckSwipe {
            checkAllSwipes()
        }
        
        return false
    }
    
    func updateRow(_ row: [CellModel], needReverse: Bool) -> [CellModel] {
        if needReverse {
            let updatedRow = row
                .reverseElements()
                .filterEmptyElements()
                .additionElements()
            
            yourScore += updatedRow.additionSum
            
            return updatedRow.updatedArray
                .fillWithEmptyElements(Constants.cellsInRow)
                .reverseElements()
        } else {
            let updatedRow = row
                .filterEmptyElements()
                .additionElements()
            
            yourScore += updatedRow.additionSum
            
            return updatedRow.updatedArray
                .fillWithEmptyElements(Constants.cellsInRow)
        }
    }

    /// проверка на возможность сделать ход
    func checkAllSwipes() {
        var results = [Bool]()
        
        for swipe in SwipeDirectionType.allCases {
            results.append(updateBoard(swipe, isCheckSwipe: true))
        }
        
        isGameOver = results.allSatisfy { $0 }
    }
}
