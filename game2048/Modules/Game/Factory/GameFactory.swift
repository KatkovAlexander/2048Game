//
//  GameFactory.swift
//  game2048
//
//  Created by Alexander on 07.04.2024.
//

import UIKit

final class GameFactory {
    
    func build() -> UIViewController {
        guard let viewController = UIStoryboard(name: String(describing: GameViewController.self), bundle: nil).instantiateInitialViewController() as? GameViewController else {
            fatalError("Can't load ChatbotViewController from storyboard")
        }
        
        let viewModel = GameViewModel()
        viewController.viewModel = viewModel
        
        return viewController
    }
}
