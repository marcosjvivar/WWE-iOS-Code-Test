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
    var feed: WWEFeed!
    var selectedVideo: WWEVideo!
    
    var videoContainer: UIView!
    var fullScreenPlayerViewController = AVPlayerViewController()
    
    var swipeDown: UISwipeGestureRecognizer?
    var swipeUp: UISwipeGestureRecognizer?
    var swipeLeft: UISwipeGestureRecognizer?
    
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
    
    // MARK: - Swipping Methods
    
    func swipeDownAction() {
        minimizeWindow(minimized: true, animated: true)
    }
    
    func swipeUpAction() {
        minimizeWindow(minimized: false, animated: true)
    }
    
    func swipeLeftAction() {

        UIView.animate(withDuration: 0.5, animations: { 
            self.videoContainer.removeFromSuperview()
        }) { (bool) in
            
            self.fullScreenPlayerViewController.player?.pause()
            self.fullScreenPlayerViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    func isMinimized() -> Bool {
        return CGFloat((self.videoContainer?.frame.origin.y)!) > CGFloat(20)
    }
    
    func minimizeWindow(minimized: Bool, animated: Bool) {
        
        if isMinimized() == minimized {
            return
        }
        
        var tallContainerFrame: CGRect
        
        if minimized == true {
            
            let mpWidth: CGFloat = 160
            let mpHeight: CGFloat = 90
            
            let x: CGFloat = self.view.bounds.size.width - mpWidth - 20
            let y: CGFloat = self.view.bounds.size.height - mpHeight - 20
            
            tallContainerFrame = CGRect(x: x, y: y, width: mpWidth, height: mpHeight)

        } else {
            
            tallContainerFrame = self.view.bounds
        }
        
        let duration: TimeInterval = (animated) ? 0.5 : 0.0
        
        UIView.animate(withDuration: duration, animations: {
            self.videoContainer.frame = tallContainerFrame
        })
    }
    
    
    // MARK: - Memory Management

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
        
        fullScreenPlayerViewController = AVPlayerViewController()
        fullScreenPlayerViewController.player = fullScreenPlayer
        fullScreenPlayerViewController.player?.play()
        
        self.videoContainer = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        self.view.addSubview(self.videoContainer)
        
        self.addChildViewController(fullScreenPlayerViewController)
        
        // Add the child's View as a subview
        self.videoContainer.addSubview(fullScreenPlayerViewController.view)
        fullScreenPlayerViewController.view.frame = self.view.bounds
        fullScreenPlayerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // tell the childviewcontroller it's contained in it's parent
        fullScreenPlayerViewController.didMove(toParentViewController: self)
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpAction))
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        
        swipeDown?.direction = .down
        swipeUp?.direction = .up
        swipeLeft?.direction = .left
        
        self.videoContainer.addGestureRecognizer(swipeDown!)
        self.videoContainer.addGestureRecognizer(swipeUp!)
        self.videoContainer.addGestureRecognizer(swipeLeft!)
    }

    // MARK: - UICollectionViewDataSource
    
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

    // MARK: - UICollectionViewDelegate

}
