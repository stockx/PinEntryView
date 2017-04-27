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
    
    // These are PinEntryView settings that can be configured
    @IBOutlet fileprivate weak var pinTextField: UITextField!
    @IBOutlet fileprivate weak var allowsBackspaceSwitch: UISwitch!
    @IBOutlet fileprivate weak var showsPlaceholderSwitch: UISwitch!
    @IBOutlet fileprivate weak var allowsAllCharactersSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate to get notified when the user finishes filling in
        // every box with text.
        pinEntryView.delegate = self
        
        // This state gets built from the defaults set in Interface Builder.
        // If PinEntryView is created in code, you will want to create a new
        // state using PinEntryView.State(...) and then set 
        // pinEntryView.state = state
        let state = pinEntryView.state
        pinTextField.text = state?.pin?.uppercased()
        allowsBackspaceSwitch.isOn = state?.allowsBackspace == true
        showsPlaceholderSwitch.isOn = state?.showsPlaceholder == true
        allowsAllCharactersSwitch.isOn = state?.allowsAllCharacters == true
    }
    
    @IBAction func didTapSwitch(_ sender: UISwitch) {
        // By creating a var, we group up the changes that way the internal 
        // PinEntryView.update() method gets called just one time. Alternatively,
        // you can set the vars directly on pinEntryView.state, causing the
        // internal PinEntryView.update() to get called each time.
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

// This extension is just for the Settings text field where you can adjust what
// the accepted PIN is.
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
