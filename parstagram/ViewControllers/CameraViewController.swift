//
//  CameraViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/17.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import UIKit
import AlamofireImage

class CameraViewController: UIViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variables
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    
    // MARK: - Init Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionField.delegate = self
    }
    
    
    // MARK: UI Customization Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == captionField {
            view.endEditing(true)
        }
        
        return true
    }
    
    
    // MARK: - Action Functions
    @IBAction func onShare(_ sender: Any) {
    }
    
    @IBAction func onCameraCapture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - Image Picker Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        // Resize image
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        photoImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
}
