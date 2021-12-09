//
//  DCAService.swift
//  Bridge Rail
//
//  Created by Blair Zhou on 10/12/21.
//

import Foundation
import UIKit

struct DCAService {
     
    func calculate(asset: Asset,
                   initialInvestmentAmount: Double,
                   monthlyDollarCostAveragingAmount: Double,
                   initialDateOfInvestmentIndex: Int) -> DCAResult {
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,
                                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        let latestSharePrice = getlatestSharePrice(asset: asset)
        
        let numberOfShares = getNumberOfShares(asset: asset,
                                               initialInvestmentAmount: initialInvestmentAmount,
                                               monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                               initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        let isProfitable = currentValue > investmentAmount
        
        let gain = currentValue - investmentAmount
        
        // numberOfShares = 67.973
        
        // dec - 1000 / 136.44 = 7.329
        // nov - 1000/ 122.37 = 8.171
        // oct - 1000 / 127.73 = 7.829
        // sep - 5000 / 112.0 = 44.642
        
        let yield = gain / investmentAmount
        
        let annualReturn = getAnnualReturn(currentValue: currentValue,
                                           investmentAmount: investmentAmount,
                                           initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gain: gain,
                     yield: yield,
                     annualReturn: annualReturn,
                     isProfitable: isProfitable)
        
        // currentValue = numberOfShares (initial + DCA) * latest share price
        
        
    }


private func getInvestmentAmount(initialInvestmentAmount: Double,
                                 monthlyDollarCostAveragingAmount: Double,
                                 initialDateOfInvestmentIndex: Int) -> Double {
    
    var totalAmount = Double()
    totalAmount += initialInvestmentAmount
    let dollarCostaveragingAmount = initialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
    totalAmount += dollarCostaveragingAmount
    return totalAmount
    
   }
    
    private func getAnnualReturn(currentValue: Double, investmentAmount: Double, initialDateOfInvestmentIndex: Int) -> Double {
        let rate = currentValue / investmentAmount
        let years = ((initialDateOfInvestmentIndex.doubleValue + 1) / 12)
        let result = pow(rate, (1 / years)) - 1
        return result
    }
    
    private func getCurrentValue(numberOfShares: Double, latestSharePrice: Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getlatestSharePrice(asset: Asset) -> Double {
        return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
    }
    
    private func getNumberOfShares(asset: Asset,
                                   initialInvestmentAmount: Double,
                                   monthlyDollarCostAveragingAmount: Double,
                                   initialDateOfInvestmentIndex: Int) -> Double {
        
        var totalShares = Double()
        
        let initialinvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfos()[initialDateOfInvestmentIndex].adjustedOpen
        
        let initialInvestmentShares = initialInvestmentAmount / initialinvestmentOpenPrice
        totalShares += initialInvestmentShares
        
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(initialDateOfInvestmentIndex).forEach { (MonthInfo) in
            let dcaInvestmentShares = monthlyDollarCostAveragingAmount / MonthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        
        return totalShares
    }
    
}
    

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    let isProfitable: Bool
}
