//
//  LocationTextField.swift
//  Chaxi
//
//  Created by Suyash Shetty on 2/2/18.
//  Copyright © 2018 Suyash Shetty. All rights reserved.
//

import UIKit

class LocationTextField: UITextField, UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.borderStyle = UITextBorderStyle.roundedRect;
        self.layer.cornerRadius = 5.0;
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: CGFloat(50.0));
        self.layoutIfNeeded();
    }
    
}
