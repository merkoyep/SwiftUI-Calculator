//
//  GlobalState.swift
//  Calculator-SwiftUi
//
//  Created by Marco on 2025-06-08.
//

import Foundation

final class GlobalState: ObservableObject {
    enum Token: CustomStringConvertible {
        case number(String)
        case op(CalcKey)
        
        var description: String {
            switch self {
            case .number(let str):
                return str
            case .op(let key):
                return key.rawValue
            }
        }
        
        var doubleValue: Double? {
            guard case .number(let string) = self else { return nil }
            return Double(string)
        }
    }
    
    @Published private(set) var tokens: [Token] = [.number("0")]
    
    var display: String {
        tokens.map(\.description).joined()
    }
    
    private let operatorSet: Set<Character> = ["+", "−", "×", "÷", "%"]
    
    private var currentNumber: Substring {
        let i = display.lastIndex(where: { operatorSet.contains($0) }) ?? display.startIndex
        let start = (i == display.startIndex) ? i : display.index(after: i)
        return display[start...]
    }

    private var currentNumberHasDot: Bool {
        currentNumber.contains(".")
    }
    
    private func appendDecimal() {
        if case .number(let text) = tokens.last {
            if !text.contains(".") {
                tokens[tokens.count - 1] = .number(text + ".")
            }
        } else {
            tokens.append(.number("0."))
        }
    }
    
    private func appendDigit(_ key: CalcKey) {
        if case .number(let text) = tokens.last {
            if text == "0" {
                tokens[tokens.count - 1] = .number(key.rawValue)
            } else {
                tokens[tokens.count - 1] = .number(text + key.rawValue)
            }
        } else {
            tokens.append(.number(key.rawValue))
        }
    }
    
    private func evaluateTokens() -> Double {
        var expression = ""
        for token in tokens {
            switch token {
            case .number(let str):
                if let number = Double(str) {
                    expression += String(format: "%.8f", number)
                } else {
                    expression += str
                }
            case .op(let key):
                switch key {
                case .add: expression += "+"
                case .subtract: expression += "-"
                case .multiply: expression += "*"
                case .divide: expression += "/"
                case .percent: expression += "%"
                default: break
                }
            }
        }
        
        print("Evaluating expression: \(expression)")
        
        let result = (NSExpression(format: expression)
                      .expressionValue(with: nil, context: nil) as? NSNumber)?
                      .doubleValue ?? 0
        
        print("Result: \(result)")
        return result
    }

    private func replaceOrAppend(_ token: Token) {
        if case .op = tokens.last {
            tokens[tokens.count - 1] = token
        } else {
            tokens.append(token)
        }
    }
    
    private func format(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? String(number)
    }
    
    private func handlePercent() {
        if case .number(let text) = tokens.last,
           let value = Double(text) {
            let percentValue = value / 100
            tokens[tokens.count - 1] = .number(format(percentValue))
        }
    }
    
    private func handlePlusMinus() {
        if case .number(let text) = tokens.last {
            if text.hasPrefix("-") {
                tokens[tokens.count - 1] = .number(String(text.dropFirst()))
            } else {
                tokens[tokens.count - 1] = .number("-" + text)
            }
        }
    }
    
    init() {
        tokens = [.number("0")]
    }
    
    func keyPressed(_ key: CalcKey) {
        print(tokens)
        
        switch key {
        case .zero, .one, .two, .three, .four,
             .five, .six, .seven, .eight, .nine:
            appendDigit(key)
            
        case .add, .subtract, .multiply, .divide:
            replaceOrAppend(.op(key))
            
        case .decimal:
            appendDecimal()
            
        case .percent:
            handlePercent()
            
        case .plusMinus:
            handlePlusMinus()
            
        case .clear:
            tokens = [.number("0")]
            
        case .equals:
            let result = evaluateTokens()
            let text = format(result)
            tokens = [.number(text)]
        }
    }
}

  
