//
//  WWEFeed.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class WWEFeed: Object {
    
    var videos = List<WWEVideo> ()
    
    static func create(json: JSON) -> WWEFeed {
        
        let feed = WWEFeed()
        
        let videoObjects = json[attributes.videos.rawValue].array
        
        for object in videoObjects! {
            let video = WWEVideo.create(json: object)
            
            feed.videos.append(video)
        }
        
        return feed
    }
}
