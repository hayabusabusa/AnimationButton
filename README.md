# AnimationButton
Animate UIButton.

## Preview  
![preview](https://github.com/hayabusabusa/AnimationButton/blob/master/preview.gif)  

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
