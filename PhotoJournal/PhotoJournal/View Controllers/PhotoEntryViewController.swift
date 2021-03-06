//
//  PhotoEntryViewController.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit
import AVFoundation

enum Edit {
    case editing
    case saving
}

protocol imageAppended: AnyObject {
    func newDataAdded(_ viewController: PhotoEntryViewController, _ createdItem: ImageItem)
    func updateData(_ oldItem: ImageItem, _ newItem: ImageItem)
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
    
    public var state = Edit.editing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        textView.delegate = self
        saveButton.isEnabled = false
        updateUI()
    }
    
    private func updateUI() {
        
        guard let imageInfo = imageData else {
            return
        }
        
        if state == .saving{
            imageView.image = UIImage(data: imageInfo.imageData)
            
            textView.text = imageInfo.description
            saveAction()
        } else if state == .editing {
            
            imageView.image = UIImage(data: <#T##Data#>)
            
        }
        
    }
    
    private func noCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            camButton.isEnabled = false
        }
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    public func saveAction() {
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: imageView.image!.size, insideRect:CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = imageView.image?.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let resizedImageData = resizedImage?.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let createdItem = ImageItem(imageData: resizedImageData, date: Date(), description: textView.text)
        
        delegate?.newDataAdded(self, createdItem)
        dismiss(animated: true)
    }
    
    
    public func update(_ oldItem: ImageItem, _ newItem: ImageItem) {
        delegate?.updateData(oldItem, newItem)
    }
    
    @IBAction func saveActionButtonPressed(_ sender: UIBarButtonItem) {
        updateUI()
        saveAction()
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
        if textView.text == "Description"{
            textView.text = ""
        }
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
