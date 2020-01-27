//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoJournalEntriesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataPersistence = PersistenceHelper(filename: "images.plist")
    
    public var imageData = [ImageData]()
    
    private var selectedImage: UIImage? {
        didSet{
            appendToImages()
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
    
    
}

extension PhotoJournalEntriesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? CollectionViewCell else {
            fatalError("cannot downcast to CollectionViewCell")
        }
        let selectedImage = imageData[indexPath.row]
        
        cell.configureCell(selectedImage)
        //        cell.delegate = self
        
        return cell
    }
    
    
}

extension PhotoJournalEntriesVC: UICollectionViewDelegateFlowLayout {
    
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
