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
    
    func getVideos(completionHandler completion: @escaping (WWEFeed?, NSError?) -> ())
    {
        let feed = WWEFeed()
        
        feed.videos = DBManager.sharedInstance.getRecents()!
        
        NetworkManager.sharedInstance.getVideos(completionHandler: { (wweFeed, error) in
            
            let newestVideo = wweFeed?.videos.first
            
            if feed.videos.count == 20 {
                
                let lastSavedVideo = feed.videos.first
                
                if lastSavedVideo?.videoID == newestVideo?.videoID
                {
                    completion(feed, nil)
                }
            }
            else
            {
                DBManager.sharedInstance.addRecents(wweFeed!)
                
                completion(wweFeed, error)
            }
        })
    }
}
