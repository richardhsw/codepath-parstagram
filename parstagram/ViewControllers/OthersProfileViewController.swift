//
//  OthersProfileViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/24.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import Parse
import UIKit

class OthersProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    
    var user : PFUser!

    
    // MARK: - Init Function
    override func viewDidLoad() {
        super.viewDidLoad()

        print(user)
    }
    
    /*
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
 */
}
