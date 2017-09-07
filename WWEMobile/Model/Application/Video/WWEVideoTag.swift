//
//  WWEVideoTag.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class WWEVideoTag: Object {
    
    dynamic var tagID: Int = 0
    dynamic var tagType: String = ""
    dynamic var tagTitle: String = ""
    
    static func create(json: JSON) -> WWEVideoTag {
        
        let tag = WWEVideoTag()
        
        tag.tagID = json[attributes.id.rawValue].intValue
        tag.tagTitle = json[attributes.title.rawValue].stringValue
        tag.tagType = json[attributes.type.rawValue].stringValue
        
        return tag
    }
}
