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
    
    private var collectionView: UICollectionView!
    
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
        configureCollectionView()
        viewModel.getAllCharacters(page: page)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)

        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
     
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: CollectionView Data Source methods
extension CharactersVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseId, for: indexPath) as! CharacterCell
        let character = viewModel.characters[indexPath.row]
        cell.set(character: character)
        
        return cell
    }
}

extension CharactersVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.item]
        let destinationVC = CharacterDetailVC(character: character)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension CharactersVC: CharacterViewModelOutput {
    func updateView() {
        DispatchQueue.main.async { self.collectionView.reloadData() }
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
