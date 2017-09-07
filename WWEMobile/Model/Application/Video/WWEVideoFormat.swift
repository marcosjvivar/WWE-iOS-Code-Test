//
//  WWEVideoFormat.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class WWEVideoFormat: Object {
    
    dynamic var formatFLVRTMPRTMPE: Int = 0
    dynamic var formath264M2TSRTMP: Int = 0
    dynamic var formath264MP4HTTP: Int = 0
    dynamic var formath264MP4RTMP: Int = 0

    static func create(json: JSON) -> WWEVideoFormat {
        
        let format = WWEVideoFormat()
        
        format.formatFLVRTMPRTMPE = json[attributes.flvRTMPRTMPE.rawValue].intValue
        format.formath264M2TSRTMP = json[attributes.h264M2TSRTMP.rawValue].intValue
        format.formath264MP4HTTP = json[attributes.h264MP4HTTP.rawValue].intValue
        format.formath264MP4RTMP = json[attributes.h264MP4RTMP.rawValue].intValue
        
        return format
    }
}
