//
//  PinEntryView.swift
//  PinEntryView
//
//  Created by StockX on 4/26/17.
//  Copyright (c) 2017 StockX. All rights reserved.
//

import UIKit

public protocol PinEntryViewDelegate: class {
    /** Called when the user fills out every box with text. */
    func pinEntryView(_ view: PinEntryView, didFinishEditing pin: String)
    
    /** Called when the user taps the return key on the keyboard. */
    func pinEntryViewDidTapKeyboardReturnKey(_ view: PinEntryView)
    
    /** Called when the user begins editing the PinEntryView */
    func pinEntryViewDidBeginEditing(_ view: PinEntryView)
    
    /** Called when the user ends editing the PinEntryView */
    func pinEntryViewDidEndEditing(_ view: PinEntryView)
}

@IBDesignable public class PinEntryView: UIView {
    public var state: State? {
        didSet {
            update(oldValue: oldValue)
        }
    }
    
    public weak var delegate: PinEntryViewDelegate?
    
    fileprivate lazy var textField: UITextField = self.createTextField()
    fileprivate var buttons = [PinButton]()
    fileprivate var buttonInnerSpacerViews = [UIView]()
    
    // Defaults that can be set inside IB. Use 'state' when setting values in code.
    @objc @IBInspectable fileprivate var pin: String? = "ACCEPT"
    @objc @IBInspectable fileprivate var allowsBackspace: Bool = false
    @objc @IBInspectable fileprivate var showsPlaceholder: Bool = true
    @objc @IBInspectable fileprivate var placeholderTextColor = UIColor(white: 0.9, alpha: 1)
    @objc @IBInspectable fileprivate var allowsAllCharacters: Bool = false
    @objc @IBInspectable fileprivate var focusBorderColor: UIColor = .black
    @objc @IBInspectable fileprivate var inactiveBorderColor: UIColor = .lightGray
    @objc @IBInspectable fileprivate var completedBorderColor: UIColor = .green
    @objc @IBInspectable fileprivate var errorBorderColor: UIColor = .red
    @objc @IBInspectable fileprivate var buttonBorderStyle: Int = PinButton.BorderStyle.full.rawValue

    public override var canBecomeFirstResponder: Bool {
        return textField.canBecomeFirstResponder
    }

    public override var canResignFirstResponder: Bool {
        return textField.canResignFirstResponder
    }
    
    public override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
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
        textField.text = pin?[0..<2]
        updateButtonStates()
    }
    
    /** 
     Fills out each box with the pin and updates the button states as if the 
     user typed the pin in manually.
     */
    public func fillInPin() {
        textField.text = state?.pin?.uppercased()
        updateButtonStates()
        delegate?.pinEntryView(self, didFinishEditing: textField.text ?? "")
    }
    
    /** 
     Enters into an error state. When editing, colors the currently focussed 
     box state?.errorBorderColor and leaves the empty boxes to the right 
     state?.inactiveBorderColor. When not editing, colors all boxes that are 
     not filled out state?.errorBorderColor. The error state gets cleared as
     soon as editing begins/ends or when typing occurs.
     */
    public func showErrorState() {
        updateButtonStates(overrideFocusBorderColor: state?.errorBorderColor,
                           overrideInactiveBorderColor: isFirstResponder == false ? state?.errorBorderColor : nil)
    }
}

//  MARK - State

public extension PinEntryView {
    struct State {
        public var pin: String?
        public var allowsBackspace: Bool
        public var showsPlaceholder: Bool
        public var placeholderTextColor: UIColor
        public var allowsAllCharacters: Bool
        public var focusBorderColor: UIColor
        public var inactiveBorderColor: UIColor
        public var completedBorderColor: UIColor
        public var errorBorderColor: UIColor
        public var returnKeyType: UIReturnKeyType
        public var buttonBorderStyle: PinButton.BorderStyle
        
        public init(pin: String?,
                    allowsBackspace: Bool = true,
                    showsPlaceholder: Bool = true,
                    placeholderTextColor: UIColor = UIColor(white: 0.9, alpha: 1),
                    allowsAllCharacters: Bool = true,
                    focusBorderColor: UIColor = .black,
                    inactiveBorderColor: UIColor = .lightGray,
                    completedBorderColor: UIColor = .green,
                    errorBorderColor: UIColor = .red,
                    returnKeyType: UIReturnKeyType = .done,
                    buttonBorderStyle: PinButton.BorderStyle = .full) {
            self.pin = pin
            self.allowsBackspace = allowsBackspace
            self.showsPlaceholder = showsPlaceholder
            self.placeholderTextColor = placeholderTextColor
            self.allowsAllCharacters = allowsAllCharacters
            self.focusBorderColor = focusBorderColor
            self.inactiveBorderColor = inactiveBorderColor
            self.completedBorderColor = completedBorderColor
            self.errorBorderColor = errorBorderColor
            self.returnKeyType = returnKeyType
            self.buttonBorderStyle = buttonBorderStyle
        }
    }
    
    internal func update(oldValue: State?) {
        textField.returnKeyType = state?.returnKeyType ?? .done
        
        if oldValue?.pin != state?.pin {
            textField.text = nil
            createNewButtons()
        }
        else if oldValue?.showsPlaceholder != state?.showsPlaceholder ||
            oldValue?.placeholderTextColor != state?.placeholderTextColor ||
            oldValue?.focusBorderColor != state?.focusBorderColor ||
            oldValue?.inactiveBorderColor != state?.inactiveBorderColor ||
            oldValue?.completedBorderColor != state?.completedBorderColor ||
            oldValue?.errorBorderColor != state?.errorBorderColor ||
            oldValue?.buttonBorderStyle != state?.buttonBorderStyle {
            updateButtonStates()
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
        guard newText.count <= state?.pin?.count ?? 0 else {
            delegate?.pinEntryViewDidTapKeyboardReturnKey(self)
            return false
        }
        
        // Disallow backspace if necessary
        guard state?.allowsBackspace == true || newText.count > oldText.count else {
            return false
        }
        
        // Disallow entering non-matching characters if necessary
        guard state?.allowsAllCharacters == true || newText == (state?.pin ?? "").uppercased().substring(to: newText.count) else {
            showErrorState()
            return false
        }
        
        textField.text = newText
        updateButtonStates()
        
        // The last letter is typed, which means we're all done
        if newText.count == state?.pin?.count ?? 0 {
            delegate?.pinEntryView(self, didFinishEditing: newText)
        }
        
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.pinEntryViewDidTapKeyboardReturnKey(self)
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // Set the focussed state
        updateButtonStates()
        delegate?.pinEntryViewDidBeginEditing(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        // Remove any focussed state
        updateButtonStates()
        delegate?.pinEntryViewDidEndEditing(self)
    }
}

// MARK - Internal

fileprivate extension PinEntryView {
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.isHidden = true
        textField.autocapitalizationType = .allCharacters
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }
    
    func createButton() -> PinButton {
        let button = PinButton(type: .custom)
        button.addTarget(self, action: #selector(openKeyboard), for: .touchUpInside)
        button.backgroundColor = .white
        
        return button
    }
    
    func createSpacerView() -> UIView {
        let view = UIView()
        view.isHidden = true
        return view
    }
    
    func commonInit() {
        state = State(pin: pin,
                      allowsBackspace: allowsBackspace,
                      showsPlaceholder: showsPlaceholder,
                      placeholderTextColor: placeholderTextColor,
                      allowsAllCharacters: allowsAllCharacters,
                      focusBorderColor: focusBorderColor,
                      inactiveBorderColor: inactiveBorderColor,
                      completedBorderColor: completedBorderColor,
                      errorBorderColor: errorBorderColor,
                      returnKeyType: .done,
                      buttonBorderStyle: PinButton.BorderStyle(rawValue: buttonBorderStyle) ?? .full)
        
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
        
        state?.pin?.forEach { _ in
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
        becomeFirstResponder()
    }
    
    func updateButtonStates(overrideFocusBorderColor: UIColor? = nil, overrideInactiveBorderColor: UIColor? = nil) {
        let showsPlaceholder = state?.showsPlaceholder == true
        
        for (i, button) in buttons.enumerated() {
            var buttonState = button.viewState
            buttonState.borderStyle = state?.buttonBorderStyle ?? .full
            
            if let newCharacter = textField.text?[i],
                newCharacter != "" {
                
                buttonState.title = newCharacter
                buttonState.textColor = .black
                buttonState.borderColor = state?.completedBorderColor ?? .black
            }
            else {
                buttonState.title = showsPlaceholder ? state?.pin?.uppercased()[i] : nil
                buttonState.textColor = placeholderTextColor
                
                let isFocussed = isFirstResponder && i == textField.text?.count ?? 0
                
                if isFocussed {
                    buttonState.borderColor = overrideFocusBorderColor ?? state?.focusBorderColor ?? .black
                }
                else {
                    buttonState.borderColor = overrideInactiveBorderColor ?? state?.inactiveBorderColor ?? .black
                }
            }
            
            button.viewState = buttonState
        }
    }
}
