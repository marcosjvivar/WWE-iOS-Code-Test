//
//  LoginViewController.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/31/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "WWEMobile"
    static let accessGroup: String? = nil
}

class LoginViewController: UIViewController {
    
    let validCredentials = ["username":"wwe","password":"wwe"]
    
    @IBOutlet weak var wweLogoImageView: UIImageView!
    
    @IBOutlet weak var wweMobileLabel: UILabel!
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            usernameTextfield.text = storedUsername
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        
        guard
            let newAccountName = usernameTextfield.text,
            let newPassword = passwordTextfield.text,
            !newAccountName.isEmpty &&
                !newPassword.isEmpty else {
                    
                    let alertView = UIAlertController(title: "Login Problem",
                                                      message: "Wrong username or password.",
                                                      preferredStyle:. alert)
                    let okAction = UIAlertAction(title: "Try again!", style: .default, handler: nil)
                    alertView.addAction(okAction)
                    present(alertView, animated: true, completion: nil)
                    return
        }
        
        usernameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        
        if checkLogin(username: usernameTextfield.text!, password: passwordTextfield.text!) {
            WWESessionManager.sharedInstance.setValidSession()
            dismissLogin()
        } else {
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong username or password.",
                                              preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again!", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true, completion: nil)
        }
    }
    
    func checkLogin(username: String, password: String) -> Bool {
        
        return WWESessionManager.sharedInstance.validateCredentials(username: username, password: password)
    }
    
    func dismissLogin() {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}
