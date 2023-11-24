//
//  Constants.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 11.08.23.
//

import UIKit

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}
