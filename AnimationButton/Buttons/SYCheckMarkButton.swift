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
    @IBInspectable var animationDuration: Double = 0.5
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 2
    @IBInspectable var borderColor: UIColor = .lightGray
    @IBInspectable var filledColor: UIColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1)
    
    // CALayer
    private var imageShape: CAShapeLayer!
    private var borderShape: CAShapeLayer!
    private var circleShape: CAShapeLayer!
    
    // Animations
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
        
        // Disable title, image
        setTitle(nil, for: .normal)
        setImage(nil, for: .normal)
        
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
        
        borderShape = CAShapeLayer()
        borderShape.bounds = bounds
        borderShape.cornerRadius = cornerRadius
        borderShape.borderWidth = borderWidth
        borderShape.borderColor = borderColor.cgColor
        borderShape.position = midPosition
        self.layer.addSublayer(borderShape)
        
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
        openOpacity.isRemovedOnCompletion = false
        openOpacity.fillMode = .forwards
        openOpacity.keyTimes = [
            0.0,
            1.0
        ]
        openOpacity.values = [
            0.0,
            1.0
        ]
        
        // Transform
        openTransform.duration = animationDuration
        openTransform.isRemovedOnCompletion = false
        openTransform.fillMode = .forwards
        openTransform.keyTimes = [
            0.0,
            1.0
        ]
        openTransform.values = [
            NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        ]
    }
    
    private func setupCloseAnimations() {
        let closeDuration = animationDuration + 0.2
        
        // Opacity
        closeOpacity.duration = closeDuration
        closeOpacity.isRemovedOnCompletion = false
        closeOpacity.fillMode = .forwards
        closeOpacity.keyTimes = [
            0.0,
            0.5,
            1.0
        ]
        closeOpacity.values = [
            1.0,
            1.0,
            0.0
        ]
        
        // Transform
        closeTransform.duration = closeDuration
        closeTransform.isRemovedOnCompletion = false
        closeTransform.fillMode = .forwards
        closeTransform.keyTimes = [
            0.0,
            0.2,
            0.5,
            1.0
        ]
        closeTransform.values = [
            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1.0))
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
        isEnabled = false
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            self.isEnabled = true
        }
        
        imageShape.add(openOpacity, forKey: "openOpacity")
        circleShape.add(openTransform, forKey: "openTransform")
        CATransaction.commit()
    }
    
    private func close() {
        isEnabled = false
        CATransaction.begin()
        
        // Remove all animations
        CATransaction.setCompletionBlock {
            self.isEnabled = true
            self.imageShape.removeAllAnimations()
            self.circleShape.removeAllAnimations()
        }
        
        imageShape.add(closeOpacity, forKey: "closeOpacity")
        circleShape.add(closeTransform, forKey: "closeTransform")
        CATransaction.commit()
    }
}
