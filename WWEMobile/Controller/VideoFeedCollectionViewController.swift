//
//  VideoFeedCollectionViewController.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit

private let reuseIdentifier = "VideoCell"

class VideoFeedCollectionViewController: UICollectionViewController {

    var videosDataSource: VideosDataSource!
    var feed: WWEFeedModel!
    var selectedVideo: WWEVideoModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        videosDataSource = VideosDataSource()
        
        getVideos()
        
        // Register cell classes
        //self.collectionView!.register(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private Methods
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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
