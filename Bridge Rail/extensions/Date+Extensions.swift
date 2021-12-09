//
//  Date+Extensions.swift
//  Bridge Rail
//
//  Created by Blair Zhou on 9/5/21.
//

import Foundation

extension Date {
    
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}
