//
//  ViewController.swift
//  PinEntryView
//
//  Created by Jeff Burt on 04/26/2017.
//  Copyright (c) 2017 StockX. All rights reserved.
//

import UIKit
import PinEntryView

class ViewController: UIViewController {
    @IBOutlet weak var pinEntryView: PinEntryView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Can also update the pin at anytime in code
//        pinEntryView.state = PinEntryView.State(pin: "Great", allowsBackspace: false)
    }
}

