//
//  WWEVideoModel.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON

open class WWEVideoModel: NSObject {
    
    public var videoID: Int = 0
    public var videoBody: String = ""
    public var videoBrightcoveID: String = ""
    public var videoDate: Int = 0
    public var videoDuration: Int = 0
    public var videoFormats: [WWEVideoFormatModel] = []
    public var videoIcon: Int = 0
    public var videoMediaID: String = ""
    public var videoNetworkContent: Int = 0
    public var videoPlaybackURL: String = ""
    public var videoThumbnail: String = ""
    public var videoTitle: String = ""
    public var videoType: String = ""
    public var videoURL: String = ""
    public var videoTags: [WWEVideoTagModel] = []
    public var videoVMSID: Int = 0
    
    init(json: JSON) {
        self.videoID = json[attributes.id.rawValue].intValue
        self.videoBody = json[attributes.body.rawValue].stringValue
        self.videoBrightcoveID = json[attributes.brightcoveID.rawValue].stringValue
        self.videoDate = json[attributes.date.rawValue].intValue
        self.videoDuration = json[attributes.duration.rawValue].intValue
        
        let formatsObjects = json[attributes.formats.rawValue].array
        if (formatsObjects != nil) {
            for object in formatsObjects! {
                let format = WWEVideoFormatModel.init(json: object)
                
                self.videoFormats.append(format)
            }
        }
        
        self.videoIcon = json[attributes.icon.rawValue].intValue
        self.videoMediaID = json[attributes.mediaID.rawValue].stringValue
        self.videoNetworkContent = json[attributes.networkContent.rawValue].intValue
        self.videoPlaybackURL = json[attributes.playbackURL.rawValue].stringValue
        self.videoThumbnail = json[attributes.thumbnail.rawValue].stringValue
        self.videoTitle = json[attributes.title.rawValue].stringValue
        self.videoType = json[attributes.type.rawValue].stringValue
        self.videoURL = json[attributes.URL.rawValue].stringValue
        
        let tagsObjects = json[attributes.tags.rawValue].array
        if (tagsObjects != nil) {
            for object in tagsObjects! {
                let tag = WWEVideoTagModel.init(json: object)
                
                self.videoTags.append(tag)
            }
        }
        
        self.videoVMSID = json[attributes.vmsID.rawValue].intValue
    }
}
