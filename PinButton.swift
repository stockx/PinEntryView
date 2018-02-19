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
            update(oldValue)
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
        
        update()
    }
}

// MARK: - State and Update

extension PinButton {
    struct State: Equatable {
        var borderStyle: BorderStyle = .full
        var title: String?
        var textColor: UIColor = .black
        var borderColor: UIColor = .black
        
        static func ==(lhs: PinButton.State, rhs: PinButton.State) -> Bool {
            return lhs.borderStyle == rhs.borderStyle &&
                lhs.title == rhs.title &&
                lhs.textColor == rhs.textColor &&
                lhs.borderColor == rhs.borderColor
        }
    }

    private func update(_ oldState: State? = nil) {
        guard viewState != oldState else {
            return
        }
        
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
