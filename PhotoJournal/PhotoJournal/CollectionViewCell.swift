//
//  CollectionViewCell.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func showAlert(_ imageCell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    @IBOutlet weak var photoItem: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    public func configureCell(_ imageInfo: ImageItem) {
        
        guard let image = UIImage(data: imageInfo.imageData) else {
            return
        }
        photoItem.image = image
        
        imageLabel.text = imageInfo.description
        dateLabel.text = imageInfo.date.description
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIButton) {

        delegate?.showAlert(self)
    }
    
}
