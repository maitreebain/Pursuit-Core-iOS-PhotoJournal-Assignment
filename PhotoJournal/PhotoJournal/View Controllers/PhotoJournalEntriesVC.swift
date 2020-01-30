//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit

class PhotoJournalEntriesVC: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataPersistence = PersistenceHelper(filename: "images.plist")
    
    public var imageData = [ImageItem]() {
        didSet {
            collectionView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photoEntryVC = segue.destination as? PhotoEntryViewController else {
            fatalError("cannot segue")
        }
        photoEntryVC.delegate = self
        
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
      let interItemSpacing: CGFloat = 2
      let maxWidth = UIScreen.main.bounds.size.width
      let numberOfItems: CGFloat = 1
      let totalSpacing: CGFloat = numberOfItems * interItemSpacing
      let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
      
      return CGSize(width: itemWidth, height: itemWidth)
  }

}

extension PhotoJournalEntriesVC: CollectionViewCellDelegate {
    
    func showAlert(_ imageCell: CollectionViewCell){
        
        guard let indexPath = collectionView.indexPath(for: imageCell) else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] (alertAction) in
                    
                    guard let photoEditVC = self?.storyboard?.instantiateViewController(identifier: "PhotoEntryViewController") as? PhotoEntryViewController else {
                        fatalError("did not instantiate view controller")
                    }
                    let selectedCell = self?.imageData[indexPath.row]
                    
                    photoEditVC.imageData = selectedCell
                    
                    photoEditVC.state = .editing
                    print("\(photoEditVC.state)")
                    self?.present(photoEditVC, animated: true)
                }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
            self?.deleteImage(indexPath: indexPath)
        }
//        let sharedAction = UIAlertAction(title: "Shared", style: .default) { [weak self] (alertAction) in
//
//        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        alertController.addAction(editAction)
        
        present(alertController, animated: true)
    }
    
    private func deleteImage(indexPath: IndexPath) {
        do {
            
            try dataPersistence.delete(event: indexPath.row)
            
            imageData.remove(at: indexPath.row)
            
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

extension PhotoJournalEntriesVC: imageAppended{
    func updateData(_ oldItem: ImageItem, _ newItem: ImageItem) {
        <#code#>
    }
    
    func newDataAdded(_ viewController: PhotoEntryViewController, _ createdItem: ImageItem) {
        imageData.append(createdItem)
        
        do {
            try dataPersistence.create(item: createdItem)
        } catch {
            print("could not save info")
        }
    }
    
    
}
