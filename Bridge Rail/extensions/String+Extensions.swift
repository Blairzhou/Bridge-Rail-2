//
//  String+Extensions.swift
//  Bridge Rail
//
//  Created by Blair Zhou on 10/20/21.
//

import Foundation

extension String {
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
}
