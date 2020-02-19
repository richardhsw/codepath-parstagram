//
//  CameraViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/17.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import AlamofireImage
import MBProgressHUD
import Parse
import UIKit


class CameraViewController: UIViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variables
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    let picker = UIImagePickerController()
    
    
    // MARK: - Init Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionField.delegate = self
        
        picker.delegate = self
        picker.allowsEditing = true
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
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
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
                    self.displayShareError(error: error!)
                }
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        else {
            displayError()
        }
    }
    
    @IBAction func onCameraCapture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentPickerOptions()
            
            // TODO: implement custom camera
            // performSegue(withIdentifier: Segues.camera.rawValue, sender: nil)
        }
        else {
            openGallery()
        }
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
    
    // Below code obtained from https://stackoverflow.com/questions/41717115/how-to-make-uiimagepickercontroller-for-camera-and-photo-library-at-the-same-tim
    func presentPickerOptions() {
        let alert = UIAlertController(title: ImagePickerStrings.title.rawValue, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: ImagePickerStrings.camera.rawValue, style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: ImagePickerStrings.library.rawValue, style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: ImagePickerStrings.cancel.rawValue, style: .cancel, handler: nil))

        /* TODO: If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash on iPad
         
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        */

        present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        picker.sourceType = .camera
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func openGallery() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
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
    
    // Share error alert controller
    func displayShareError(error: Error) {
        let message = Errors.shareMessage.rawValue + "\(error.localizedDescription)"
        let alertController = UIAlertController(title: Errors.shareTitle.rawValue, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}
