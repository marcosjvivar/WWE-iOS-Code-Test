//
//  DBManager.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

private let _sharedInstance = DBManager()

open class DBManager: NSObject {
    
    // MARK: - Instantiation
    
    var db: Realm?
    
    var currentUser: WWEUser? {
        if let db = db {
            let users = db.objects(WWEUser.self)
            if let user = users.first {
                return user
            }
        }
        
        let user = WWEUser()
        self.saveEntry(user)
        
        return user
    }
    
    // MARK: - Instantiation
    open class var sharedInstance: DBManager {
        return _sharedInstance
    }
    
    override init() {
        super.init()
        do {
            self.db = try Realm()
        } catch let error as NSError {
            NSLog("Error opening realm: \(error)")
        }
    }
    
    // MARK: - Internal
    
    func saveEntry(_ object: Object, isUpdate: Bool? = false) {
        if let db = db {
            do {
                db.beginWrite()
                db.add(object, update: isUpdate!)
                try db.commitWrite()
            } catch let error as NSError {
                NSLog("### Realm ### Error writing: \(error)")
            }
        }
    }
    
    // MARK: - User

    func getUserProfile() -> WWEUser? {
        
        if let user = currentUser {
            return user
        } else {
            let user = WWEUser()
            self.saveEntry(user)
            return user
        }
    }
    
    // MARK: - Recents
    
    func getRecents() -> List<WWEVideo>? {
        
        return currentUser?.recents
    }
    
    func addRecents(_ newFeed: WWEFeed) {
        
        let reversedArray = newFeed.videos.reversed()
        
        for video in reversedArray {
            
            self.addRecent(video)
        }
    }
    
    func addRecent(_ newRecentVideo: WWEVideo) {
        if let user = currentUser, let db = db {
            do {
                try db.write({
                    
                    let recentsNew = user.recents.filter({ (recent) -> Bool in
                        return recent.videoID == newRecentVideo.videoID
                    })
                    guard recentsNew.count == 0 else {
                        return
                    }
                    
                    if user.recents.count == 20 {
                        user.recents.removeLast()
                    }
                    
                    user.recents.insert(newRecentVideo, at: 0)
                })
            } catch let error as NSError {
                NSLog("### Realm ### Error writing a new recent : \(error)")
            }
        } else {
            let user = WWEUser()
            user.recents.append(newRecentVideo)
            self.saveEntry(user)
        }
    }
    
    func removeRecent(_ recentVideo: WWEVideo) {
        if let user = currentUser, let db = db {
            do {
                try db.write {
                    if let indexLocation = user.recents.index(of: recentVideo) {
                        user.recents.remove(at: indexLocation)
                    } else {
                        let video = user.recents.filter {($0.videoID == recentVideo.videoID)}[0]
                        if let indexLocation = user.recents.index(of: video) {
                            user.recents.remove(at: indexLocation)
                        }
                    }
                }
            } catch let error as NSError {
                NSLog("### Realm ### Error removing a video: \(error)")
            }
        } else {
            let user = WWEUser()
            self.saveEntry(user)
        }
    }
    
    func updateRecent(_ recentVideo: WWEVideo, isLiked: Bool, isDisliked: Bool) {
        
        if let user = currentUser, let db = db {
            do {
                try db.write {
                    
                    let video = user.recents.filter {($0.videoID == recentVideo.videoID)}[0]
                    
                    let indexLocation = user.recents.index(of: video)
                    
                    recentVideo.isLiked = isLiked
                    recentVideo.isDisliked = isDisliked
                    
                    user.recents.replace(index: indexLocation!, object: recentVideo)
                }
                
            } catch let error as NSError {
                NSLog("### Realm ### Error updating a favorite : \(error)")
            }
        }
    }
    
    // MARK: - Tranforming Objects
}
