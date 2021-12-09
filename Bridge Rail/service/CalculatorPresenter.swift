//
//  CalculatorPresenter.swift
//  Bridge Rail
//
//  Created by Blair Zhou on 11/11/21.
//

import UIKit

struct CalculatorPresenter {
    
    func getPresentation(result: DCAResult) -> CalculatorPresentation {
        

        let isProfitable = result.isProfitable == true
        let gainSymbol = isProfitable ? "+" : ""
        
        
        return .init(currentValueLabelBackgroundClor: isProfitable ? .themeGreenShade : .themeRedShade,
                     currentValue: result.currentValue.currencyFormat,
                     investmentAmount: result.investmentAmount.toCurrencyFormat(hasDecimalPlaces: false),
                     gain: result.gain.toCurrencyFormat(hasDollarSymbol: true, hasDecimalPlaces: false).prefix(withText: gainSymbol),
                     yield: result.yield.percentageFormat.prefix(withText: gainSymbol).addBrackets(),
                     yieldLabelTextColor: isProfitable ? .systemGreen : .systemRed,
                     annualReturn: result.annualReturn.percentageFormat,
                     annualReturnLabelTextColor: isProfitable ? .systemGreen : .systemRed)
        
    }
}
    
    struct CalculatorPresentation {
        let currentValueLabelBackgroundClor: UIColor
        let currentValue: String
        let investmentAmount: String
        let gain: String
        let yield: String
        let yieldLabelTextColor: UIColor
        let annualReturn: String
        let annualReturnLabelTextColor: UIColor
    }



