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

class WWEVideoTest: XCTestCase {
    
    var firstVideo: WWEVideo!
    var secondVideo: WWEVideo!

    override func setUp() {
        
        super.setUp()
        
        // First Route
        let firstVideoFilePath = Bundle(for: WWEVideoTest.self).path(forResource: "Video_1", ofType: "json")
        
        let firstVideoJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstVideoFilePath!), options:.mappedIfSafe)
        
        let firstVideoJSON = try! JSONSerialization.jsonObject(with: firstVideoJSONData, options: .mutableContainers)
        
        let firstVideoDictionary = JSON(firstVideoJSON)
        
        firstVideo = WWEVideo.create(json: firstVideoDictionary)
        
        // Second Route
        let secondVideoFilePath = Bundle(for: WWEVideoTest.self).path(forResource: "Video_2", ofType: "json")
        
        let secondVideoJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondVideoFilePath!), options:.mappedIfSafe)
        
        let secondVideoJSON = try! JSONSerialization.jsonObject(with: secondVideoJSONData, options: .mutableContainers)
        
        let secondVideoDictionary = JSON(secondVideoJSON)
        
        secondVideo = WWEVideo.create(json: secondVideoDictionary)
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstVideo)
        XCTAssertNotNil(secondVideo)
    }
    
    func testResultForFirstVideoContents()
    {
        // First Video
        XCTAssertNotNil(firstVideo.videoID)
        XCTAssertNotNil(firstVideo.videoTitle)
        XCTAssertNotNil(firstVideo.videoBody)
        XCTAssertNotNil(firstVideo.videoVMSID)
        XCTAssertNotNil(firstVideo.videoMediaID)
        XCTAssertNotNil(firstVideo.videoURL)
        XCTAssertNotNil(firstVideo.videoPlaybackURL)
        XCTAssertNotNil(firstVideo.videoThumbnail)
    }
    
    func testResultForSecondVideoContents()
    {
        // Second Video
        XCTAssertNotNil(secondVideo.videoID)
        XCTAssertNotNil(secondVideo.videoTitle)
        XCTAssertNotNil(secondVideo.videoBody)
        XCTAssertNotNil(secondVideo.videoVMSID)
        XCTAssertNotNil(secondVideo.videoMediaID)
        XCTAssertNotNil(secondVideo.videoURL)
        XCTAssertNotNil(secondVideo.videoPlaybackURL)
        XCTAssertNotNil(secondVideo.videoThumbnail)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(firstVideo.videoID, secondVideo.videoID)
        XCTAssertNotEqual(firstVideo.videoTitle, secondVideo.videoTitle)
        XCTAssertNotEqual(firstVideo.videoBody, secondVideo.videoBody)
        XCTAssertNotEqual(firstVideo.videoVMSID, secondVideo.videoVMSID)
        XCTAssertNotEqual(firstVideo.videoMediaID, secondVideo.videoMediaID)
        XCTAssertNotEqual(firstVideo.videoURL, secondVideo.videoURL)
        XCTAssertNotEqual(firstVideo.videoPlaybackURL, secondVideo.videoPlaybackURL)
        XCTAssertNotEqual(firstVideo.videoThumbnail, secondVideo.videoThumbnail)
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
