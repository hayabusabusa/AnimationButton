//
//  AnimationCheckMark.swift
//  AnimationButton
//
//  Created by Yamada Shunya on 2019/03/18.
//  Copyright © 2019 Yamada Shunya. All rights reserved.
//

import UIKit

class AnimationCheckMark: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 2
    @IBInspectable var borderColor: UIColor = .lightGray
    
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
    
    @IBInspectable var checkMarkColor: UIColor = .white
    private lazy var checkMarkImageView: UIImageView = {
        var checkMarkImageView = UIImageView()
        checkMarkImageView.isUserInteractionEnabled = false
        checkMarkImageView.image = UIImage(named: "ic_check")
        checkMarkImageView.tintColor = checkMarkColor
        checkMarkImageView.frame = CGRect(x: frame.width / 4, y: frame.height / 4, width: frame.width / 2, height: frame.height / 2)
        return checkMarkImageView
    }()
    
    // State
    enum CheckState: Int {
        case checked
        case unchecked
    }
    public private(set) var checkState: CheckState = .unchecked
    
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
    
    private func commonInit() {
        isExclusiveTouch = true
        isUserInteractionEnabled = true
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateState)))
    }
    
    private func setupCheckMark() {
        // backgroundView
        backgroundView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.addSubview(backgroundView)
        
        // ImageView
        checkMarkImageView.alpha = 0.0
        self.addSubview(checkMarkImageView)
        self.bringSubviewToFront(checkMarkImageView)
    }
    
    // Tap action
    @objc func updateState() {
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
        backgroundView.isHidden = false
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.backgroundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.checkMarkImageView.alpha = 1.0
        },
                       completion: { _ in
        })
    }
    
    private func uncheckAnimation() {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.backgroundView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        UIView.animate(withDuration: 0.2,
                       delay: 0.4,
                       animations: {
                        self.backgroundView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        self.checkMarkImageView.alpha = 0.0
        },
                       completion: { _ in
                        self.backgroundView.isHidden = true
        })
    }
}
