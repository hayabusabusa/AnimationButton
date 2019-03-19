//
//  SYRippleButton.swift
//  AnimationButton
//
//  Created by Yamada Shunya on 2019/03/19.
//  Copyright © 2019 Yamada Shunya. All rights reserved.
//

import UIKit

@IBDesignable
class SYRippleButton: UIButton {
    
    // IBInspectable
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowOffset: CGSize = .zero
    @IBInspectable var shadowOpacity: Float = 0
    @IBInspectable var animationDuration: Double = 0.6
    @IBInspectable var userTrackingMode: Bool = true
    
    // Layer
    private var rippleShape: CAShapeLayer!
    private var rippleMaskLayer: CAShapeLayer!
    private let rippleTransform: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
    private let rippleOpacity: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
    
    // Override
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if userTrackingMode {
            let location = touch.location(in: self)
            rippleMaskLayer.position = location
        }
        return super.beginTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        startAnimations()
    }
    
    // Lifecycle
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
    
    // Init
    private func commonInit() {
        // Self
        isExclusiveTouch = true
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        
        // CALayer
        setupLayers()
        setupAnimations()
    }
    
    private func setupLayers() {
        let midPosition = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        rippleShape = CAShapeLayer()
        rippleShape.bounds = bounds
        rippleShape.position = midPosition
        rippleShape.cornerRadius = cornerRadius
        rippleShape.backgroundColor = UIColor.black.cgColor
        rippleShape.opacity = 0
        self.layer.addSublayer(rippleShape)
        
        rippleMaskLayer = CAShapeLayer()
        rippleMaskLayer.bounds = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        rippleMaskLayer.cornerRadius = frame.width / 2
        rippleMaskLayer.backgroundColor = UIColor.black.cgColor
        rippleMaskLayer.opacity = 0
        rippleMaskLayer.position = midPosition
        rippleMaskLayer.fillRule = .evenOdd
        rippleMaskLayer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0)
        rippleShape.mask = rippleMaskLayer
    }
    
    private func setupAnimations() {
        // Opacity
        rippleOpacity.duration = animationDuration
        rippleOpacity.values = [
            0.0,
            0.3,
            0.4,
            0.0
        ]
        rippleOpacity.keyTimes = [
            0.0,
            0.4,
            0.8,
            0.99
        ]
        
        // Transform
        rippleTransform.duration = animationDuration
        rippleTransform.values = [
            NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.6, 0.6, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0))
        ]
        rippleTransform.keyTimes = [
            0.0,
            0.4,
            0.99,
            1.0
        ]
    }
    
    // Animation
    private func startAnimations() {
        CATransaction.begin()
        rippleShape.add(rippleOpacity, forKey: "opacity")
        rippleMaskLayer.add(rippleOpacity, forKey: "opacity")
        rippleMaskLayer.add(rippleTransform, forKey: "transform")
        CATransaction.commit()
    }
}
