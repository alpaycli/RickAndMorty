//
//  CharacterViewMode.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//

import UIKit

protocol CharacterViewModelOutput: AnyObject {
    func updateView(with characters: [RMCharacter])
}


final class CharactersViewModel {
    
    var hasMoreCharacters = true
    var isLoadingCharacters = false
    
    var characters: [RMCharacter] = []
    weak var output: CharacterViewModelOutput?
    
    func getAllCharacters(page: Int) {
        let request: Request<RMCharacterResponse> = .getAllCharacters(forPage: page)
        isLoadingCharacters = true
        URLSession.shared.decode(request) { result in
            switch result {
            case .success(let response): self.handleSuccessResult(with: response)
            case .failure(let error): self.handleFailureResult(with: error)
            }
            self.isLoadingCharacters = false
        }
    }
    
    private func handleSuccessResult(with response: RMCharacterResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if response.results.count < 20 { hasMoreCharacters = false }
            self.characters.append(contentsOf: response.results)
            self.output?.updateView(with: characters)
        }
    }
    
    private func handleFailureResult(with error: APIError) {
        print("Error:", error.description)
        // MARK: Show Alert OR Empty State view.
    }
}
