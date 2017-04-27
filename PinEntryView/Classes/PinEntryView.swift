//
//  PinEntryView.swift
//  PinEntryView
//
//  Created by StockX on 4/26/17.
//  Copyright (c) 2017 StockX. All rights reserved.
//

import UIKit

@IBDesignable public class PinEntryView: UIView {
    public var state: State? {
        didSet {
            update(oldValue: oldValue)
        }
    }
    
    fileprivate lazy var textField: UITextField = self.createTextField()
    fileprivate var buttons = [UIButton]()
    fileprivate var buttonInnerSpacerViews = [UIView]()
    
    // Defaults that can be set inside IB. Use 'state' when setting values in code.
    @objc @IBInspectable fileprivate var pin: String? = "Excellent"
    @objc @IBInspectable fileprivate var allowsBackspace: Bool = false
    @objc @IBInspectable fileprivate var showsHint: Bool = true
    @objc @IBInspectable fileprivate var allowAllCharacters: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
}

//  MARK - State

public extension PinEntryView {
    public struct State {
        public var pin: String?
        public var allowsBackspace: Bool
        public var showsHint: Bool
        public var allowAllCharacters: Bool
        
        public init(pin: String?,
                    allowsBackspace: Bool = true,
                    showsHint: Bool = true,
                    allowAllCharacters: Bool = true) {
            self.pin = pin
            self.allowsBackspace = allowsBackspace
            self.showsHint = showsHint
            self.allowAllCharacters = allowAllCharacters
        }
    }
    
    internal func update(oldValue: State?) {
        if oldValue?.pin != state?.pin {
            textField.text = nil
            createNewButtons()
        }
    }
}

extension PinEntryView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text else {
            return false
        }
        
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string).uppercased()
        
        // Don't allow user to keep typing once all buttons are filled
        guard newText.characters.count <= state?.pin?.characters.count ?? 0 else {
            textField.resignFirstResponder()
            return false
        }
        
        // Disallow backspace if necessary
        guard state?.allowsBackspace == true || newText.characters.count > oldText.characters.count else {
            return false
        }
        
        // Disallow entering non-matching characters if necessary
        guard state?.allowAllCharacters == true || newText == (state?.pin ?? "").uppercased().substring(to: newText.characters.count) else {
            return false
        }
        
        textField.text = newText
        updateButtonStates()
        
        // Dismiss the keyboard when the last letter is typed
        if newText.characters.count == state?.pin?.characters.count ?? 0 {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // Set the focussed state
        updateButtonStates()
    }
}

// MARK - Internal

fileprivate extension PinEntryView {
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.isHidden = true
        textField.autocapitalizationType = .allCharacters
        textField.returnKeyType = .done
        return textField
    }
    
    func createButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(openKeyboard), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        return button
    }
    
    func createSpacerView() -> UIView {
        let view = UIView()
        view.isHidden = true
        return view
    }
    
    func commonInit() {
        if pin != nil || allowsBackspace != nil || showsHint != nil || allowAllCharacters != nil {
            state = State(pin: pin, allowsBackspace: allowsBackspace, showsHint: showsHint, allowAllCharacters: allowAllCharacters)
        }
        
        backgroundColor = .clear
        
        addSubview(textField)
        textField.makeEdgesEqualToSuperview()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openKeyboard)))
    }
    
    func createNewButtons() {
        buttons.forEach {
            $0.removeFromSuperview()
        }
        buttons.removeAll()
        
        state?.pin?.characters.forEach { _ in
            let button = createButton()
            buttons.append(button)
            addSubview(button)
        }
        
        constrainButtons()
        
        textField.text = nil
        updateButtonStates()
    }
    
    func constrainButtons() {
        buttonInnerSpacerViews.forEach {
            $0.removeFromSuperview()
        }
        buttonInnerSpacerViews.removeAll()
        
        for (i, button) in buttons.enumerated() {
            let isFirstButton = i == 0
            let isLastButton = i == buttons.count - 1
            
            if isFirstButton {
                button.makeAttributesEqualToSuperview([.top])
                button.makeAttributesEqualToSuperview([.leading])
                button.makeAttributesEqualToSuperview([.bottom])
                
                // Set the width of the button that way 'self' has intrinsic
                // size.
                button.makeAttribute(.width, equalToOtherView: button, attribute: .height, multiplier: 0.75)
            }
            else {
                let previousButton = buttons[i - 1]
                button.makeAttribute(.top, equalToOtherView: previousButton, attribute: .top)
                button.makeAttribute(.bottom, equalToOtherView: previousButton, attribute: .bottom)
                button.makeAttribute(.width, equalToOtherView: previousButton, attribute: .width)
                
                let spacerView = createSpacerView()
                buttonInnerSpacerViews.append(spacerView)
                addSubview(spacerView)
                
                spacerView.makeAttribute(.leading, equalToOtherView: previousButton, attribute: .trailing)
                spacerView.makeAttribute(.trailing, equalToOtherView: button, attribute: .leading)
            }
            
            // There may be only one button, or many. Make sure we constrain
            // the last one to the trailing edge of 'self'.
            if isLastButton {
                button.makeAttributesEqualToSuperview([.trailing])
            }
        }
        
        // Set equal widths and heights on the spacer views
        buttonInnerSpacerViews.forEach { spacerView in
            let firstSpacerView = buttonInnerSpacerViews.first!
            
            if spacerView == firstSpacerView {
                // Make the spacers at least 1/5 the width of each button that
                // way 'self' has intrinsic size. If 'self' is made wider than 
                // it needs to be, the spacers will grow, spreading apart the 
                // buttons even more.
                spacerView.makeAttribute(.width, greaterThanOrEqualToOtherView: buttons.first!, attribute: .width, multiplier: 0.2)
                
                spacerView.makeAttribute(.height, equalTo: 5)
                spacerView.makeAttributesEqualToSuperview([.centerY])
            }
            else {
                spacerView.makeAttribute(.width, equalToOtherView: firstSpacerView, attribute: .width)
                spacerView.makeAttribute(.height, equalToOtherView: firstSpacerView, attribute: .height)
                spacerView.makeAttribute(.centerY, equalToOtherView: firstSpacerView, attribute: .centerY)
            }
        }
    }
    
    @objc func openKeyboard() {
        textField.becomeFirstResponder()
    }
    
    func updateButtonStates() {
        let showsHint = state?.showsHint == true
        
        for (i, button) in buttons.enumerated() {
            button.layer.borderColor = UIColor.lightGray.cgColor

            if let newCharacter = textField.text?[i],
                newCharacter != "" {
                button.setTitle(newCharacter, for: .normal)
                button.setTitleColor(.black, for: .normal)
            }
            else {
                button.setTitle(showsHint ? state?.pin?.uppercased()[i] : nil, for: .normal)
                button.setTitleColor(.lightGray, for: .normal)
                
                let isFocussed = textField.isFirstResponder && i == textField.text?.characters.count ?? 0
                if isFocussed {
                    button.layer.borderColor = UIColor.black.cgColor
                }
            }
        }
    }
}
