//
//  SYCheckMarkButton.swift
//  AnimationButton
//
//  Created by Yamada Shunya on 2019/03/19.
//  Copyright © 2019 Yamada Shunya. All rights reserved.
//

import UIKit

@IBDesignable
class SYCheckMarkButton: UIButton {
    
    // IBInspectable
    @IBInspectable var checkMarkImage: UIImage?
    @IBInspectable var checkMarkColor: UIColor = .white
    @IBInspectable var animationDuration: Double = 0.8
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 2
    @IBInspectable var borderColor: UIColor = .lightGray
    @IBInspectable var filledColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1)
    
    // CALayer
    private var imageShape: CAShapeLayer!
    private var circleShape: CAShapeLayer!
    
    // Animations
    private let borderOpacity: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
    private let openOpacity: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
    private let openTransform: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
    private let closeOpacity: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
    private let closeTransform: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
    
    // Checkmark state
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
        clipsToBounds = false
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        // Disable title
        setTitle(nil, for: .normal)
        
        // Layers
        setupLayers()
        setupOpenAnimations()
        setupCloseAnimations()
        addTargets()
    }
    
    private func addTargets() {
        addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
    }
    
    private func setupLayers() {
        guard let image = checkMarkImage else {
            isHidden = true
            return
        }
        
        let midPosition = CGPoint(x: frame.width / 2, y: frame.width / 2)
        
        circleShape = CAShapeLayer()
        circleShape.bounds = bounds
        circleShape.cornerRadius = cornerRadius
        circleShape.position = midPosition
        circleShape.backgroundColor = filledColor.cgColor
        circleShape.transform = CATransform3DMakeScale(0, 0, 1.0)
        self.layer.addSublayer(circleShape)
        
        imageShape = CAShapeLayer()
        imageShape.bounds = bounds
        imageShape.position = midPosition
        imageShape.path = UIBezierPath(rect: frame).cgPath
        imageShape.backgroundColor = checkMarkColor.cgColor
        imageShape.opacity = 0
        self.layer.addSublayer(imageShape)
        
        let imageLayer = CALayer()
        imageLayer.bounds = bounds
        imageLayer.contents = image.cgImage
        imageLayer.position = midPosition
        imageShape.mask = imageLayer
    }
    
    private func setupOpenAnimations() {
        // Opacity
        openOpacity.duration = animationDuration
        openOpacity.keyTimes = [
            0.0,
            1.0
        ]
        openOpacity.values = [
            0.0,
            1.0
        ]
    }
    
    private func setupCloseAnimations() {
        // Opacity
        closeOpacity.duration = animationDuration
        closeOpacity.keyTimes = [
            0.0,
            1.0
        ]
        closeOpacity.values = [
            1.0,
            0.0
        ]
    }
    
    // @objc
    @objc private func touchUpInside(_ sender: SYCheckMarkButton) {
        if checkState == .unchecked {
            checkState = .checked
            open()
        } else {
            checkState = .unchecked
            close()
        }
    }
    
    // Animation
    private func open() {
        CATransaction.begin()
        imageShape.add(openOpacity, forKey: "openOpacity")
        CATransaction.commit()
    }
    
    private func close() {
        CATransaction.begin()
        imageShape.add(closeOpacity, forKey: "closeOpacity")
        CATransaction.commit()
    }
}
