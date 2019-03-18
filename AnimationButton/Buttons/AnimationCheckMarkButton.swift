//
//  AnimationCheckMarkButton.swift
//  AnimationButton
//
//  Created by Yamada Shunya on 2019/03/18.
//  Copyright © 2019 Yamada Shunya. All rights reserved.
//

import UIKit

@IBDesignable
class AnimationCheckMarkButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 2
    @IBInspectable var borderColor: UIColor = .lightGray
    
    // Background view( UIView )
    @IBInspectable var filledColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1)
    private lazy var backgroundView: UIView = {
        var backgroundView = UIView()
        backgroundView.isUserInteractionEnabled = false
        backgroundView.isHidden = true
        backgroundView.backgroundColor = filledColor
        backgroundView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        backgroundView.layer.cornerRadius = self.layer.cornerRadius
        return backgroundView
    }()
    
    // ImageView
    @IBInspectable var checkMarkColor: UIColor = .white
    @IBInspectable var checkMarkImage: UIImage?
    private lazy var checkMarkImageView: UIImageView = {
        var checkMarkImageView = UIImageView()
        checkMarkImageView.isUserInteractionEnabled = false
        checkMarkImageView.image = checkMarkImage
        checkMarkImageView.tintColor = checkMarkColor
        checkMarkImageView.frame = CGRect(x: frame.width / 4, y: frame.height / 4, width: frame.width / 2, height: frame.height / 2)
        return checkMarkImageView
    }()
    
    // State
    enum CheckState: Int {
        case checked
        case unchecked
    }
    public var stateChangedAcion: ((CheckState) -> Void)?
    public private(set) var checkState: CheckState = .unchecked {
        didSet {
            guard let action = stateChangedAcion else { return }
            action(checkState)
        }
    }
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupCheckMark()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        setupCheckMark()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        setupCheckMark()
    }
    
    // Common init, setup
    private func commonInit() {
        isExclusiveTouch = true
        clipsToBounds = false
        
        // Layer
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        self.setTitle(nil, for: .normal)
        self.addTarget(self, action: #selector(touchUpAction), for: .touchUpInside)
    }
    
    private func setupCheckMark() {
        // backgroundView
        backgroundView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        self.addSubview(backgroundView)
        self.bringSubviewToFront(backgroundView)
        
        // ImageView
        checkMarkImageView.alpha = 0.0
        self.addSubview(checkMarkImageView)
        self.bringSubviewToFront(checkMarkImageView)
    }
    
    // Touch action
    @objc func touchUpAction() {
        if checkState == .unchecked {
            checkState = .checked
            checkAnimation()
        } else {
            checkState = .unchecked
            uncheckAnimation()
        }
    }
    
    // Animation
    private func checkAnimation() {
        isEnabled = false
        backgroundView.isHidden = false
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.checkMarkImageView.alpha = 1.0
                        self.backgroundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        },
                       completion: { _ in
                        self.isEnabled = true
        })
    }
    
    private func uncheckAnimation() {
        isEnabled = false
//        UIView.animate(withDuration: 0.2,
//                       animations: {
//                        self.backgroundView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//        })
        UIView.animate(withDuration: 0.2,
                       //delay: 0.4,
                       animations: {
                        self.checkMarkImageView.alpha = 0
                        self.backgroundView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        },
                       completion: { _ in
                        self.isEnabled = true
                        self.backgroundView.isHidden = true
        })
    }
}
