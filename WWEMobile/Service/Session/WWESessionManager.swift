//
//  WWESessionManager.swift
//  WWEMobile
//
//  Created by Marcos Jesús Vivar on 8/31/17.
//  Copyright © 2017 Spark Digital. All rights reserved.
//

import UIKit

private let _sharedInstance = WWESessionManager()

open class WWESessionManager: NSObject {
    
    // MARK: - Instantiation
    
    open class var sharedInstance: WWESessionManager {
        return _sharedInstance
    }
    
    override init() {}
    
    // MARK: - Security Setup
    
    public func setupValidCredentials() {
        
        let accountUsername = "wwe"
        let accountPassword = "wwe"
        
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if !hasLoginKey {
            UserDefaults.standard.setValue(accountUsername, forKey: "username")
        }
        
        do {
            
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: accountUsername,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            try passwordItem.savePassword(accountPassword)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
    }
    
    public func hasValidSession() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "hasValidSession")
    }
    
    public func setValidSession() {
        
        return UserDefaults.standard.set(true, forKey: "hasValidSession")
    }
    
    public func validateCredentials(username: String, password: String) -> Bool {
        
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        }
        catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        
        return false
    }
}
