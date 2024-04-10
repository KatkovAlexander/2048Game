//
//  CellView.swift
//  game2048
//
//  Created by Alexander on 07.04.2024.
//

import UIKit

final class CellView: UIView {
    
    // MARK: Constants
    
    private enum Constants {
        static let animationTimeInterval = 0.25
        static let shakeAnimationTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        static let popStartAnimationTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = AppConstants.cornerRadius
        }
    }
    
    @IBOutlet weak var numberLabel: UILabel!
    
    var fframe: CGRect?
}

// MARK: Internal methods

extension CellView {
    
    func setupFrame(_ frame: CGRect) {
        self.frame = frame
        fframe = frame
    }
    
    func bind(model: CellModel) {
        numberLabel.text = model.number != 0
        ? String(model.number)
        : nil
    
        containerView.backgroundColor = Color.getCellColor(number: model.number)
        numberLabel.textColor = Color.getTitleColor(number: model.number)
        
        if model.type == .updated {
            shakeAnimation()
        } else if model.type == .new {
            popUpAnimation()
        }
    }
}

// MARK: Private methods

private extension CellView {
    
    func shakeAnimation() {
        let originalTransform = containerView.transform
        
        UIView.animate(withDuration: Constants.animationTimeInterval) {
            self.containerView.transform = Constants.shakeAnimationTransform
        } completion: { _ in
            UIView.animate(withDuration: Constants.animationTimeInterval) {
                self.containerView.transform = originalTransform
            }
        }
    }
    
    func popUpAnimation() {
        let originalTransform = containerView.transform
        containerView.transform = Constants.popStartAnimationTransform
        
        UIView.animate(withDuration: Constants.animationTimeInterval) {
            self.containerView.transform = originalTransform
        }
    }
}
