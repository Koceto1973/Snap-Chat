//
//  SelectPictureVC.swift
//  Snap-Chat
//
//  Created by K.K. on 8.11.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"  // unique string name generator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
    }
    
    // images code
    @IBAction func selectPhotoPressed(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    @IBAction func selectCameraPressed(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseRecipientPressed(_ sender: Any) {
        if let message = messageTextField.text {
            if imageAdded && message != "" {  // Upload the image, when both image and text are ready
                
                // storage folder
                let imagesFolder = Storage.storage().reference().child("images")
                // image converted to data
                if let image = imageView.image {
                    if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                        // actual upload
                        imagesFolder.child(imageName).putData(imageData, metadata: nil) { (storageMetadata, error) in
                            if let err1 = error {
                                self.presentAlert(alert: err1.localizedDescription)
                            } else {
                                debugPrint("Image upload success!")
                                // providing the downloadURL to prepare for segue function
                                // check for names duplication ....
                                imagesFolder.child(self.imageName).downloadURL(completion: { (url, error) in
                                    if let err2 = error {
                                        self.presentAlert(alert: err2.localizedDescription)
                                    } else {
                                        self.performSegue(withIdentifier: "selectRecipientSegue", sender: url!.absoluteString)
                                    }
                                })
                            }
                        }
                    }
                }
            } else {
                // We are missing something
                presentAlert(alert: "You must provide an image and a message for your snap.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? SelectRecipientTableVC {
                selectVC.downloadURL = downloadURL
                selectVC.snapDescription = messageTextField.text!
                selectVC.imageName = imageName
            }
        }
    }
    
    // message alerts
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