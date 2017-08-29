//
//  NetworkManagerTest.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/28/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import XCTest
@testable import WWEMobile

class NetworkManagerTest: XCTestCase {
    
    let networkManager = NetworkManager.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResultExistence() {
        XCTAssertNotNil(networkManager)
    }
    
    func testResultUniqueness() {
        XCTAssertEqual(networkManager, NetworkManager.sharedInstance)
    }
    
    func testResultsOnFeedContents() {
        
        let resultsExpectation = expectation(description: "NetworkManagerFeedResults")
        
        self.networkManager.getVideos(completionHandler: { (wweFeed, error) in
            
            
            XCTAssert((wweFeed?.videos.count)! > 0)
            XCTAssertEqual((wweFeed?.videos.count)!, 20)
            
            resultsExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 30)
        { error in
            
            if let error = error
            {
                print("Thirty seconds (30) timeout ocurred waiting on the results with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceOnFeedContents()
    {
        self.measure
            {
                self.networkManager.getVideos(completionHandler: { (wweFeed, error) in
                    
                    XCTAssert((wweFeed?.videos.count)! > 0)
                    XCTAssertEqual((wweFeed?.videos.count)!, 20)
                })
        }
    }

}
