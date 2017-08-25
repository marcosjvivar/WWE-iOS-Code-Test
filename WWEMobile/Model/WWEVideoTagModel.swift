//
//  WWEVideoTagModel.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON

open class WWEVideoTagModel: NSObject {
    
    public var tagID: Int = 0
    public var tagType: String = ""
    public var tagTitle: String = ""
    
    init(json: JSON) {
        self.tagID = json[attributes.id.rawValue].intValue
        self.tagTitle = json[attributes.title.rawValue].stringValue
        self.tagType = json[attributes.type.rawValue].stringValue
    }
}
