//
//  VideoFeedCollectionViewController.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

private let reuseIdentifier = "VideoCell"

class VideoFeedCollectionViewController: UICollectionViewController {

    var videosDataSource: VideosDataSource!
    var feed: WWEFeedModel!
    var selectedVideo: WWEVideoModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        videosDataSource = VideosDataSource()
        
        getVideos()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playTapped(notification:)), name:NSNotification.Name(rawValue: kVideoFullScreenNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if !WWESessionManager.sharedInstance.hasValidSession() {
            showLoginScreen()
        }
        else
        {
            let logoutButton = UIBarButtonItem(image: UIImage.init(named: "logout"), style: .plain, target: self, action: #selector(logout))
            navigationItem.rightBarButtonItem = logoutButton
        }
    }
    
    // MARK: - Private Methods
    
    func showLoginScreen() {
        
        performSegue(withIdentifier: "loginScreen", sender: self)
    }
    
    func logout() {
        
        navigationItem.rightBarButtonItem = nil
        UserDefaults.standard.set(false, forKey: "hasValidSession")
        showLoginScreen()
    }
    
    func getVideos() {
        videosDataSource.getVideos(completionHandler: { (wweFeed, error) in
            
            if (wweFeed != nil) {
                self.feed = wweFeed
                self.updateUserInterface()
            }
            else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func updateUserInterface() {
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Notifications
    
    func playTapped(notification: Notification) {
        
        let videoDictionary = notification.userInfo
        
        let playbackURL = videoDictionary?[attributes.playbackURL.rawValue] as! String
        let videoURL = URL.init(string: playbackURL)
        let asset = AVURLAsset(url: videoURL!, options: nil)
        
        let item = AVPlayerItem.init(asset: asset, automaticallyLoadedAssetKeys: ["playable"])
        
        let playbackTime = videoDictionary?[attributes.seekTime.rawValue] as! Double
        let currentTime = CMTime.init(seconds: playbackTime, preferredTimescale: 1)
        
        let fullScreenPlayer = AVPlayer.init(playerItem: item)
        fullScreenPlayer.seek(to: currentTime)
        
        let fullScreenPlayerViewController = AVPlayerViewController()
        fullScreenPlayerViewController.player = fullScreenPlayer
        fullScreenPlayerViewController.player?.play()
        
        self.present(fullScreenPlayerViewController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ((self.feed != nil) && (self.feed.videos.count > 0)) {
            return self.feed.videos.count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
        
        let video = self.feed.videos[indexPath.row]
        
        cell.wweVideo = video
        
        cell.updateUIComponents()
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
