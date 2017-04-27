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
    @IBOutlet fileprivate weak var pinEntryView: PinEntryView!
    @IBOutlet fileprivate weak var pinTextField: UITextField!
    @IBOutlet fileprivate weak var allowsBackspaceSwitch: UISwitch!
    @IBOutlet fileprivate weak var showsPlaceholderSwitch: UISwitch!
    @IBOutlet fileprivate weak var allowsAllCharactersSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinEntryView.delegate = self
        
        let state = pinEntryView.state
        pinTextField.text = state?.pin?.uppercased()
        allowsBackspaceSwitch.isOn = state?.allowsBackspace == true
        showsPlaceholderSwitch.isOn = state?.showsPlaceholder == true
        allowsAllCharactersSwitch.isOn = state?.allowsAllCharacters == true
    }
    
    @IBAction func didTapSwitch(_ sender: UISwitch) {
        var state = pinEntryView.state
        state?.allowsBackspace = allowsBackspaceSwitch.isOn
        state?.showsPlaceholder = showsPlaceholderSwitch.isOn
        state?.allowsAllCharacters = allowsAllCharactersSwitch.isOn
        pinEntryView.state = state
    }
}

extension ViewController: PinEntryViewDelegate {
    func pinEntryView(_ view: PinEntryView, didFinishEditing pin: String) {
        print("User finished editing PIN: \(pin)")
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string).uppercased()
        textField.text = newText
        
        var state = pinEntryView.state
        state?.pin = newText
        pinEntryView.state = state
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
