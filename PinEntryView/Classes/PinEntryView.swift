//
//  PinEntryView.swift
//  Pods
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
    
    @objc @IBInspectable fileprivate var defaultPin: String?
    
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
        public let pin: String
        
        public init(pin: String) {
            self.pin = pin
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
    
}

// MARK - Internal

fileprivate extension PinEntryView {
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.isHidden = true
        return textField
    }
    
    func createButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }
    
    func createSpacerView() -> UIView {
        let view = UIView()
        view.isHidden = true
        return view
    }
    
    func commonInit() {
        if let pin = defaultPin {
            state = State(pin: pin)
        }
        
        backgroundColor = .clear
    }
    
    func createNewButtons() {
        buttons.forEach {
            $0.removeFromSuperview()
        }
        buttons.removeAll()
        
        state?.pin.characters.forEach { _ in
            let button = createButton()
            buttons.append(button)
            addSubview(button)
        }
        
        constrainButtons()
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
    
    @objc func didTapButton(_ sender: Any) {
        
    }
}
