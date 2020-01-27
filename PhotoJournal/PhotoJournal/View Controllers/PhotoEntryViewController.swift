//
//  PhotoEntryViewController.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit

class PhotoEntryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var imageLibraryButton: UIBarButtonItem!
    @IBOutlet weak var camButton: UIBarButtonItem!
    
    private let imagePickerController = UIImagePickerController()
    
    public var imageData: ImageData?
    
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
        
        guard let image = imageData else {
            return
        }
        
        
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
