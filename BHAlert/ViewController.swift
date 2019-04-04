//
//  ViewController.swift
//  MBAlert
//
//  Created by Bilal Ashraf on 4/4/19.
//  Copyright © 2019 Selteq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showAlert(_ sender: Any) {
        BHAlert.showAlert(type: .error, position: .top, title: "Error",subtitle: "There was some error. Please try again later. This could happen for many reasons. 1st check your internet connection. Otherwise you have no choice just to try again");
    }
    
}

