//
//  imageModel.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import Foundation

struct ImageItem: Codable {
    let imageData: Data
    let date: Date
    let identifier = UUID().uuidString
    let description: String?
}
