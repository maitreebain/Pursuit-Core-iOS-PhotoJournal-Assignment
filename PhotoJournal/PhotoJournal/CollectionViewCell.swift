//
//  CollectionViewCell.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoItem: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
        backgroundColor = .orange
        
    }
    
    public func configureCell(_ image: ImageData) {
        
        guard let image = UIImage(data: image.imageData) else {
            return
        }
        photoItem.image = image
    }
    
}
