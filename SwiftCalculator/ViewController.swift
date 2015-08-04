//
//  ViewController.swift
//  SwiftCalculator
//
//  Created by Nate Good on 7/2/15.
//  Copyright (c) 2015 Nate Good. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var display: UILabel!
  var isUserEnteringNumber = false

  var brain = CalculatorBrain()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func digitPressed(sender: UIButton) {
    let digit = sender.currentTitle!
    if( !isUserEnteringNumber ){
      display.text = ""
    }
    let isDecimalInDisplay = display.text!.rangeOfString(".") != nil
    if( digit != "." || !isDecimalInDisplay )
    {
      display.text = display.text! + digit
      isUserEnteringNumber = true
    }
  }
  
  @IBAction func symbolPressed(sender: UIButton) {
    if isUserEnteringNumber {
      enterPressed()
    }
    if let operation = sender.currentTitle {
      if let result = brain.performOperation(operation) {
        displayValue = result
      } else {
        displayValue = 0 //I really want nil to clear out the display (or an error message)
      }
    }
  }
  
  @IBAction func enterPressed() {
    isUserEnteringNumber = false
    if let result = brain.pushOperand(displayValue) {
      displayValue = result
    } else {
      displayValue = 0 //I really want nil to clear out the display (or an error message)
    }
  }
  
  //"Computed Property" - requires get/set
  var displayValue: Double {
    get{
      return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
    }
    set{
      display.text = "\(newValue)"
      isUserEnteringNumber = false
    }
  }

}

