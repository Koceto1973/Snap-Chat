//
//  SelectRecipientTableVC.swift
//  Snap-Chat
//
//  Created by K.K. on 9.11.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class localUser {
    var email = ""
    var uid = ""
}

class SelectRecipientTableVC: UITableViewController {
    
    var snapDescription = ""
    var downloadURL = ""
    var imageName = ""
    var users : [localUser] = []
    
    // snaps recepients db buildup
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("Snap prepared for recepient: \(snapDescription), \(downloadURL)")
        // adding records to snaps recepients db via listener, current user omitted
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            let user = localUser()
            if let userDictionary = snapshot.value as? NSDictionary {
                if let email = userDictionary["email"] as? String {
                    user.email = email
                    user.uid = snapshot.key
                    // add all,except current user
                    if let currentUserEmail = Auth.auth().currentUser?.email {
                        if currentUserEmail != user.email {
                            self.users.append(user)
                            self.tableView.reloadData()
                        }
                    }
                    debugPrint(user.email)
                }
            }
        }
    }
    
    
    // Table view number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    // Table view prototype cell buil up
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }
    // Table view row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let fromEmail = Auth.auth().currentUser?.email {
            // snap created
            let snap = ["from":fromEmail,"description":snapDescription,"imageURL":downloadURL,"imageName":imageName]
            // snap uploaded to db
            Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap) { (error, dbRef) in
                if let err = error {
                    self.present(Show.Alert(with: err.localizedDescription), animated: true, completion: nil)
                } else {
                    // snap uploaded
                    debugPrint("Snap upload to db - success!")
                }
            }
            
            navigationController?.popToRootViewController(animated: true)
        }
    }    
}


