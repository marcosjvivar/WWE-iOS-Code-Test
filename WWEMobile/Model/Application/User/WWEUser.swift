//
//  WWEUser.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 9/1/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import RealmSwift

class WWEUser: Object
{
    dynamic var name = "DeviceiOS"
    
    var recents = List<WWEVideo> ()
}
