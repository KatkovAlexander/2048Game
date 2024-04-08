//
//  GlobalRouter.swift
//  game2048
//
//  Created by Alexander on 07.04.2024.
//

import UIKit

class GlobalRouter {
    
    static let instance = GlobalRouter()
    
    weak var window: UIWindow?
    
    func setGame() {
        let module = GameFactory().build()
//        let navigation = NavigationController(rootViewController: module)
//        
//        //        navigation.navigationBar.tintColor = Colors.Light.ui
//        navigation.navigationBar.shadowImage = UIImage()
//        navigation.navigationBar.layer.shadowOffset = .init(width: 0, height: -10)
        
        //
        //        let appearance = UINavigationBarAppearance()
        //        appearance.configureWithTransparentBackground()
        //
        //        navigation.navigationBar.compactAppearance = appearance
        //        navigation.navigationBar.standardAppearance = appearance
        //        navigation.navigationBar.scrollEdgeAppearance = appearance
        
        window?.rootViewController = module
        window?.makeKeyAndVisible()
    }
}
