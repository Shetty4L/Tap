//
//  Utils.swift
//  Tap
//
//  Created by Suyash Shetty on 2/3/18.
//  Copyright © 2018 Suyash Shetty. All rights reserved.
//

import UIKit
import Foundation

let API_KEY = "AIzaSyBpt-1ec9AyKiDlVdm7q2oY1zPF0OvjSZw";

func hideKeyboards(ViewController: UIViewController) {
    for textField in ViewController.view.subviews where textField is UITextField {
        textField.resignFirstResponder();
    }
}

/*
hideKeyboards(ViewController: self);

NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil);
NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil);

 @objc func hideKeyboard() {
 view.endEditing(true)
 }
 
 @objc func keyBoardWillShow(notification: NSNotification) {
 //handle appearing of keyboard here
 let newview = UIView(frame: CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.width, height: self.view.bounds.height/3));
 
 newview.tag = 1;
 newview.backgroundColor = UIColor.clear;
 
 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
 newview.addGestureRecognizer(tapGesture);
 self.view.addSubview(newview);
 }
 
 
 @objc func keyBoardWillHide(notification: NSNotification) {
 //handle dismiss of keyboard here
 let newview = self.view.viewWithTag(1);
 newview?.removeFromSuperview();
 }
 */
