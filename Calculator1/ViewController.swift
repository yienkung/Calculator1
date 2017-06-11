//
//  ViewController.swift
//  Calculator1
//
//  Created by Yi En Kung on 6/5/2017.
//  Copyright © 2017 Yi En Kung. All rights reserved.
//

import UIKit

extension Double {
    
    /// This computed property would provide a formatted string representation of this double value.
    /// For an integer value, like `2.0`, this property would be `"2"`.
    /// And for other values like `2.4`, this would be `"2.4"`.
    fileprivate var displayString: String {
        // 1. We have to check whether this double value is an integer or not.
        //    Here I subtract the value with its floor. If the result is zero, it's an integer.
        //    (Note: `floor` means removing its fraction part, 無條件捨去.
        //           `ceiling` also removes the fraction part, but it's by adding. 無條件進位.)
        let floor = self.rounded(.towardZero)  // You should check document for the `rounded` method of double
        let isInteger = self.distance(to: floor).isZero
        
        let string = String(self)
        if isInteger {
            // Okay this value is an integer, so we have to remove the `.` and tail zeros.
            // 1. Find the index of `.` first
            if let indexOfDot = string.characters.index(of: ".") {
                // 2. Return the substring from 0 to the index of dot
                //    For example: "2.0" --> "2"
                return string.substring(to: indexOfDot)
            }
        }
        // Return original string representation
        return String(self)
    }
}

class ViewController: UIViewController {

    
    var core = Core<Double>()
    
    
    
    @IBOutlet weak var displayText: UILabel!
    @IBAction func operatorButton(_ sender: UIButton) {
        // Add current number into the core as a step
        let currentNumber = Double(self.displayText.text ?? "0")!
        try! self.core.addStep(currentNumber)
        // Clean the display to accept user's new input
        self.displayText.text = "0"
        
        // Here, I use tag to check whether the button it is.
        switch sender.tag {
        case 110: // Add
            try! self.core.addStep(+)
        case 111: // Sub
            try! self.core.addStep(-)
        case 112: // Sub
            try! self.core.addStep(*)
        case 113: // Sub
            try! self.core.addStep(/)
            
            
        default:
            fatalError("Unknown operator button: \(sender)")
        }
        
    }
    
    @IBAction func setACButton(_ sender: UIButton) {
        // Clear (Reset)
        // 1. Clean the display label
        self.displayText.text = "0"
        // 2. Reset the core
        self.core = Core<Double>()
        
    }
    
    @IBAction func numberKeyPress(_ sender: UIButton) {
        // Get the digit from the button.
        // There are 2 ways to get the digit set on the button.
        
        // 1. By the label of the button. Like this way:
        //    (But this only works when the button title is also the digit.
        /*
         let digitText = sender.title(for: .normal)!
         */
        
        // 2. Use the tag to identify which button it is.
        //    First, I set the tag of each digit button from 1000 to 1009 in Storyboard.
        //    (The unset/default tag of a view is `0`.
        //     So it's better not to use `0` to check button identity. I add 1000 for this)
        let numericButtonDigit = sender.tag - 100
        let digitText = "\(numericButtonDigit)"
        
        // Show the digit
        let currentText = self.displayText.text ?? "0"
        if currentText == "0" {
            // When the current display text is "0", replace it directly.
            self.displayText.text = digitText
        } else {
            // Else, append it
            self.displayText.text = currentText + digitText
        }
    
    }
    @IBAction func calculateButton(_ sender: UIButton) {
        // Add current number into the core as a step
        let currentNumber = Double(self.displayText.text ?? "0")!
        
        try! self.core.addStep(currentNumber)
        // Get and show the result
        let result = self.core.calculate()!
        self.displayText.text = result.displayString
        // for %
       
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

