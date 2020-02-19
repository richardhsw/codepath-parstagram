//
//  ProfileViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/18.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import Alamofire
import AlamofireImage
import Parse
import MBProgressHUD
import UIKit


class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - Variables
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editProfileButton: UIButton!
    
    let numPosts = 15
    let minSpacing = CGFloat(2)
    var posts = [PFObject]()
    
    
    // MARK: - Init Function
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeCollectionView()
        customizeProfileButton()
        customizeProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPosts()
        fillProfileInfo()
    }
    
    
    // MARK: - UI Customization Functions
    func customizeCollectionView() {
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        // ----- Configure layout -----
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let numOfImagesPerRow          = CGFloat(3)
        layout.minimumLineSpacing      = minSpacing
        layout.minimumInteritemSpacing = minSpacing
        
        let width  = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / numOfImagesPerRow
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    func customizeProfileImage() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    func customizeProfileButton() {
        editProfileButton.layer.cornerRadius = 5
    }
    
    func fillProfileInfo() {
        let user = PFUser.current()!
        
        // Set username
        usernameLabel.text = user.username
        
        // Change posts count
        postsCountLabel.text = String(posts.count)
        
        // Set profile picture
        DataRequest.addAcceptableImageContentTypes(["image/jpeg", "image/jpg", "image/png", "application/octet-stream"])
        let imageFire = user[UsersDB.profileImage.rawValue] as? PFFileObject
        
        if imageFire != nil {
            let urlString = imageFire!.url!
            let url       = URL(string: urlString)!
            profileImageView.af_setImage(withURL: url)
        }
    }
    
    
    // MARK: - Collection View Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.profileCollection.rawValue, for: indexPath) as! PostCollectionViewCell
        
        let post = posts[indexPath.item]
        
        DataRequest.addAcceptableImageContentTypes(["image/jpeg", "image/jpg", "image/png", "application/octet-stream"])
        let imageFire = post[PostsDB.image.rawValue] as! PFFileObject
        let urlString = imageFire.url!
        let url       = URL(string: urlString)!
        cell.imageView.af_setImage(withURL: url)
        
        return cell
    }
    
    
    // MARK: - Action Functions
    @IBAction func onEditProfile(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - Image Picker Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        // Resize image
        let size        = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        let imageData   = scaledImage.pngData()
        let file        = PFFileObject(data: imageData!)
        
        // Upload image to Parse
        let user = PFUser.current()!
        user[UsersDB.profileImage.rawValue] = file
        user.saveInBackground { (success, error) in
            if success {
                self.profileImageView.image = scaledImage
            }
            else {
                print("Error changing profile picture")
                self.displayProfileError(error: error!)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Functions
    func getPosts() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let query = PFQuery(className: PostsDB.name.rawValue)
        query.addDescendingOrder(PostsDB.createdAt.rawValue)
        query.whereKey(PostsDB.author.rawValue, equalTo: PFUser.current()!)
        query.limit = numPosts
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.collectionView.reloadData()
            }
            else {
                print("Error while retreiving posts")
                self.displayShareError(error: error!)
            }
        }

        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    // MARK: - Error Functions
    func displayShareError(error: Error) {
        let message = Errors.queryMessage.rawValue + "\(error.localizedDescription)"
        let alertController = UIAlertController(title: Errors.queryMessage.rawValue, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    // Login error alert controller
    func displayProfileError(error: Error) {
        let message = Errors.profileMessage.rawValue + "\(error.localizedDescription)"
        let alertController = UIAlertController(title: Errors.profileTitle.rawValue, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}
