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
    @IBOutlet weak var goInButton: uiButton!
    
    var signupMode: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        logInLabel.layer.borderColor = UIColor.brown.cgColor
        signUpLabel.layer.borderColor = UIColor.brown.cgColor
        logInLabel.layer.borderWidth = 0.0
        logInLabel.layer.cornerRadius = 10
        signUpLabel.layer.borderWidth = 2.0
        signUpLabel.layer.cornerRadius = 10
        
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
                            self.present(Show.Alert(with: err1.localizedDescription), animated: true, completion: nil)
                        } else {
                            if let usr = user {
                                // add newly sign up user to snap recepients database
                                Database.database().reference().child("users").child(usr.user.uid).child("email").setValue(usr.user.email, withCompletionBlock: { (error, dbRef) in
                                    if let err2 = error {
                                        self.present(Show.Alert(with: err2.localizedDescription), animated: true, completion: nil)
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
                        if let err = error {
                            self.present(Show.Alert(with: err.localizedDescription), animated: true, completion: nil)
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
    
    // text fields keybord management
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



