//
//  PhotoEntryViewController.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoEntryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var imageLibraryButton: UIBarButtonItem!
    @IBOutlet weak var camButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
