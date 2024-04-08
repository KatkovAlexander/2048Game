//
//  GameViewController.swift
//  game2048
//
//  Created by Alexander on 07.04.2024.
//

import Combine
import UIKit

final class GameViewController: UIViewController {
    
    var viewModel: GameViewModel?
    
    // MARK: Constants
    
    private enum Constants {
        static let cornerRadius = 10.0
        static let cellsInRow = 4
        static let spacing = 8.0
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var gameBoard: UIView! {
        didSet {
            gameBoard.layer.cornerRadius = Constants.cornerRadius
        }
    }
    
    @IBOutlet weak var gameOverView: UIView! {
        didSet {
            gameOverView.isHidden = true
            gameOverView.layer.cornerRadius = Constants.cornerRadius
        }
    }
    
    @IBOutlet weak var yourScoreView: UIView! {
        didSet {
            yourScoreView.layer.cornerRadius = Constants.cornerRadius
        }
    }
    
    @IBOutlet weak var youScoreLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton! {
        didSet {
            restartButton.layer.cornerRadius = Constants.cornerRadius
        }
    }
    
    // MARK: Private properties
    
    private var cancellableSet = Set<AnyCancellable>()
    private var isStart = true
    private var cells = [[CellView]]()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipes()
        bindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isStart else {
            return
        }
        createCells()
        viewModel?.startGame()
        isStart = false
    }
    
    // MARK: Actions
    
    
    @IBAction func restartButtonTap(_ sender: Any) {
        viewModel?.startGame()
    }
}

// MARK: Actions

@objc
private extension GameViewController {
    
    func swipeUp() {
        viewModel?.didSwiped(direction: .up)
        animate(.up)
    }
    
    func swipeDown() {
        viewModel?.didSwiped(direction: .down)
        animate(.down)
    }
    
    func swipeLeft() {
        viewModel?.didSwiped(direction: .left)
        animate(.left)
    }
    
    func swipeRight() {
        viewModel?.didSwiped(direction: .right)
        animate(.right)
    }
}

// MARK: Private methods

private extension GameViewController {
    
    func setupSwipes() {
        let upSwipe = UISwipeGestureRecognizer(
            target: self, action: #selector(swipeUp)
        )
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(
            target: self, action: #selector(swipeDown)
        )
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(
            target: self, action: #selector(swipeLeft)
        )
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(
            target: self, action: #selector(swipeRight)
        )
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func createCells() {
        let cellSize = (gameBoard.frame.width - 2 * Constants.spacing) / CGFloat(Constants.cellsInRow)

        for posY in 0..<Constants.cellsInRow {
            var rowViews = [CellView]()
            for posX in 0..<Constants.cellsInRow {
                let horizontalPosition = posX == 0
                ? Constants.spacing
                : CGFloat(posX) * cellSize + Constants.spacing
                
                let verticalPosition = posY == 0
                ? Constants.spacing
                : CGFloat(posY) * cellSize + Constants.spacing
                
                let cell = createCell(CGRect(
                    x: horizontalPosition,
                    y: verticalPosition,
                    width: cellSize,
                    height: cellSize
                ))
                rowViews.append(cell)
                gameBoard.addSubview(cell)
                viewModel?.didEmptyCellAdded(posY: verticalPosition, posX: horizontalPosition)
            }
            cells.append(rowViews)
        }
    }
    
    func createCell(_ frame: CGRect) -> CellView {
        guard let view = UINib(nibName: String(describing: CellView.self),
                               bundle: nil
        ).instantiate(withOwner: nil, options: nil).last as? CellView else {
            fatalError("fatalError")
        }
        view.setupFrame(frame)
        return view
    }
    
    func animate(_ swipe: SwipeDirectionType) {
//        var newFrame = cell.frame
//        
//        switch swipe {
//            case .up:
//                newFrame.origin.y = Constants.spacing
//            case .down:
//                newFrame.origin.y = gameBoard.frame.height - Constants.spacing - cell.frame.height
//            case .left:
//                newFrame.origin.x = Constants.spacing
//            case .right:
//                newFrame.origin.x = gameBoard.frame.width - Constants.spacing - cell.frame.width
//        }
//        
//        UIView.animate(
//            withDuration: 0.15,
//            delay: 0,
//            options: [.curveEaseOut],
//            animations: {
//                self.cell.frame = newFrame
//            }
//        )
    }
    
    func bindings() {
        viewModel?.$board
            .sink { [unowned self] board in
                guard !cells.isEmpty else { return }
                for yPos in 0..<board.count {
                    for xPos in 0..<board.count {
                        cells[yPos][xPos].bind(model: board[yPos][xPos])
                    }
                }
            }
            .store(in: &cancellableSet)
        viewModel?.$isGameOver
            .sink { [unowned self] isGameOver in
                self.gameOverView.isHidden = !isGameOver
            }
            .store(in: &cancellableSet)
        viewModel?.$yourScore
            .sink { [unowned self] yourScore in
                self.youScoreLabel.text = String(yourScore)
            }
            .store(in: &cancellableSet)
    }
}
