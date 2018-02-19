//
//  PinButton.swift
//  PinEntryView
//
//  Created by Laurent Shala on 2/19/18.
//

class PinButton: UIButton {
    let border = UIView()
    
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
        addSubview(border)
        
        border.makeAttribute(.height, equalTo: 2)
        border.makeAttributesEqualToSuperview([.leading, .trailing, .bottom])
    }
    
    struct State {
        var title: String?
        var textColor: UIColor = .black
        var borderColor: UIColor = .black
    }
    
    var viewState = State() {
        didSet {
            update()
        }
    }
    
    private func update() {
        setTitle(viewState.title, for: .normal)
        
        setTitleColor(viewState.textColor, for: .normal)
        border.backgroundColor = viewState.borderColor
    }
}
