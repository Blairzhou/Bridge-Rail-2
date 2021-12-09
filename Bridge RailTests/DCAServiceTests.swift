//
//  Bridge_RailTests.swift
//  Bridge RailTests
//
//  Created by Blair Zhou on 11/15/21.
//

import XCTest
@testable import Bridge_Rail

class DCAServiceTests: XCTestCase {
    
    var sut: DCAService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testResult_givenWinningAssetAndDCAIsUsed_expectPositiveGains() {
        
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1500
        let initialDateOfInvestmentIndex: Int = 5
        let asset = buildWinningAsset()
        
        let result = sut.calculate(asset: asset,
                                   initialInvestmentAmount: initialInvestmentAmount,
                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        XCTAssertEqual(result.investmentAmount, 12500)
        XCTAssertTrue(result.isProfitable)
        
        
        XCTAssertEqual(result.currentValue, 17342.224, accuracy: 0.1)
        XCTAssertEqual(result.gain, 4842.224, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3873, accuracy: 0.0001)
    }
    
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateOfInvestmentIndex: Int = 3
        let asset = buildWinningAsset()
        
        let result = sut.calculate(asset: asset,
                                   initialInvestmentAmount: initialInvestmentAmount,
                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertTrue(result.isProfitable)
        
        
        XCTAssertEqual(result.currentValue, 6666.666, accuracy: 0.1)
        XCTAssertEqual(result.gain, 1666.666, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3333, accuracy: 0.0001)
    }
    
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1500
        let initialDateOfInvestmentIndex: Int = 5
        let asset = buildLosingAsset()
        
        let result = sut.calculate(asset: asset,
                                   initialInvestmentAmount: initialInvestmentAmount,
                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        XCTAssertEqual(result.investmentAmount, 12500)
        XCTAssertFalse(result.isProfitable)
        
        
        XCTAssertEqual(result.currentValue, 9189.323, accuracy: 0.1)
        XCTAssertEqual(result.gain, -3310.677, accuracy: 0.1)
        XCTAssertEqual(result.yield, -0.2648, accuracy: 0.0001)
        
    }
    
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegativeGains() {
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateOfInvestmentIndex: Int = 3
        let asset = buildLosingAsset()
        
        let result = sut.calculate(asset: asset,
                                   initialInvestmentAmount: initialInvestmentAmount,
                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertFalse(result.isProfitable)
        
        
        XCTAssertEqual(result.currentValue, 3666.666, accuracy: 0.1)
        XCTAssertEqual(result.gain, -1333.333, accuracy: 0.1)
        XCTAssertEqual(result.yield, -0.26666, accuracy: 0.0001)
        
    }
    
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries: [String: OHLC] = ["2021-01-25" : OHLC(open: "100", close: "110", adjustedClose: "110"),
                                          "2021-02-25" : OHLC(open: "110", close: "120", adjustedClose: "120"),
                                          "2021-03-25" : OHLC(open: "120", close: "130", adjustedClose: "130"),
                                          "2021-04-25" : OHLC(open: "130", close: "140", adjustedClose: "140"),
                                          "2021-05-25" : OHLC(open: "140", close: "150", adjustedClose: "150"),
                                          "2021-06-25" : OHLC(open: "150", close: "160", adjustedClose: "160")]
        
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    private func buildLosingAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries: [String: OHLC] = ["2021-01-25" : OHLC(open: "170", close: "160", adjustedClose: "160"),
                                          "2021-02-25" : OHLC(open: "160", close: "150", adjustedClose: "150"),
                                          "2021-03-25" : OHLC(open: "150", close: "140", adjustedClose: "140"),
                                          "2021-04-25" : OHLC(open: "140", close: "130", adjustedClose: "130"),
                                          "2021-05-25" : OHLC(open: "130", close: "120", adjustedClose: "120"),
                                          "2021-06-25" : OHLC(open: "120", close: "110", adjustedClose: "110")]
        
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    private func buildSearchResult() -> SearchResult {
        return SearchResult(symbol: "XYZ", name: "XYZ Company", type: "ETF", currency: "USD")
    }
    
    private func buildMeta() -> Meta  {
        return Meta(symbol: "XYZ")
    }


}
