//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Hanz on 16/7/15.
//  Copyright © 2016年 Hanz. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnartOperation(sqrt),
        "cos": Operation.UnartOperation(cos),
        "×": Operation.BinaryOperation(*),
        "+": Operation.BinaryOperation(+),
        "÷": Operation.BinaryOperation(/),
        "−": Operation.BinaryOperation(-),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case BinaryOperation((Double, Double) -> Double)
        case UnartOperation((Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let constant = operations[symbol] {
            switch constant {
            case .Constant(let value):
                accumulator = value
            case .UnartOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case.Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}