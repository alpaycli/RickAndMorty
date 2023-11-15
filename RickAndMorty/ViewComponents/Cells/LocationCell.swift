//
//  LocationCell.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 15.11.23.
//

import UIKit

class LocationCell: UITableViewCell {

    static let reuseId = "LocationCell"
    
    private let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
    private let secondaryTitleLabel = GFSecondaryTitleLabel(fontSize: 24)
    private let bodyLabel = GFBodyLabel(textAlignment: .left)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(location: RMLocation) {
        titleLabel.text = location.name
        secondaryTitleLabel.text = location.type
        if let residents = location.residents {
            bodyLabel.text = "\(residents.count) Residents"
        }
    }
    
    private func configure() {
        addSubviews(titleLabel, secondaryTitleLabel, bodyLabel)
        
        let padding: CGFloat = 10
        
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            secondaryTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            secondaryTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            secondaryTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            secondaryTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bodyLabel.topAnchor.constraint(equalTo: secondaryTitleLabel.bottomAnchor, constant: padding),
            bodyLabel.leadingAnchor.constraint(equalTo: secondaryTitleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: secondaryTitleLabel.trailingAnchor),
            bodyLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

}
