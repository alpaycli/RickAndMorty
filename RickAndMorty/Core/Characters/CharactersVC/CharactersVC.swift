//
//  CharactersVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//
//

// TODO: Pagination, Detail View delegation

import UIKit

final class CharactersVC: UIViewController {
    
    private enum Section {
        case main
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, RMCharacter>?
    
    private var page: Int = 1
        
    private let viewModel: CharactersViewModel
    
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureSearchBar()
        configureCollectionView()
        configureDataSource()
        viewModel.getAllCharacters(page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)

        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseId)
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, RMCharacter>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, character) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseId, for: indexPath) as! CharacterCell
            cell.set(character: character)
            return cell
        })
    }
    
    private func updateData(_ data: [RMCharacter]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RMCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        guard let dataSource else { return }
        DispatchQueue.main.async {
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a character"
        navigationItem.searchController = searchController
    }
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: CollectionView Delegate methods
extension CharactersVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if scrollY > contentHeight - screenHeight {
            guard viewModel.hasMoreCharacters, !viewModel.isLoadingCharacters else { return }
            page += 1
            viewModel.getAllCharacters(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characters = viewModel.isSearching ? viewModel.filteredCharacters : viewModel.characters
        let character = characters[indexPath.item]
        let destinationVC = CharacterDetailVC(character: character)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: Searchable
extension CharactersVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.handleSearchResult(for: searchController)
    }
}


extension CharactersVC: CharacterViewModelOutput {
    func updateView(with characters: [RMCharacter]) {
        updateData(characters)
    }
}

/*
 
 //    var characters: [RMCharacter] = []
     
 //    func getAllCharacters(page: Int) {
 //        guard let url = URL(string: NetworkManager.shared.baseURL + "character/?page=\(page)") else { return }
 //
 //        let request = URLRequest(url: url)
 //
 //        NetworkManager.shared.fetch(RMCharacterResponse.self, urlRequest: request) { result in
 //
 //            switch result {
 //            case .success(let response):
 //                print(response.results.count)
 //                DispatchQueue.main.async { [weak self] in
 //                    guard let self else { return }
 //                    self.characters = response.results
 //                    collectionView.reloadData()
 //                }
 //            case .failure(let error):
 //                print("Error:", error)
 //            }
 //
 //        }
 //
 //    }

 
 */
