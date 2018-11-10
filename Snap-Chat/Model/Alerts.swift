//
//  Alerts.swift
//  Snap-Chat
//
//  Created by K.K. on 9.11.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import Foundation
import UIKit

struct Show {
    
    // usage:  present(Show.Alert(with : "alert message"), animated: true, completion: nil)
    static func Alert(with alert:String) -> UIAlertController {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        
        return(alertVC)
    }
}
