//
//  PinButton.swift
//  PinEntryView
//
//  Created by Laurent Shala on 2/19/18.
//

class PinButton: UIButton {
    // MARK: - UI Elements
    
    private let bottomBorder = UIView()
    
    // MARK: - Instance Members
    
    var viewState = State() {
        didSet {
            update()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    private func commonInit() {
        addSubview(bottomBorder)
        
        bottomBorder.makeAttribute(.height, equalTo: 2)
        bottomBorder.makeAttributesEqualToSuperview([.leading, .trailing, .bottom])
    }
}

// MARK: - State and Update

extension PinButton {
    struct State {
        var title: String?
        var textColor: UIColor = .black
        var borderColor: UIColor = .black
    }

    private func update() {
        setTitle(viewState.title, for: .normal)
        
        setTitleColor(viewState.textColor, for: .normal)
        bottomBorder.backgroundColor = viewState.borderColor
    }
}

// MARK: - BorderStyle

extension PinButton {
    enum BorderStyle {
        
        /** a thin border around the entire button */
        case full
        
        /** a border on the bottom of the button only */
        case bottom
    }
}
