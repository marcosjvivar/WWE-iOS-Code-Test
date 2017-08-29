//
//  DBManager.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import Foundation
import RealmSwift

private let _sharedInstance = DBManager()

class DBManager: NSObject {
    
    var db: Realm?
    
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
    
    // MARK: - TODO Like/Dislike Feature

}
