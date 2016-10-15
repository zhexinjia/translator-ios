//
//  FinalProjectTests.swift
//  FinalProjectTests
//
//  Created by Charles Augustine on 7/14/15.
//
//

import UIKit
import XCTest
@testable import FinalProject

class FinalProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testDataService(){
        let result = "No such vocabulary found\nplease check your spelling or\nTry Wikipidea tab for English Definition"
        let test1 = DataService.sharedDataService.getDefination("Hello")
        XCTAssertNotEqual(result, test1, "word Hello definition should be found in web service")
        
        let test2 = DataService.sharedDataService.getDefination("aasfdsffdsfeecz")
        XCTAssertEqual(result, test2, "wold aasfdsffdsfeecz shouldn't have a definition on web or databse")
        
        let test3 = DataService.sharedDataService.getScentence("Hello")
        XCTAssertNotEqual(result, test3, "word Hello definition should be found in web service")
    }
    
    func testTestService(){
        let testService = TestService()
        XCTAssertLessThanOrEqual(testService.getQuestionNum(), testService.getHistoryCount(), "questions should be equal or less than history count")
    }
    
    func testSettingService(){
        SettingService.sharedSettingService.setAutoAdd(false)
        XCTAssertEqual(SettingService.sharedSettingService.getAutoAdd(), false, "Set autoAdd to false failed")
        SettingService.sharedSettingService.setAutoAdd(true)
        XCTAssertEqual(SettingService.sharedSettingService.getAutoAdd(), true, "Set autoAdd to true failed")
        
        SettingService.sharedSettingService.setQuestionNum(20)
        XCTAssertEqual(SettingService.sharedSettingService.getQuestionNum(), 20, "Set questionNum to 20 failed")
        SettingService.sharedSettingService.setQuestionNum(10)
        XCTAssertEqual(SettingService.sharedSettingService.getQuestionNum(), 10, "Set questionNum to 10 failed")
        
        SettingService.sharedSettingService.setAutoPopUpKeyboard(true)
        XCTAssertEqual(SettingService.sharedSettingService.getAutoPopUPKeyboard(), true, "Set autoPopUpkeyBoard to true failed")
        SettingService.sharedSettingService.setAutoPopUpKeyboard(false)
        XCTAssertEqual(SettingService.sharedSettingService.getAutoPopUPKeyboard(), false, "Set autoPopUpkeyBoard to false failed")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
