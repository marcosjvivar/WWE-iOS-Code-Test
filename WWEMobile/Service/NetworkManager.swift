//
//  NetworkManager.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit

private let _sharedInstance = NetworkManager()

private let videoManager = WWEVideoManager()

open class NetworkManager: NSObject {
    // MARK: - Instantiation
    
    open class var sharedInstance: NetworkManager {
        return _sharedInstance
    }
    
    override init()
    {}
    
    // MARK: - Movies
    
    public func getVideos(completionHandler completion: @escaping (WWEFeedModel?, NSError?) -> ()) {
        videoManager.getVideos { (wweFeed, error) in
            
            if (wweFeed != nil) {
                completion(wweFeed, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
}
