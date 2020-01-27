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
    
    private let imagePickerController = UIImagePickerController()
    
    public var imageData: ImageItem?
    
    private var dataPersistence = PersistenceHelper(filename: "images.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
    }
    
    private func noCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            camButton.isEnabled = false
        }
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveActionButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 1.0) else {
            return
        }
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: imageView.image!.size, insideRect:CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = imageView.image?.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let resizedImageData = resizedImage?.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let selectedItem = ImageItem(imageData: imageData, date: Date(), description: textView.text)
        
        /*
             
             let imageInfo = ImageItem(imageData: resizedImageData, date: Date())
             
             imageData.insert(imageInfo, at: 0)
             let indexPath = IndexPath(row: 0, section: 0)
             collectionView.insertItems(at: [indexPath])
             
             do{
                 try dataPersistence.create(item: imageInfo)
             } catch {
                 print("could not save image")
             }
         }
         */
        
        
    }
    
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
}

extension PhotoEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("image selection not found")
            return
        }
        imageView.image = image
        dismiss(animated: true)
    }
}
