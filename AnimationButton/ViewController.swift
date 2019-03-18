//
//  ViewController.swift
//  AnimationButton
//
//  Created by Yamada Shunya on 2019/03/18.
//  Copyright © 2019 Yamada Shunya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var checkMark: AnimationCheckMarkButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkMark.stateChangedAcion = { state in
            self.stateLabel.text = "state: \(state)"
        }
    }
}

