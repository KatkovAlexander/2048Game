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
    @Published var yourScore: Int = .zero
    @Published var board = [[CellModel]]()
    
    
}

// MARK: Intrenal methods

extension GameViewModel {
    
    func startGame() {
        board = Array(
            repeating: Array(repeating: CellModel(number: .zero), count: Constants.cellsInRow),
            count: Constants.cellsInRow
        )
        
        guard let updatedBoard = board.generateNumber()?.generateNumber()
        else { return }
        isGameOver = false
        yourScore = .zero
        board = updatedBoard
    }
    
    func didSwiped(direction: SwipeDirectionType) {
        updateBoard(direction)
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
                for row in .zero..<updatedBoard.count {
                    let updateRow = updateRow(
                        board.map { $0[row] },
                        needReverse: direction == .down
                    )
                    
                    for index in .zero..<updatedBoard.count {
                        updatedBoard[index][row] = updateRow[index]
                    }
                }
            case .left, .right:
                for column in .zero..<updatedBoard.count {
                    updatedBoard[column] = updateRow(
                        updatedBoard[column],
                        needReverse: direction == .right
                    )
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
