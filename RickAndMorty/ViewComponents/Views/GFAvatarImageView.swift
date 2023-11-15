//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 08.08.23.
//

import SDWebImage
import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholderImage = UIImage(named: "person")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
        
    func downloadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else { return }
        sd_setImage(with: url, placeholderImage:placeholderImage)
    }
    
}
