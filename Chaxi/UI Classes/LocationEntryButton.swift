//
//  LocationEntryButton.swift
//  Chaxi
//
//  Created by Suyash Shetty on 2/4/18.
//  Copyright © 2018 Suyash Shetty. All rights reserved.
//

import UIKit

class LocationEntryButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.backgroundColor = UIColor.white;
        self.layer.cornerRadius = 10.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.setTitleColor(UIColor.black, for: .normal);
    }
    
}
