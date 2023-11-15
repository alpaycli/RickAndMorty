//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 15.11.23.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    static let reuseId = "CharacterCell"
    private let avatarImage = GFAvatarImageView(frame: .zero)
    private let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 16)
    private let secondTitleLabel = GFSecondaryTitleLabel(fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.systemRed.cgColor
        configureImageAndTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(character: RMCharacter) {
        titleLabel.text = character.name
        if let imageURL = character.image {
            avatarImage.downloadImage(fromURL: imageURL)
        }
        secondTitleLabel.text = character.status
    }
    
    private func configureImageAndTitle() {
        addSubviews(avatarImage, titleLabel, secondTitleLabel)
                
        let padding: CGFloat = 5
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: avatarImage.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            secondTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            secondTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            secondTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            secondTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
