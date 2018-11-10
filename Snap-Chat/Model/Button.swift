//
//  Button.swift
//  Snap-Chat
//
//  Created by K.K. on 9.11.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import Foundation
import UIKit

class uiButton:UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()  // super func to be called first
        
        layer.backgroundColor = UIColor.brown.cgColor
        self.setTitleColor(UIColor.white, for: .normal)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 10
    }
    
}
