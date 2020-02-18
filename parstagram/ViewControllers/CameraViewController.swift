//
//  CameraViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/17.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import AlamofireImage
import Parse
import UIKit


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
        // TODO: check imageView is empty
        if (!captionField.text!.isEmpty) {
            let post = PFObject(className: PostsDB.name.rawValue)
            
            post[PostsDB.author.rawValue]  = PFUser.current()!
            post[PostsDB.caption.rawValue] = captionField.text
            
            // save image
            let imageData = photoImageView.image!.pngData()
            let file      = PFFileObject(data: imageData!)
            post[PostsDB.image.rawValue] = file
            
            post.saveInBackground { (success, error) in
                if success {
                    print("Post successfully shared!")
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    print("Error sharing post")
                }
            }
        }
        else {
            displayError()
        }
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
    
    
    // MARK: - Error Functions
    // Text fields are empty alert controller
    func displayError() {
        let alertController = UIAlertController(title: Errors.generalTitle.rawValue, message: Errors.emptyCaptionMessage.rawValue, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    // Login error alert controller
    func displayLoginError(error: Error) {
        let message = Errors.shareMessage.rawValue + "\(error.localizedDescription)"
        let alertController = UIAlertController(title: Errors.shareTitle.rawValue, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}
