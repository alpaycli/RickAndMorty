//
//  EpisodeDetailVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 21.11.23.
//

import UIKit

final class EpisodeDetailVC: UIViewController {
    
    private let infoViewOne = UIView()
    private let infoViewTwo = UIView()
    
    private let CWTitleLabel = GFTitleLabel(textAlignment: .left, fontSize: 24)
    
    private var charactersCollectionView: UICollectionView!
    
    private var characters: [RMCharacter] = []
    
    private let episode: RMEpisode
    init(episode: RMEpisode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureUIElements()
        configureCharactersCollectionView()
        getCharacters()
        layoutUI()
    }
    
    private func layoutUI() {
        view.addSubviews(CWTitleLabel, infoViewOne, infoViewTwo, charactersCollectionView)
        
        let infoViews = [infoViewOne, infoViewTwo]
        infoViews.forEach { infoView in
            infoView.translatesAutoresizingMaskIntoConstraints = false
            
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            infoView.heightAnchor.constraint(equalToConstant: 40 ).isActive = true
        }
        
        
        charactersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoViewOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoViewTwo.topAnchor.constraint(equalTo: infoViewOne.bottomAnchor, constant: 5),
            
            CWTitleLabel.topAnchor.constraint(equalTo: infoViewTwo.bottomAnchor, constant: 20),
            CWTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            CWTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            CWTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            charactersCollectionView.topAnchor.constraint(equalTo: CWTitleLabel.bottomAnchor),
            charactersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            charactersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            charactersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func getCharacters() {
        guard let characters = episode.characters else { return }
        characters.forEach { url in
            
            let request: Request<RMCharacter> = .getSingleCharacter(for: url)
            
            URLSession.shared.decode(request) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let character):
                    DispatchQueue.main.async {
                        self.characters.append(character)
                        self.charactersCollectionView.reloadData()
                    }
                case .failure(_): break
                }
            }
            
        }
    }
    
    private func configureCharactersCollectionView() {
        charactersCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        charactersCollectionView.dataSource = self
        charactersCollectionView.delegate = self
        charactersCollectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseId)
    }
    
    private func configureUIElements() {
        let episodeInfoVC = RMInfoView()
        let dateInfoVC = RMInfoView()
        
        episodeInfoVC.set(itemType: .episode, withValue: episode.episode ?? "")
        dateInfoVC.set(itemType: .airDate, withValue: episode.airDate ?? "")
        
        self.add(childVC: episodeInfoVC, to: self.infoViewOne)
        self.add(childVC: dateInfoVC, to: self.infoViewTwo)
        CWTitleLabel.text = "Starring Characters"
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension EpisodeDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseId, for: indexPath) as! CharacterCell
        let character = characters[indexPath.item]
        cell.set(character: character)
        
        return cell
    }
}

extension EpisodeDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.item]
        let destinationVC = CharacterDetailVC(character: character)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
