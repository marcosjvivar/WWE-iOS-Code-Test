//
//  VideosDataSource.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit

open class VideosDataSource: NSObject
{
    override init()
    {
        super.init()
    }
    
    public func getVideos(completionHandler completion: @escaping (WWEFeedModel?, NSError?) -> ())
    {
        NetworkManager.sharedInstance.getVideos(completionHandler: { (wweFeed, error) in
            completion(wweFeed, error)
        })
    }
}
