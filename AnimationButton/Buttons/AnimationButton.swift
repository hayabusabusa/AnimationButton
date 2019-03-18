//
//  AnimationButton.swift
//  AnimationButton
//
//  Created by Yamada Shunya on 2019/03/18.
//  Copyright © 2019 Yamada Shunya. All rights reserved.
//

import UIKit

@IBDesignable
class AnimationButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowOffset: CGSize = .zero
    @IBInspectable var shadowOpacity: Float = 0
    
    override var isHighlighted: Bool {
        didSet {
            tappedAnimation(isHighlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    private func commonInit() {
        isExclusiveTouch = true
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
    
    // Animation
    private func tappedAnimation(_ highlighted: Bool) {
        if highlighted {
            UIView.animate(withDuration: 0.15,
                           animations: {
                            self.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
                            },
                           completion: nil)
        } else {
            UIView.animate(withDuration: 0.15,
                           animations: {
                            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                            },
                           completion: nil)
        }
    }
}
