//
//  Utils.swift
//  Chaxi
//
//  Created by Suyash Shetty on 2/3/18.
//  Copyright © 2018 Suyash Shetty. All rights reserved.
//

import UIKit
import Foundation

func hideKeyboards(ViewController: UIViewController) {
    for textField in ViewController.view.subviews where textField is UITextField {
        textField.resignFirstResponder();
    }
}
