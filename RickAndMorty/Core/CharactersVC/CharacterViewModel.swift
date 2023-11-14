//
//  CharacterViewMode.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//

import Foundation

final class CharactersViewModel {
    
    func getAllCharacters(page: Int) {
        guard let url = URL(string: NetworkManager.shared.baseURL + "character/?page=\(page)") else { return }
                
        let request = URLRequest(url: url)
        
        NetworkManager.shared.fetch(RMCharacterResponse.self, urlRequest: request) { result in
            
            switch result {
            case .success(let response):
                print(response.results.count)
            case .failure(let error):
                print("Error:", error)
            }
            
        }
        
    }
}
