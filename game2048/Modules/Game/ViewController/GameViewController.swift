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
        static let spacing = 8.0
        static let numberOfTouchToSwipe = 1
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var gameBoard: UIView! {
        didSet {
            gameBoard.layer.cornerRadius = AppConstants.cornerRadius
        }
    }
    
    @IBOutlet weak var gameOverView: UIView! {
        didSet {
            gameOverView.isHidden = true
            gameOverView.layer.cornerRadius = AppConstants.cornerRadius
        }
    }
    
    @IBOutlet weak var yourScoreView: UIView! {
        didSet {
            yourScoreView.layer.cornerRadius = AppConstants.cornerRadius
        }
    }
    
    @IBOutlet weak var youScoreLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton! {
        didSet {
            restartButton.layer.cornerRadius = AppConstants.cornerRadius
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
    }
    
    func swipeDown() {
        viewModel?.didSwiped(direction: .down)
    }
    
    func swipeLeft() {
        viewModel?.didSwiped(direction: .left)
    }
    
    func swipeRight() {
        viewModel?.didSwiped(direction: .right)
    }
}

// MARK: Private methods

private extension GameViewController {
    
    func setupSwipes() {
        let upSwipe = UISwipeGestureRecognizer(
            target: self, action: #selector(swipeUp)
        )
        upSwipe.numberOfTouchesRequired = Constants.numberOfTouchToSwipe
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(
            target: self, action: #selector(swipeDown)
        )
        downSwipe.numberOfTouchesRequired = Constants.numberOfTouchToSwipe
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(
            target: self, action: #selector(swipeLeft)
        )
        leftSwipe.numberOfTouchesRequired = Constants.numberOfTouchToSwipe
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(
            target: self, action: #selector(swipeRight)
        )
        rightSwipe.numberOfTouchesRequired = Constants.numberOfTouchToSwipe
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func createCells() {
        let cellSize = (gameBoard.frame.width - 2 * Constants.spacing) / CGFloat(AppConstants.cellsInRow)

        for column in .zero..<AppConstants.cellsInRow {
            var rowViews = [CellView]()
            for row in .zero..<AppConstants.cellsInRow {
                let horizontalPosition = row == .zero
                ? Constants.spacing
                : CGFloat(row) * cellSize + Constants.spacing
                
                let verticalPosition = column == .zero
                ? Constants.spacing
                : CGFloat(column) * cellSize + Constants.spacing
                
                let cell = createCell(CGRect(
                    x: horizontalPosition,
                    y: verticalPosition,
                    width: cellSize,
                    height: cellSize
                ))
                rowViews.append(cell)
                gameBoard.addSubview(cell)
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
    
    func bindings() {
        viewModel?.$board
            .sink { [unowned self] board in
                guard !cells.isEmpty else { return }
                for column in .zero..<board.count {
                    for row in .zero..<board.count {
                        cells[column][row].bind(model: board[column][row])
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
