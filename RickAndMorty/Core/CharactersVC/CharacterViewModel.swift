//
//  CharacterViewMode.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//

import UIKit

protocol CharacterViewModelOutput: AnyObject {
    func updateView()
}

final class CharactersViewModel {
    
    var characters: [RMCharacter] = []
    weak var output: CharacterViewModelOutput?
    
    private let manager: NetworkManager
    
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    func getAllCharacters(page: Int) {
        guard let url = URL(string: manager.baseURL + "character/?page=\(page)") else { return }
                
        let request = URLRequest(url: url)
        
        manager.fetch(RMCharacterResponse.self, urlRequest: request) { result in
            
            switch result {
            case .success(let response):
                print(response.results.count)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.characters = response.results
                    self.output?.updateView()
                }
            case .failure(let error):
                print("Error:", error)
                // MARK: Show Alert OR Empty State view.
            }
        }
    }
    
    func confiugreCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseId, for: indexPath) as! CharacterCell
        let character = characters[indexPath.row]
        cell.set(character: character)
        
        return cell
    }
}
