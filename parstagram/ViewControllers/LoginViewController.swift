//
//  LoginViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/15.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK: - Init Function
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        passwordField.delegate = self
        
        customizeButton()
    }
    
    
    // MARK: - UI Customization Functions
    func customizeButton() {
        loginButton.layer.cornerRadius = 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            onLogin(self)
        }
        
        return true
    }
    
    
    // MARK: - Helper Functions
    /*------ Handle text field inputs  ------*/
    func usernameAndPasswordNotEmpty() -> Bool {
        // Check text field inputs
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty {
            displayError()
            return false
        } else {
            return true
        }
    }
    
    
    // MARK: - Alert Controlers
    // Text fields are empty alert controller
    func displayError() {
        let alertController = UIAlertController(title: Errors.generalTitle.rawValue, message: Errors.emptyUPMessage.rawValue, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    // Login error alert controller
    func displayLoginError(error: Error) {
        let message = Errors.loginMessage.rawValue + "\(error.localizedDescription)"
        let alertController = UIAlertController(title: Errors.loginTitle.rawValue, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    // Sign up error alert controller
    func displaySignupError(error: Error) {
        let message = Errors.signupMessage.rawValue + "\(error.localizedDescription)"
        let alertController = UIAlertController(title: Errors.signupTitle.rawValue, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    
    // MARK: - Action Functions
    @IBAction func onLogin(_ sender: Any) {
        if usernameAndPasswordNotEmpty() {
            login(with: usernameField.text!, and: passwordField.text!)
        }
    }

    @IBAction func onSignup(_ sender: Any) {
        if usernameAndPasswordNotEmpty() {
            let user = PFUser()
            user.username = usernameField.text
            user.password = passwordField.text
            
            user.signUpInBackground { (success, error) in
                if success {
                    self.login(with: user.username!, and: user.password!)
                }
                else {
                    self.displaySignupError(error: error!)
                }
            }
        }
    }
    
    @IBAction func onTap(_ sender: Any) {
        usernameField.endEditing(true)
        passwordField.endEditing(true)
    }
    
    // MARK: - Helper Functions
    func login(with username: String, and password: String) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: Segues.login.rawValue, sender: nil)
            }
            else {
                self.displayLoginError(error: error!)
            }
        }
    }
}
