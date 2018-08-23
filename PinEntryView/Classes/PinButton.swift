//
//  PinButton.swift
//  PinEntryView
//
//  Created by Laurent Shala on 2/19/18.
//

public class PinButton: UIButton {
    // MARK: - UI Elements
    
    private let bottomBorder = UIView()
    
    // MARK: - Instance Members
    
    var viewState = ViewState() {
        didSet {
            update(oldValue)
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func prepareForInterfaceBuilder() {
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
    struct ViewState: Equatable {
        var borderStyle: BorderStyle = .full
        var title: String?
        var textColor: UIColor = .black
        var borderColor: UIColor = .black
        
        static func ==(lhs: PinButton.ViewState, rhs: PinButton.ViewState) -> Bool {
            return lhs.borderStyle == rhs.borderStyle &&
                lhs.title == rhs.title &&
                lhs.textColor == rhs.textColor &&
                lhs.borderColor == rhs.borderColor
        }
    }

    private func update(_ oldState: ViewState? = nil) {
        guard viewState != oldState else {
            return
        }
        
        setTitle(viewState.title, for: .normal)
        
        setTitleColor(viewState.textColor, for: .normal)
        
        bottomBorder.backgroundColor = viewState.borderColor
        bottomBorder.isHidden = viewState.borderStyle == .full
        
        layer.cornerRadius = viewState.borderStyle == .full ? 2 : 0
        layer.borderWidth = viewState.borderStyle == .full ? 1 : 0
        layer.borderColor = viewState.borderStyle == .full ? viewState.borderColor.cgColor : nil
    }
}

// MARK: - BorderStyle

extension PinButton {
    @objc public enum BorderStyle: Int {
        
        /** a thin border around the entire button */
        case full
        
        /** a border on the bottom of the button only */
        case bottom
    }
}
