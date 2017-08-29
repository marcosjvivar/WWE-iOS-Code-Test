//
//  WWEVideoModelTest.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/29/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import XCTest
import SwiftyJSON

@testable import WWEMobile

class WWEVideoModelTest: XCTestCase {
    
    var firstVideoModel: WWEVideoModel!
    var secondVideoModel: WWEVideoModel!

    override func setUp() {
        
        super.setUp()
        
        // First Route
        let firstVideoFilePath = Bundle(for: WWEVideoModelTest.self).path(forResource: "Video_1", ofType: "json")
        
        let firstVideoJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstVideoFilePath!), options:.mappedIfSafe)
        
        let firstVideoJSON = try! JSONSerialization.jsonObject(with: firstVideoJSONData, options: .mutableContainers)
        
        let firstVideoDictionary = JSON(firstVideoJSON)
        
        firstVideoModel = WWEVideoModel.init(json: firstVideoDictionary)
        
        // Second Route
        let secondVideoFilePath = Bundle(for: WWEVideoModelTest.self).path(forResource: "Video_2", ofType: "json")
        
        let secondVideoJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondVideoFilePath!), options:.mappedIfSafe)
        
        let secondVideoJSON = try! JSONSerialization.jsonObject(with: secondVideoJSONData, options: .mutableContainers)
        
        let secondVideoDictionary = JSON(secondVideoJSON)
        
        secondVideoModel = WWEVideoModel.init(json: secondVideoDictionary)
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstVideoModel)
        XCTAssertNotNil(secondVideoModel)
    }
    
    func testResultForFirstVideoContents()
    {
        // First Video
        XCTAssertNotNil(firstVideoModel.videoID)
        XCTAssertNotNil(firstVideoModel.videoTitle)
        XCTAssertNotNil(firstVideoModel.videoBody)
        XCTAssertNotNil(firstVideoModel.videoVMSID)
        XCTAssertNotNil(firstVideoModel.videoMediaID)
        XCTAssertNotNil(firstVideoModel.videoURL)
        XCTAssertNotNil(firstVideoModel.videoPlaybackURL)
        XCTAssertNotNil(firstVideoModel.videoThumbnail)
    }
    
    func testResultForSecondVideoContents()
    {
        // Second Video
        XCTAssertNotNil(secondVideoModel.videoID)
        XCTAssertNotNil(secondVideoModel.videoTitle)
        XCTAssertNotNil(secondVideoModel.videoBody)
        XCTAssertNotNil(secondVideoModel.videoVMSID)
        XCTAssertNotNil(secondVideoModel.videoMediaID)
        XCTAssertNotNil(secondVideoModel.videoURL)
        XCTAssertNotNil(secondVideoModel.videoPlaybackURL)
        XCTAssertNotNil(secondVideoModel.videoThumbnail)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(firstVideoModel.videoID, secondVideoModel.videoID)
        XCTAssertNotEqual(firstVideoModel.videoTitle, secondVideoModel.videoTitle)
        XCTAssertNotEqual(firstVideoModel.videoBody, secondVideoModel.videoBody)
        XCTAssertNotEqual(firstVideoModel.videoVMSID, secondVideoModel.videoVMSID)
        XCTAssertNotEqual(firstVideoModel.videoMediaID, secondVideoModel.videoMediaID)
        XCTAssertNotEqual(firstVideoModel.videoURL, secondVideoModel.videoURL)
        XCTAssertNotEqual(firstVideoModel.videoPlaybackURL, secondVideoModel.videoPlaybackURL)
        XCTAssertNotEqual(firstVideoModel.videoThumbnail, secondVideoModel.videoThumbnail)
    }
    
    func testPerformanceOnUniquenessComparison()
    {
        self.measure
            {
                self.testResultUniqueness()
        }
    }
    
    func testPerformanceOnFirstVideoContents()
    {
        self.measure
            {
                self.testResultForFirstVideoContents()
        }
    }
    
    func testPerformanceOnSecondVideoContents()
    {
        self.measure
            {
                self.testResultForSecondVideoContents()
        }
    }
}
