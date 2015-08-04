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
  var operandStack = Array<Double>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
  
  @IBAction func enterPressed() {
    isUserEnteringNumber = false
    operandStack.append(displayValue);
    println("operandStack=\(operandStack)")
  }
  
  @IBAction func symbolPressed(sender: UIButton) {
    let operation = sender.currentTitle!
    if isUserEnteringNumber {
      enterPressed()
    }
    switch operation {
    case "✕": performOperation { $0 * $1 }
    case "÷": performOperation { $1 / $0 }
    case "+": performOperation { $0 + $1 }
    case "-": performOperation { $1 - $0 }
    case "√": performOperation1 { sqrt($0) }
    default: break;
    }
  }
  
  func performOperation (operation: (Double, Double) -> Double) {
    if( operandStack.count >= 2 ){
      displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
      enterPressed()
    }
  }
  
  func performOperation1 (operation: Double -> Double) {
    if( operandStack.count >= 1 ){
      displayValue = operation(operandStack.removeLast())
      enterPressed()
    }
  }

}

