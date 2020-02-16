//
//  LoginViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/15.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK: - Init Function
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeButton()
    }
    
    
    // MARK: - Helper Functions
    func customizeButton() {
        loginButton.layer.cornerRadius = 5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
