//
//  ViewController.swift
//  Snap-Chat
//
//  Created by K.K. on 8.11.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var goInSwitch: UISwitch!
    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    var signupMode: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        logInLabel.layer.borderColor = UIColor.brown.cgColor
        signUpLabel.layer.borderColor = UIColor.brown.cgColor
        logInLabel.layer.borderWidth = 0.0
        signUpLabel.layer.borderWidth = 2.0
        
        // keyboard return
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // sign up / log in
    @IBAction func goInPressed(_ sender: Any) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                if signupMode { // Sign Up
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let err1 = error {
                            self.presentAlert(alert: err1.localizedDescription)
                        } else {
                            if let usr = user {
                                // add newly sign up user to snap recepients database
                                Database.database().reference().child("users").child(usr.user.uid).child("email").setValue(usr.user.email, withCompletionBlock: { (error, dbRef) in
                                    if let err2 = error {
                                        self.presentAlert(alert: err2.localizedDescription)
                                    } else {
                                        debugPrint("Adding new user to snaps recepients data base successful!")
                                    }
                                })
                            }
                            debugPrint("SignUp success!")
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                    })
                } else { // Log In
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        } else {
                            debugPrint("LogIn success!")
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func goInSwitchClicked(_ sender: Any) {
        if goInSwitch.isOn {
            signupMode = true
            signUpLabel.layer.borderWidth = 2.0
            logInLabel.layer.borderWidth = 0.0
        } else {
            signupMode = false
            signUpLabel.layer.borderWidth = 0.0
            logInLabel.layer.borderWidth = 2.0
        }
    }
    
    // sign up / log in alert messaging
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    // text fields keybord management
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



