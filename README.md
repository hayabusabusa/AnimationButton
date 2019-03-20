# AnimationButton
Animate UIButton.

## Preview  
|AnimationButton |AnimationCheckMarkButton |SYRippleButton |SYCheckMarkButton |  
|:-:|:-:|:-:|:-:|  
|![AnimationButton.gif](https://github.com/hayabusabusa/AnimationButton/blob/master/gif/AnimationButton.gif)|![AnimationCheckMarkButton.gif](https://github.com/hayabusabusa/AnimationButton/blob/master/gif/AnimationCheckMarkButton.gif)|![SYRippleButton](https://github.com/hayabusabusa/AnimationButton/blob/master/gif/SYRippleButton.gif)|![SYCheckMarkButton](https://github.com/hayabusabusa/AnimationButton/blob/master/gif/SYCheckmarkButton.gif)|

## Installation
Just copy the `AnimationButton.swift` or `AnimationCheckMarkButton.swift` into your project.  

## Usage
You can use it with storyboard.  
Drag and drop an `UIButton` object into your view controller and set its class to `AnimationButton`.   

## Example 
### AnimationCheckMarkButton  
```swift
import UIKit

class YourViewController: UIViewController {
   
   // Connect AnimationCheckMarkButton on YourViewController.
   @IBOutlet weak var checkMarkButton: AnimationCheckMarkButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Checkmark state changed action.
      checkMarkButton.stateChangedAction = { state in
         print(state)
      }
   }
   
}
```

## TODO  
- [x] チェックマークのボタンを `CALayer` で作り直し  
- [ ] `SYRippleButton` のタップ地点取得を有効にした時のアニメーションを改善
