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
        viewModel.getAllCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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
    }
}

// MARK: CollectionView Delegate methods
extension CharactersVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.handleScrollViewForPagination(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.segue(collectionView, didSelectItemAt: indexPath, navController: navigationController)
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
