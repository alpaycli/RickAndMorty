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
        
    var isSearching = false
    
    var hasMoreCharacters = true
    var isLoadingCharacters = false
    
    var filteredCharacters: [RMCharacter] = []
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
    
    func getFilteredCharacters(query: String) {
        let request: Request<RMCharacterResponse> = .getFilteredCharacters(query: query)
        isLoadingCharacters = true
        URLSession.shared.decode(request) { result in
            switch result {
            case .success(let response): DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.filteredCharacters = response.results
                    output?.updateView(with: filteredCharacters)
                }
            case .failure(let error): self.handleFailureResult(with: error)
            }
            self.isLoadingCharacters = false
        }
    }
    
    func handleSearchResult(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            isSearching = false
            output?.updateView(with: characters)
            filteredCharacters.removeAll()
            return
        }
        isSearching = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getFilteredCharacters(query: searchText)
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
        filteredCharacters.removeAll()
        output?.updateView(with: filteredCharacters)
        // MARK: Show Empty State View.
    }
}
