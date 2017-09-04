//
//  WWEVideoManager.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import Foundation

private let _sharedInstance = WWEVideoManager()

open class WWEVideoManager: NSObject {
    // MARK: - Instantiation
    
    open class var sharedInstance: WWEVideoManager {
        return _sharedInstance
    }
    
    override init() {}
    
    // MARK: - Public
    
    func getVideos(completionHandler completion: @escaping (WWEFeed?, NSError?) -> ()) {
        let videosURLString: String = "\(WWE_BASE_URL)\(FEED_ENDPOINT)"
        
        NetworkService.performRequest(urlString: videosURLString) { (json, error) in
            
            if (json != nil) {
                let wweFeed = WWEFeed.create(json: json!)
                
                completion(wweFeed, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
}
