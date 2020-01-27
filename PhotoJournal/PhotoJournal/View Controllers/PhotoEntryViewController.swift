//
//  PhotoEntryViewController.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit
import AVFoundation

protocol imageAppended: AnyObject {
    func newDataAdded(_ viewController: PhotoEntryViewController, _ image: UIImage, _ description: String)
}

class PhotoEntryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var imageLibraryButton: UIBarButtonItem!
    @IBOutlet weak var camButton: UIBarButtonItem!
    
    weak var delegate: imageAppended?
    
    private let imagePickerController = UIImagePickerController()
    
    public var imageData: ImageItem?
    
    public var imageItemArr = [ImageItem]()
    
    private var dataPersistence = PersistenceHelper(filename: "images.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        textView.delegate = self
        saveButton.isEnabled = false
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

        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: imageView.image!.size, insideRect:CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = imageView.image?.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let resizedImageData = resizedImage?.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let selectedItem = ImageItem(imageData: resizedImageData, date: Date(), description: textView.text)
        
        imageItemArr.insert(selectedItem, at: 0)
        do {
            try dataPersistence.create(item: selectedItem)
        } catch {
            print("could not save info")
        }
        
        delegate?.newDataAdded(self, resizedImage!, textView.text)
        dismiss(animated: true)
    }
    
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
        saveButton.isEnabled = true
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
        saveButton.isEnabled = true
    }
    
}

extension PhotoEntryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
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
