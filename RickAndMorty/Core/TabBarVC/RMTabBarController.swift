//
//  RMTabBarController.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//

import UIKit

class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createCharactersVC()]
    }
    

    func createCharactersVC() -> UINavigationController {
        let manager = NetworkManager()
        let viewModel = CharactersViewModel(manager: manager)
        
        let charactersVC = CharactersVC(viewModel: viewModel)
        charactersVC.title = "Characters"
        charactersVC.tabBarItem = UITabBarItem(title: "Characters", image: .init(systemName: "person.2"), tag: 0)
        
        return UINavigationController(rootViewController: charactersVC)
    }

}
