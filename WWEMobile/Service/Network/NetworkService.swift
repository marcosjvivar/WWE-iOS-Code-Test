//
//  NetworkService.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/25/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit
import Foundation

import Alamofire
import SwiftyJSON

open class NetworkService {
    // MARK: - Request
    
    open class func performRequest(urlString: String, completionHandler completion: @escaping (JSON?, NSError?) -> Void) {
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler:{
            (response) in
            
            if(response.result.isFailure) {
                let error = response.result.error! as NSError?
                print("\nError: \(String(describing: error)) at host: \(urlString)")
                
                completion(nil, error)
            }
            else {
                let value = response.result.value
                let json = JSON(value as Any)
                
                //print("\nSuccess: \(String(describing: value))")
                
                completion(json, nil)
            }
        })
    }
    
    open class func performRequest(request: NSURLRequest, completionHandler completion: @escaping (JSON?, NSError?) -> Void) {
        Alamofire.request(request as! URLRequestConvertible).responseJSON(completionHandler: {
            (response) in
            
            if(response.result.isFailure) {
                let error = response.result.error! as NSError?
                print("\nError: \(String(describing: error))")
                
                completion(nil, error)
            }
            else {
                let value = response.result.value
                let json = JSON(value as Any)
                
                //print("\nSuccess: \(String(describing: value))")
                
                completion(json, nil)
            }
        })
    }
}
