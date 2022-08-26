//
//  Localize + Extensions.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation
//MARK: - To Localize Strings With "".LocalizedString
extension String {
    var localizedString: String {
        return LocalizationSystem.shared.localizedStringForKey(key: self, comment: "")
    }
}
