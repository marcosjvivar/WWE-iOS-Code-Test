//
//  WWEFeedModel.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON

open class WWEFeedModel: NSObject {
    
    public var videos: [WWEVideoModel] = []
    
    init(json: JSON) {
        let videoObjects = json[attributes.videos.rawValue].array
        
        for object in videoObjects! {
            let video = WWEVideoModel.init(json: object)
            
            self.videos.append(video)
        }
    }
}
