//
//  ViewSnapVC.swift
//  Snap-Chat
//
//  Created by K.K. on 9.11.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class ViewSnapVC: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageName = ""  // needed for the deletion from the storage
    var snap : DataSnapshot?
    
    // snap presentation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snapDictionary = snap?.value as? NSDictionary {
            if let description = snapDictionary["description"] as? String {
                if let imageURL = snapDictionary["imageURL"] as? String {
                    messageLabel.text = description
                    if let url = URL(string: imageURL) {
                        imageView.sd_setImage(with: url)
                    }
                    // ready for the deletion from the storage
                    if let imageName = snapDictionary["imageName"] as? String {
                        self.imageName = imageName
                    }
                }
            }
        }
    }
    
    // snap removed from db on exiting the view controller
    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserUid = Auth.auth().currentUser?.uid {
            if let key = snap?.key {
                // remove snap from db
                Database.database().reference().child("users").child(currentUserUid).child("snaps").child(key).removeValue { (error, dbRef) in
                    if let err = error {
                        self.present(Show.Alert(with: err.localizedDescription), animated: true, completion: nil)
                    } 
                }
                // remove snap image from storage
                Storage.storage().reference().child("images").child(imageName).delete { (error) in
                    if let err = error {
                        self.present(Show.Alert(with: err.localizedDescription), animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
