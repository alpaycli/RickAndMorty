//
//  CharacterDetailVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 18.11.23.
//

import UIKit

class CharacterDetailVC: UIViewController {
    
    private let imageView = GFAvatarImageView(frame: .zero)
    
    private let labelsStackView = UIStackView()
    
    private let nameLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    private let statusLabel = GFSecondaryTitleLabel(fontSize: 16)
    private let specieLabel = GFSecondaryTitleLabel(fontSize: 16)
    private let genderLabel = GFSecondaryTitleLabel(fontSize: 16)
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureValues()
        configureStackView()
        layoutUI()
    }
    
    private func configureStackView() {
        labelsStackView.axis = .vertical
        labelsStackView.distribution = .fillEqually
        labelsStackView.alignment = .center
        
        let labels = [nameLabel, statusLabel, specieLabel, genderLabel]
        for label in labels {
            labelsStackView.addArrangedSubview(label)
        }
    }
    
    private func layoutUI() {
        view.addSubviews(imageView, labelsStackView)
        
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 240),
            
            labelsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStackView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func configureValues() {
        var status = ""
        switch character.status {
        case "Alive":
            status =  "🟢 Alive"
        case "Dead":
            status = "🔴 Dead"
        default:
            status = "❓ Unknown"
        }
        
        if let url = character.image {
            imageView.downloadImage(fromURL: url)
        }
        nameLabel.text = character.name
        
        statusLabel.text = "Status: " + status
        specieLabel.text = "Specie: " + (character.species ?? "N/A")
        genderLabel.text = "Gender: " + (character.gender ?? "N/A")
    }

    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
