//
//  AppInitializer.swift
//  game2048
//
//  Created by Alexander on 07.04.2024.
//

import UIKit

class AppInitializer {
    
    static let instance = AppInitializer()
    
    func appInit(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        
        GlobalRouter.instance.window = window
        GlobalRouter.instance.setGame()
        
        return window
    }
}
