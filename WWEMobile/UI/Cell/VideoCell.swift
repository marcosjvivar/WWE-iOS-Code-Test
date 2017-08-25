//
//  VideoCell.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import AlamofireImage

open class VideoCell: UICollectionViewCell {
    
    public var wweVideo: WWEVideoModel!
    
    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var videoView: UIView?
    @IBOutlet weak var frameView: UIView?
    
    @IBOutlet weak var videoThumbnail: UIImageView?
    
    @IBOutlet weak var videoDuration: UILabel?
    @IBOutlet weak var videoDate: UILabel?
    @IBOutlet weak var videoDescription: UILabel?
    
    public func updateUIComponents() {
        
        let thumbnailURLString = "\(WWE_BASE_URL)\(wweVideo.videoThumbnail)"
        let thumbnailURL = URL.init(string: thumbnailURLString)!
        
        self.videoThumbnail?.af_setImage(withURL: thumbnailURL)
        
        self.videoDuration?.text = "\(wweVideo.videoDuration)"
        self.videoDate?.text = "\(wweVideo.videoDate)"
        
        let untaggedDescription = wweVideo.videoBody.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        let escapedDescription = untaggedDescription.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
        
        self.videoDescription?.text = escapedDescription
    }
    
}
