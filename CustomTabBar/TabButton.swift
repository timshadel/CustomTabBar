//
//  TabButton.swift
//  CustomTabBar
//
//  Created by Ben Norris on 2/11/16.
//  Copyright © 2016 BSN Design. All rights reserved.
//

import UIKit

protocol TabButtonDelegate {
    func tabButtonTouched(_ index: Int)
}

class TabButton: UIView {
    
    // MARK: - Internal properties
    
    var delegate: TabButtonDelegate?
    let index: Int
    let dataObject: TabDataObject
    
    var selected = false {
        didSet {
            updateColors()
        }
    }
    var unselectedColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }
    var selectedColor: UIColor = .blue {
        didSet {
            updateColors()
        }
    }
    var inset: CGFloat = 0.0 {
        didSet {
            updateInsets()
        }
    }
    var titleFont: UIFont? = nil {
        didSet {
            updateFont()
        }
    }
    
    
    // MARK: - Private properties
    
    fileprivate let stackView = UIStackView()
    fileprivate let imageButton = UIButton()
    fileprivate let titleLabel = UILabel()
    fileprivate let button = UIButton()
    
    
    // MARK: - Constants
    
    fileprivate static let margin: CGFloat = 4.0
    
    
    // MARK: - Initializers
    
    init(index: Int, dataObject: TabDataObject) {
        self.index = index
        self.dataObject = dataObject
        super.init(frame: CGRect.zero)
        setupViews()
        setupAccessibilityInformation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("TabButton should not be initialized with decoder\(aDecoder)")
    }
    
    
    // MARK: - Button touched
    
    func buttonTouched() {
        delegate?.tabButtonTouched(index)
    }
    
}


// MARK: - Private TabButton functions

private extension TabButton {
    
    func setupAccessibilityInformation() {
        isAccessibilityElement = true
        accessibilityLabel = dataObject.accessibilityTitle.capitalized
        accessibilityIdentifier = "\(dataObject.identifier)TabButton"
        accessibilityTraits = UIAccessibilityTraitButton
        imageButton.isAccessibilityElement = false
        button.isAccessibilityElement = false
    }
    
    func setupViews() {
        backgroundColor = .clear
        
        stackView.axis = .vertical
        addFullSize(stackView, withMargin: true)
        stackView.spacing = 1.0
        
        if let image = dataObject.image {
            stackView.addArrangedSubview(imageButton)
            imageButton.setImage(image, for: UIControlState())
            imageButton.imageView?.contentMode = .scaleAspectFit
        }
        if let title = dataObject.title {
            stackView.addArrangedSubview(titleLabel)
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        }
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9
        
        button.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
        addFullSize(button)
        updateColors()
        updateFont()
    }
    
    func updateColors() {
        titleLabel.textColor = selected ? selectedColor : unselectedColor
        imageButton.tintColor = selected ? selectedColor : unselectedColor
    }
    
    func updateFont() {
        if let titleFont = titleFont {
            titleLabel.font = titleFont
        } else if dataObject.image != nil {
            titleLabel.font = UIFont.systemFont(ofSize: 10)
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    func addFullSize(_ view: UIView, withMargin margin: Bool = false) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin ? TabButton.margin : 0).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: margin ? TabButton.margin : 0).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: margin ? -TabButton.margin : 0).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: margin ? -TabButton.margin : 0).isActive = true
    }
    
    func updateInsets() {
        imageButton.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
    }
    
}
