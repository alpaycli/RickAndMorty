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
    
    func getAllCharacters(page: Int) {
        let request: Request<RMCharacterResponse> = .getAllCharacters(forPage: page)
        URLSession.shared.decode(request) { result in
            switch result {
            case .success(let response): self.handleSuccessResult(with: response)
            case .failure(let error): self.handleFailureResult(with: error)
            }
        }
    }
    
    private func handleSuccessResult(with response: RMCharacterResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.characters = response.results
            self.output?.updateView()
        }
    }
    
    private func handleFailureResult(with error: APIError) {
        print("Error:", error.description)
        // MARK: Show Alert OR Empty State view.
    }
}
