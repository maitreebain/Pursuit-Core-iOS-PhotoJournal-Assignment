//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit

class PhotoJournalEntriesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataPersistence = PersistenceHelper(filename: "images.plist")
    
    private var imageData = [ImageData]() {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadData()
    }

    private func loadData() {
        do {
            imageData = try dataPersistence.loadImage()
        } catch {
            print("image data cannot be loaded")
        }
    }
    
    private func appendToImages() {
        
    }

}

extension PhotoJournalEntriesVC: UICollectionViewDataSource {
    
}


extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
