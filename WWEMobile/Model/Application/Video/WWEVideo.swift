//
//  WWEVideoModel.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class WWEVideo: Object {
    
    dynamic var videoID: Int = 0
    dynamic var videoBody: String = ""
    dynamic var videoBrightcoveID: String = ""
    dynamic var videoDate: Int = 0
    dynamic var videoDuration: Int = 0
    var videoFormats = List<WWEVideoFormat> ()
    dynamic var videoIcon: Int = 0
    dynamic var videoMediaID: String = ""
    dynamic var videoNetworkContent: Int = 0
    dynamic var videoPlaybackURL: String = ""
    dynamic var videoThumbnail: String = ""
    dynamic var videoTitle: String = ""
    dynamic var videoType: String = ""
    dynamic var videoURL: String = ""
    var videoTags = List<WWEVideoTag> ()
    dynamic var videoVMSID: Int = 0
    dynamic var isLiked: Bool = false
    dynamic var isDisliked: Bool = false
    
    static func create(json: JSON) -> WWEVideo {
        
        let video = WWEVideo()
        
        video.videoID = json[attributes.id.rawValue].intValue
        video.videoBody = json[attributes.body.rawValue].stringValue
        video.videoBrightcoveID = json[attributes.brightcoveID.rawValue].stringValue
        video.videoDate = json[attributes.date.rawValue].intValue
        video.videoDuration = json[attributes.duration.rawValue].intValue
        
        let formatsObjects = json[attributes.formats.rawValue].array
        if (formatsObjects != nil) {
            for object in formatsObjects! {
                let format = WWEVideoFormat.create(json: object)
                
                video.videoFormats.append(format)
            }
        }
        
        video.videoIcon = json[attributes.icon.rawValue].intValue
        video.videoMediaID = json[attributes.mediaID.rawValue].stringValue
        video.videoNetworkContent = json[attributes.networkContent.rawValue].intValue
        video.videoPlaybackURL = json[attributes.playbackURL.rawValue].stringValue
        video.videoThumbnail = json[attributes.thumbnail.rawValue].stringValue
        video.videoTitle = json[attributes.title.rawValue].stringValue
        video.videoType = json[attributes.type.rawValue].stringValue
        video.videoURL = json[attributes.URL.rawValue].stringValue
        
        let tagsObjects = json[attributes.tags.rawValue].array
        if (tagsObjects != nil) {
            for object in tagsObjects! {
                let tag = WWEVideoTag.create(json: object)
                
                video.videoTags.append(tag)
            }
        }
        
        video.videoVMSID = json[attributes.vmsID.rawValue].intValue
        
        return video
    }
}
