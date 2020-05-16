import Foundation

struct RegexStringInterpolation<T>: StringInterpolationProtocol {
    private(set) var regex = ""
    private(set) var keyPaths = [WritableKeyPath<T, String?>]()
    
    init(literalCapacity: Int, interpolationCount: Int) {
    }
    
    mutating func appendLiteral(_ literal: String) {
        regex += literal
    }
    
    mutating func appendInterpolation(_ pattern: String, _ keyPath: WritableKeyPath<T, String?>) {
        regex += "(\(pattern))"
        keyPaths.append(keyPath)
    }
    
    typealias StringLiteralType = String
}

class InlinePattern<T>: ExpressibleByStringInterpolation {
    private let stringInterpolation: RegexStringInterpolation<T>?
    
    required init(stringLiteral value: StringLiteralType) {
        stringInterpolation = nil
    }
    
    required init(stringInterpolation: RegexStringInterpolation<T>) {
        self.stringInterpolation = stringInterpolation
    }
    
    func on(_ text: String, store: (WritableKeyPath<T, String?>, String) -> Void) {
        guard let stringInterpolation = stringInterpolation else { return }
        
        let re = try! NSRegularExpression(pattern: stringInterpolation.regex, options: [.caseInsensitive])
        let matches = re.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        
        for i in 0..<matches.count {
            for j in 1...re.numberOfCaptureGroups {
                let range = matches[i].range(at: j)
                
                if range.location == NSNotFound { continue }
                
                if let swiftRange = Range(range, in: text) {
                    let value = text[swiftRange]
                    store(stringInterpolation.keyPaths[j-1], String(value))
                }
            }
        }
    }
}

class InlineRegex<T> {
    static func on(_ text: String, pattern: InlinePattern<T>, store: inout T) {
        pattern.on(text) { (path, value) in
            store[keyPath: path] = value
        }
    }
}
