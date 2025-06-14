import Foundation

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