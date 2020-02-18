//
//  CaptureViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/18.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import CameraManager
import UIKit

class CaptureViewController: UIViewController {

    // MARK: - Variables
    let cameraManager = CameraManager()
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: Init Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraManager.addPreviewLayerToView(imageView)
        cameraManager.capturePictureWithCompletion({ result in
            switch result {
                case .failure:
                    print("error")
                case .success(let content):
                    self.imageView.image = content.asImage;
            }
        })
    }
}
