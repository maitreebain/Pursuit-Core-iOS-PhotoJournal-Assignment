//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit
import AVFoundation


class PhotoJournalEntriesVC: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataPersistence = PersistenceHelper(filename: "images.plist")
    
    public var imageData = [ImageData]()
    
    private var selectedImage: UIImage? {
        didSet {
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
    
    private func appendToImages() {
        
        guard let image = selectedImage else {
            print("image is nil")
            return
        }
        let size = UIScreen.main.bounds.size
        
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        
        print("resized: \(resizeImage.size)")
        
        guard let resizedImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let imageInfo = ImageData(imageData: resizedImageData, date: Date())
        
        imageData.insert(imageInfo, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
        
        do{
            try dataPersistence.create(item: imageInfo)
        } catch {
            print("could not save image")
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
        cell.delegate = self
        
        return cell
    }
    
    
}

extension PhotoJournalEntriesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 1
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 1
        let totalSpace: CGFloat = numberOfItems * itemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpace) / numberOfItems
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

extension PhotoJournalEntriesVC: CollectionViewCellDelegate {
    
    func showAlert(_ imageCell: CollectionViewCell){
        
        guard let indexPath = collectionView.indexPath(for: imageCell) else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self ] (alertAction) in
//
//        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
            self?.deleteImage(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
        
    }
    
    private func deleteImage(indexPath: IndexPath) {
        do {
            try dataPersistence.delete(event: indexPath.row)
            
            imageData.remove(at: indexPath.row)
            
            collectionView.deleteItems(at: [indexPath])
            print("deleted item")
        } catch {
            print("deletion error: \(error)")
        }
    }
    
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