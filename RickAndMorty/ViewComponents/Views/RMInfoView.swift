//
//  RMInfoView.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 21.11.23.
//

import UIKit

enum InfoType {
    case episode, airDate, type, dimension
}

class RMInfoView: UIViewController {
        
    var symbolImage = GFTitleLabel(textAlignment: .left, fontSize: 18)
    var titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 18)
    var valueLabel = GFTitleLabel(textAlignment: .right, fontSize: 18)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.addSubviews(symbolImage, titleLabel, valueLabel)
        
        let padding: CGFloat = 5
        NSLayoutConstraint.activate([
            symbolImage.topAnchor.constraint(equalTo: view.topAnchor),
            symbolImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            symbolImage.widthAnchor.constraint(equalToConstant: 20),
            symbolImage.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImage.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImage.trailingAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            valueLabel.centerYAnchor.constraint(equalTo: symbolImage.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            valueLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func set(itemType: InfoType, withValue value: String) {
        switch itemType {
        case .episode:
            symbolImage.text = "📺"
            titleLabel.text = "Episode"
        case .airDate:
            symbolImage.text = "📅"
            titleLabel.text = "Air Date"
        case .type:
            symbolImage.text = "🪐"
            titleLabel.text = "Type"
        case .dimension:
            symbolImage.text = "✨"
            titleLabel.text = "Dimension"
        }
        valueLabel.text = String(value)
    }
    
}
