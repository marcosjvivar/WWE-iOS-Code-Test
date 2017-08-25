//
//  WWEVideoFormatModel.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON

open class WWEVideoFormatModel: NSObject {
    
    public var formatFLVRTMPRTMPE: Int = 0
    public var formath264M2TSRTMP: Int = 0
    public var formath264MP4HTTP: Int = 0
    public var formath264MP4RTMP: Int = 0

    init(json: JSON) {
        self.formatFLVRTMPRTMPE = json[attributes.flvRTMPRTMPE.rawValue].intValue
        self.formath264M2TSRTMP = json[attributes.h264M2TSRTMP.rawValue].intValue
        self.formath264MP4HTTP = json[attributes.h264MP4HTTP.rawValue].intValue
        self.formath264MP4RTMP = json[attributes.h264MP4RTMP.rawValue].intValue
    }
}
