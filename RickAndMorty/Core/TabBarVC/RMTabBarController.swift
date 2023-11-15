//
//  RMTabBarController.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//

import UIKit

class RMTabBarController: UITabBarController {

    private let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createCharactersVC(), createLocationsVC()]
    }

    func createCharactersVC() -> UINavigationController {
        let viewModel = CharactersViewModel(manager: manager)
        
        let charactersVC = CharactersVC(viewModel: viewModel)
        charactersVC.title = "Characters"
        charactersVC.tabBarItem = UITabBarItem(title: "Characters", image: .init(systemName: "person.2"), tag: 0)
        
        return UINavigationController(rootViewController: charactersVC)
    }

    func createLocationsVC() -> UINavigationController {
        let locationsVC = LocationsVC(manager: manager)
        locationsVC.title = "Locations"
        locationsVC.tabBarItem = UITabBarItem(title: "Locations", image: .init(systemName: "mappin"), tag: 0)
        
        return UINavigationController(rootViewController: locationsVC)
    }
}
