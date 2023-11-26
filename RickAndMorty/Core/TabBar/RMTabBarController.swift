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
        viewControllers = [createCharactersVC(), createLocationsVC(), createEpisodesVC()]
    }

    func createCharactersVC() -> UINavigationController {
        let viewModel = CharactersViewModel()
        
        let charactersVC = CharactersVC(viewModel: viewModel)
        charactersVC.title = "Characters"
        charactersVC.tabBarItem = UITabBarItem(title: "Characters", image: .init(systemName: "person.2"), tag: 0)
        
        return UINavigationController(rootViewController: charactersVC)
    }

    func createLocationsVC() -> UINavigationController {
        let locationsVC = LocationsVC()
        locationsVC.title = "Locations"
        locationsVC.tabBarItem = UITabBarItem(title: "Locations", image: .init(systemName: "map"), tag: 0)
        
        return UINavigationController(rootViewController: locationsVC)
    }
    
    func createEpisodesVC() -> UINavigationController {
        let episodesVC = EpisodesVC()
        episodesVC.title = "Episodes"
        episodesVC.tabBarItem = UITabBarItem(title: "Episodes", image: .init(systemName: "tv"), tag: 0)
        
        return UINavigationController(rootViewController: episodesVC)
    }
}
