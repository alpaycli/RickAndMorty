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
    
    private var isSearching = false

    private var page: Int = 1
    private var hasMoreCharacters = true
    private var isLoadingCharacters = false
    
    private var filteredCharacters: [RMCharacter] = []
    private var characters: [RMCharacter] = []
    
    weak var output: CharacterViewModelOutput?
    
    func getAllCharacters() {
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
    
    func handleScrollViewForPagination(_ scrollView: UIScrollView) {
        let scrollY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if scrollY > contentHeight - screenHeight {
            guard hasMoreCharacters, !isLoadingCharacters else { return }
            page += 1
            getAllCharacters()
        }
    }
    
    func segue(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, navController: UINavigationController?) {
        let characters = isSearching ? filteredCharacters : characters
        let character = characters[indexPath.item]
        let destinationVC = CharacterDetailVC(character: character)
        
        navController?.pushViewController(destinationVC, animated: true)
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
