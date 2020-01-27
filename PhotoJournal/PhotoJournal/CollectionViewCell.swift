//
//  CollectionViewCell.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit

protocol ImageCellDelegate: AnyObject {
    
    func didLongPress(_ imageCell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ImageCellDelegate?
    
    @IBOutlet weak var photoItem: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer()
        longPress.addTarget(self, action: #selector(longPressAction(gesture:)))
        return longPress
    }()
    
    @objc
    private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        delegate?.didLongPress(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
        backgroundColor = .orange
        
        addGestureRecognizer(longPressGesture)
    }
    
    public func configureCell(_ image: ImageData) {
        
        guard let image = UIImage(data: image.imageData) else {
            return
        }
        photoItem.image = image
    }
    
}
