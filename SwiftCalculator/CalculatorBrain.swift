//
//  CalculatorBrain.swift
//  SwiftCalculator
//
//  Created by Nate Good on 8/3/15.
//  Copyright (c) 2015 Nate Good. All rights reserved.
//

import Foundation

class CalculatorBrain{
  
  private enum Op{
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
  }
  
  private var opStack = [Op]() // Equivalent (but not preferred): Array<Op>()
  private var knownOps = [String:Op]() // Dictionary<String, Op>
  
  init(){
    knownOps["✕"] = Op.BinaryOperation("✕", *) //Infix operator, same as: { $0 * $1 }
    knownOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 } )
    knownOps["+"] = Op.BinaryOperation("+", { $0 + $1 } )
    knownOps["-"] = Op.BinaryOperation("-", { $1 - $0 } )
    knownOps["√"] = Op.UnaryOperation("√", sqrt) // { sqrt($0) }
  }
  
  //Arrays and Dictionaries are Structs, not Classes (so they're immutable)
  //arguments have an implicit 'let'
  private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
    
    if !ops.isEmpty {
      var remainingOps = ops //copies the thing (but its efficient)
      let op = remainingOps.removeLast()
      
      switch op {
        
      case .Operand(let operand):
        return (operand, remainingOps)
        
      case .UnaryOperation(_ , let operation): //_ means 'I don't care about this'
        let operandEvaluation = evaluate(remainingOps)
        if let operand = operandEvaluation.result {
          return (operation(operand), operandEvaluation.remainingOps)
        }
        
      case .BinaryOperation(_ , let operation):
        let op1Evaluation = evaluate(remainingOps)
        if let operand1 = op1Evaluation.result {
          let op2Evaluation = evaluate(op1Evaluation.remainingOps)
          if let operand2 = op2Evaluation.result {
            return (operation(operand1, operand2), op2Evaluation.remainingOps)
          }
        }
      }
    }
    return (nil, ops)
  }
  
  func evaluate() -> Double? {
    let (result, remainder) = evaluate(opStack)
    return result;
  }
  
  func pushOperand(operand: Double){
    opStack.append(Op.Operand(operand))
  }
  
  func performOperation(symbol: String){
    if let operation = knownOps[symbol] {
      opStack.append(operation)
    }
  }
}