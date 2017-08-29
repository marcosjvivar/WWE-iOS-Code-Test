//
//  VideoCell.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import AVFoundation

import AlamofireImage

private var videoCellKVOContext = 0

open class VideoCell: UICollectionViewCell {
    
    public var wweVideo: WWEVideoModel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    
    @IBOutlet weak var videoDuration: UILabel!
    @IBOutlet weak var videoDate: UILabel!
    @IBOutlet weak var videoDescription: UILabel!
    
    @IBOutlet weak var videoPlayButton: UIButton!
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    var playerItem: AVPlayerItem? = nil {
        didSet {
            player.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var player = AVPlayer()
    
    var playerLayer: AVPlayerLayer? {
        return playerView?.playerLayer
    }
    
    static let assetKeysRequiredToPlay = ["playable"]
    
    public func updateUIComponents() {
        
        let thumbnailURLString = "\(WWE_BASE_URL)\(wweVideo.videoThumbnail)"
        let thumbnailURL = URL.init(string: thumbnailURLString)!
        
        self.videoThumbnail?.af_setImage(withURL: thumbnailURL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: true, completion: { (response) in

            let videoURLString = "https:\(self.wweVideo.videoPlaybackURL)"
            let videoURL = URL.init(string: videoURLString)!
            
            self.asset = AVURLAsset(url: videoURL, options: nil)
            
            self.playerView.playerLayer.player = self.player
        })
        
        let duration = NSInteger(wweVideo.videoDuration)
        
        let seconds = (duration % 60)
        let minutes = ((duration / 60) % 60)

        let secondsString = seconds >= 10 ? "\(seconds)" : "0\(seconds)"
        let minutesString = "\(minutes)"
        
        self.videoDuration?.text = "\(minutesString):\(secondsString)"
        
        let timeResult: Double = Double(wweVideo.videoDate)
        let date = NSDate(timeIntervalSince1970: timeResult)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let localDate = dateFormatter.string(from: date as Date)
        
        self.videoDate?.text = localDate
        
        let untaggedDescription = wweVideo.videoBody.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        let escapedDescription = untaggedDescription.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
        
        self.videoDescription?.text = escapedDescription
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player.seek(to: kCMTimeZero)
                self.player.play()
            }
        })
    }
    
    func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {

        newAsset.loadValuesAsynchronously(forKeys: VideoCell.assetKeysRequiredToPlay) {
  
            DispatchQueue.main.async {
    
                guard newAsset == self.asset else { return }
  
                for key in VideoCell.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        
                        print("\(message)")
                        
                        return
                    }
                }
                
                // We can't play this asset.
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    
                    print("\(message)")
                    
                    return
                }

                self.playerItem = AVPlayerItem(asset: newAsset)
                
                UIView.animate(withDuration: 1.5, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.videoThumbnail?.alpha = 0
                }, completion: nil)
                
                self.player.isMuted = true
                self.player.play()
            }
        }
    }

    // MARK: - KVO Observation
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        guard context == &videoCellKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(VideoCell.player.currentItem.duration) {

            let newDuration: CMTime
            
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                
                newDuration = newDurationAsValue.timeValue
            }
            else {
                newDuration = kCMTimeZero
            }
            
            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            let newCurrentTime = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0
        }
        else if keyPath == #keyPath(VideoCell.player.currentItem.status) {

            let newStatus: AVPlayerItemStatus
            
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            }
            else {
                newStatus = .unknown
            }
            
            if newStatus == .failed {
                print("\(String(describing: player.currentItem?.error?.localizedDescription))")
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func playTapped(_ sender: UIButton) {
        
        let videoDictionary = [attributes.id.rawValue: "\(self.wweVideo.videoID)",
            attributes.playbackURL.rawValue: "https:\(self.wweVideo.videoPlaybackURL)",
            attributes.seekTime.rawValue: NSNumber.init(value: currentTime)
        ] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kVideoFullScreenNotification), object: nil, userInfo: videoDictionary)
    }
}
